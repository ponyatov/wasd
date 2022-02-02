# \ var
# detect module/project name by current directory
MODULE  = $(notdir $(CURDIR))
# detect OS name (only Linux/MinGW)
OS      = $(shell uname -s)
# host machine architecture (for cross-compiling)
MACHINE = $(shell uname -m)
# current date in the `ddmmyy` format
NOW     = $(shell date +%d%m%y)
# release hash: four hex digits (for snapshots)
REL     = $(shell git rev-parse --short=4 HEAD)
# current git branch
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
# your own private working branch name
SHADOW ?= shadow
# number of CPU cores (for parallel builds)
CORES   = $(shell grep processor /proc/cpuinfo| wc -l)
# / var

# \ version
VER        ?= 0.0.1
KAITAI_VER  = 0.9
# / version

# \ dir
# current (project) directory
CWD     = $(CURDIR)
# compiled/executable files (target dir)
BIN     = $(CWD)/bin
# documentation & external manuals download
DOC     = $(CWD)/doc
# libraries / scripts
LIB     = $(CWD)/lib
# source code (not for all languages, Rust/C/Java included)
SRC     = $(CWD)/src
# temporary/flags/generated files
TMP     = $(CWD)/tmp
# / dir

# \ tool
# http/ftp download
CURL    = curl -L -o
PY      = $(shell which python3)
PIP     = $(shell which pip3)
PYT     = $(shell which pytest)
PEP     = $(shell which autopep8)
PEPS    = E265,E302,E401,E402,E702
KAITAI  = kaitai-struct-compiler
CF      = clang-format-11 -style=file
CC     ?= gcc
CXX    ?= g++
# / tool

# \ src
# Python
Y += $(MODULE).py config.py
S += $(Y)
# C++
C += $(shell find src -type f -regex ".+.cpp$$")
H += $(shell find src -type f -regex ".+.hpp$$")
S += $(C) $(H)
# F-script
F += $(shell find lib -type f -regex ".+.f$$")
S += $(F)
# parser
CP += tmp/$(MODULE).parser.cpp tmp/$(MODULE).lexer.cpp
HP += tmp/$(MODULE).parser.hpp
S  += src/$(MODULE).lex src/$(MODULE).yacc
# / src

# \ cfg
# / cfg

# \ all
.PHONY: all

#all: $(PYT) $(MODULE).py
#	$^
#	$(MAKE) tmp/format_py

all: bin/$(MODULE) lib/$(MODULE).f
	$^
	$(MAKE) tmp/format_cpp
# / all

# \ format
tmp/format_py: $(Y)
	$(PEP) --ignore=$(PEPS) -i $? && touch $@
tmp/format_cpp: $(C) $(H)
	$(CF) -i $? && touch $@
# / format

# \ rule
bin/$(MODULE): $(MODULE).mk $(C) $(CP) $(H) $(HP)
	$(MAKE) -f $<
$(MODULE).mk: $(MODULE).pro
	qmake -o $@ $<
tmp/$(MODULE).parser.cpp: src/$(MODULE).yacc
	bison -o $@ $<
tmp/$(MODULE).lexer.cpp: src/$(MODULE).lex
	flex -o $@ $<
# / rule

# \ doc

# \ install
.PHONY: install update
install: $(OS)_install gz
	$(MAKE) update
	sudo dpkg -i tmp/$(KAITAI_DEB)

update: $(OS)_update $(PIP)
	$(PIP) install --user -U pip autopep8 pytest
	$(PIP) install --user -U -r requirements.txt

.PHONY: Linux_install Linux_update
Linux_install Linux_update:
	sudo apt update
	sudo apt install -u `cat apt.dev apt.txt`

# \ gz
KAITAI_DEB = kaitai-struct-compiler_$(KAITAI_VER)_all.deb

KAITAI_GIT = https://github.com/kaitai-io/kaitai_struct_compiler

tmp/$(KAITAI_DEB):
	$(CURL) $@ $(KAITAI_GIT)/releases/download/$(KAITAI_VER)/$(KAITAI_DEB)

.PHONY: gz
gz: tmp/$(KAITAI_DEB)
# / gz
# / install

# \ merge
MERGE  = README.md Makefile .gitignore apt.dev apt.txt $(S)
MERGE += .vscode bin doc lib src tmp
MERGE += requirements.txt .clang-format doxy.gen
MERGE += $(MODULE).pro

.PHONY: shadow
shadow:
	git push -v
	git checkout $@
	git pull -v

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout $(SHADOW) -- $(MERGE)

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) shadow

.PHONY: zip
ZIP = $(TMP)/$(MODULE)_$(BRANCH)_$(NOW)_$(REL).src.zip
zip:
	git archive --format zip --output $(ZIP) HEAD
	$(MAKE) doxy ; zip -r $(ZIP) docs
# / merge
