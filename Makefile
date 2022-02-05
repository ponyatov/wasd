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

APP ?= $(MODULE)
HW  ?= qemu386
include  app/$(APP).mk
include   hw/$(HW).mk
include  cpu/$(CPU).mk
include arch/$(ARCH).mk

# \ version
VER        ?= 0.0.1
KAITAI_VER  = 0.9
BR_VER      = 2021.11.1
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
# source code collection
GZ      = $(HOME)/gz
# firmware directory (ROMs and disk images)
FW      = $(CWD)/boot
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
C += $(shell find src -maxdepth 1 -type f -regex ".+.cpp$$")
H += $(shell find src -maxdepth 1 -type f -regex ".+.hpp$$")
S += $(C) $(H)
# F-script
F += $(shell find lib -maxdepth 1 -type f -regex ".+.f$$")
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
install: $(OS)_install
	mkdir -p $(GZ) ; $(MAKE) gz
	sudo dpkg -i $(GZ)/$(KAITAI_DEB)
	$(MAKE) update

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

$(GZ)/$(KAITAI_DEB):
	$(CURL) $@ $(KAITAI_GIT)/releases/download/$(KAITAI_VER)/$(KAITAI_DEB)

BR     = buildroot-$(BR_VER)
BR_ZIP = $(BR).tar.gz
BR_URL = https://github.com/buildroot/buildroot/archive/refs/tags/$(BR_VER).tar.gz

$(GZ)/$(BR_ZIP):
	$(CURL) $@ $(BR_URL)

.PHONY: gz
gz: $(GZ)/$(KAITAI_DEB) $(GZ)/$(BR_ZIP)
# / gz
# / install

# \ buildroot
HOSTNAME    = $(shell echo $(APP) | tr A-Z a-z)

BR_CFG      = $(CWD)/any/any.br
BR_CFG     += $(CWD)/arch/$(ARCH).br
BR_CFG     += $(CWD)/cpu/$(CPU).br
BR_CFG     += $(CWD)/hw/$(HW).br
BR_CFG     += $(CWD)/app/$(APP).br

KERNEL_CFG  = $(CWD)/arch/$(ARCH).kernel
KERNEL_CFG += $(CWD)/cpu/$(CPU).kernel
KERNEL_CFG += $(CWD)/hw/$(HW).kernel

KERNEL_CONFIG  = $(TMP)/config.kernel
KERNEL_CFG    += $(KERNEL_CONFIG)
KERNEL_CFG    += $(CWD)/app/$(APP).kernel


.PHONY: br
br: $(SRC)/$(BR)/README
	cd $(SRC)/$(BR) ; rm -f .config ; \
	make allnoconfig ; \
	cat  $(BR_CFG) >> .config ; \
	echo 'BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="$(CWD)/any/any.kernel"' >> .config ; \
	echo 'BR2_TARGET_GENERIC_HOSTNAME="$(HOSTNAME)"' >> .config ; \
	echo 'BR2_TARGET_GENERIC_ISSUE="$(APP) @ $(HW) (c) SSAU Kontur"' >> .config ; \
	echo 'BR2_ROOTFS_OVERLAY="$(CWD)/fs"' >> .config ; \
	echo 'BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="$(KERNEL_CFG)"' >> .config ; \
	make menuconfig
	$(MAKE) kernel

.PHONY: kernel
kernel: $(SRC)/$(BR)/README
	cd $(SRC)/$(BR) ; \
	echo 'CONFIG_DEFAULT_HOSTNAME="$(HOSTNAME)"' > $(KERNEL_CONFIG) ; \
	make linux-menuconfig && \
	make -j$(CORES)

$(SRC)/$(BR)/README: $(GZ)/$(BR_ZIP)
	cd src ; tar zx < $< && touch $@

QEMU = qemu-system-$(ARCH)
.PHONY: qemu
qemu:
	$(QEMU) $(QEMU_BOOT)
# / buildroot

# \ merge
MERGE  = README.md Makefile .gitignore apt.dev apt.txt $(S)
MERGE += .vscode bin doc lib src tmp
MERGE += requirements.txt .clang-format doxy.gen
MERGE += $(MODULE).pro
MERGE += any app hw cpu arch boot fs

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
