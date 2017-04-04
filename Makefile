CC := gcc
CCFLAGS := -Wall -Wextra

SRC-C := $(wildcard src-c/*.c)
SRC-CBL := $(wildcard src-cbl/*.cbl) $(wildcard src-cbl/controllers/*.cbl)

.SUFFIXES: .c .o

COBJ := $(SRC-C:.c=.o)

all: the.cow

build:
	mkdir -p build

$(COBJ): $(LSRC) build
	@echo "CC $@"
	$(eval SRC_FILE = $*.c)
	@$(CC) $(CCFLAGS) -c $(SRC_FILE) -o $@

the.cow: $(COBJ) $(SRC-CBL)
	cobc -static -x -free -o $@ $(SRC-CBL) -lhiredis $(COBJ)
