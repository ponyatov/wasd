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
REF    = git clone --depth 1 -o gh
DMD    = /usr/bin/dmd
LDC    = ldc2
DC     = $(DMD)
DUB    = /usr/bin/dub
RUN    = $(DUB) run   --compiler=$(DC)
BLD    = $(DUB) build --compiler=$(DC)

# package
LDC_GZ  = ldc2-$(LDC_VER)-linux-x86_64.tar.xz
LDC_URL = https://github.com/ldc-developers/ldc/releases/download/v$(LDC_VER)

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
D += $(wildcard src/*.d*)
J += dub.json
F += lib/$(MODULE).ini $(wildcard lib/*.f*)

D += $(wildcard server/src/*.d*)
J += server/dub.json

D += $(wildcard wasm/src/*.d*)
J += wasm/dub.json

# all
.PHONY: all
all: $(D) $(J) $(F) tmp/libwasd.objdump
	$(BLD) :wasm && $(RUN) :server -- $(F)
tmp/libwasd.objdump: bin/libwasd.a Makefile
	objdump -x $< > $@
bin/libwasd.a: $(D)
	$(BLD)

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
gz:  $(DMD) $(DUB) $(DISTR)/SDK/$(LDC_GZ)
ref: ref/druntime ref/phobos

ref/druntime:
	$(REF) https://github.com/ponyatov/druntime.git $@

ref/phobos:
	$(REF) https://github.com/ponyatov/phobos.git $@

$(DISTR)/SDK/$(LDC_GZ):
	$(CURL) $@ $(LDC_URL)/$(LDC_GZ)
