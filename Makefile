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

# package
LDC_PATH = ldc2-$(LDC_VER)-linux-x86_64
LDC_GZ   = $(LDC_PATH).tar.xz
LDC_URL  = https://github.com/ldc-developers/ldc/releases/download/v$(LDC_VER)

# tool
CURL   = curl -L -o
CF     = clang-format -style=file
REF    = git clone --depth 1 -o gh
DMD    = /usr/bin/dmd
LDC    = $(CWD)/$(LDC_PATH)/bin/ldc2
DC     = $(DMD)
DUB    = /usr/bin/dub
RUN    = $(DUB) run   --compiler=$(DC)
BLD    = $(DUB) build --compiler=$(DC)

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
D += $(wildcard src/*.d*)
J += dub.json
F += lib/$(MODULE).ini $(wildcard lib/*.f*)

CD = $(wildcard config/src/*.d*)
D += $(CD)
J += config/dub.json

D += $(wildcard server/src/*.d*)
J += server/dub.json

WD = $(wildcard wasm/src/*.d*)
D += $(WD)
J += wasm/dub.json
WB = $(subst .d,.o  ,$(subst wasm/src/,bin/,$(WD)))
WT = $(subst .o,.wat,$(subst      bin/,tmp/,$(WB)))

# all
.PHONY: all
all: bin/wasd_server wasm

.PHONY: server
server: bin/wasd_server $(F)
	$^
bin/wasd_server: $(D) $(J) static/*
	$(BLD) :server

# wasm
.PHONY: wasm
wasm: $(WT)
tmp/%.wat: bin/%.o
	wasm2wat $< -o $@
$(WB): bin/libwasm.a
	ar x $< --output=bin
bin/libwasm.a: $(WD) $(CD) $(J)
	$(DUB) build --compiler=$(LDC) :wasm

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
gz:  $(DMD) $(DUB) $(LDC)
ref: ref/druntime ref/phobos

ref/druntime:
	$(REF) https://github.com/ponyatov/druntime.git $@

ref/phobos:
	$(REF) https://github.com/ponyatov/phobos.git $@

$(LDC): $(DISTR)/SDK/$(LDC_GZ)
	xzcat $< | tar x && touch $@
$(DISTR)/SDK/$(LDC_GZ):
	$(CURL) $@ $(LDC_URL)/$(LDC_GZ)
