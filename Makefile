# var
MODULE  = $(notdir $(CURDIR))
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES  ?= $(shell grep processor /proc/cpuinfo | wc -l)

# version
D_VER   = 2.108.0
LDC_VER = 1.38.0

# dir
CWD   = $(CURDIR)
GZ    = $(HOME)/gz
DISTR = $(HOME)/distr

# tool
CURL   = curl -L -o
CF     = clang-format -style=file
DMD    = dmd
LDC    = ldc2
DC     = $(DMD)
DUB    = /usr/bin/dub
RUN    = $(DUB) run   --compiler=$(DC)
BLD    = $(DUB) build --compiler=$(DC)

# package
LDC_GZ = ldc2-$(LDC_VER)-linux-x86_64.tar.xz

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
D += $(wildcard src/*.d*) $(wildcard server/src/*.d*)
J += dub.json server/dub.json
F += lib/$(MODULE).ini $(wildcard lib/*.f*)

# all
.PHONY: all
all: $(D) $(J) $(F)
	$(BLD) && $(RUN) :server -- $(F)

# format
.PHONY: format
format: tmp/format_c tmp/format_d
tmp/format_c: $(C) $(H)
	$(CF) -i $? && touch $@
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@

# doc
.PHONY: doc
doc:

# doc
.PHONY: doxy
doxy: .doxygen $(C) $(H) $(D) README.md
	rsync -r ~/metadoc/WASD doc/
	rsync -r ~/metadoc/WASM doc/
	git add doc
	rm -rf docs ; doxygen $< 1>/dev/null

# install
.PHONY: install update gz ref
install: doc gz ref
	$(MAKE) update
	$(BLD) dfmt
update:
	sudo apt update
	sudo apt install -yu `cat apt.txt`
gz: $(DISTR)/SDK/$(LDC_GZ)
ref: ref/druntime

ref/druntime:
	git clone --depth 1 -o gh https://github.com/ponyatov/druntime.git $@

$(DISTR)/SDK/$(LDC_GZ):
	$(CURL) $@ https://github.com/ldc-developers/ldc/releases/download/v1.38.0/$(LDC_GZ)
