# Paths
OBJDIR := build
SRCDIR := src
SRC := $(SRCDIR)/main.asm
SRCDEPS := $(wildcard $(SRCDIR)/*.asm)
PRG := $(OBJDIR)/64pac.prg
LAB := $(OBJDIR)/64pac.lab
LST := $(OBJDIR)/64pac.lst
D64 := $(OBJDIR)/64pac.d64
ASM := 64tass

# Commands
MKPRG = $(ASM) -a -m -L $(LST) -l $(LAB) --vice-labels -o $(PRG) $(SRC)
RM := rm -rf
MKDIR := mkdir -p
MKD64 = c1541 -format ed,ed d64 $@ $(foreach p,$(PRG),-write $(p) $(subst .prg,,$(subst build/,,$(p))))

# Targets
.PHONY: all clean

all: $(D64)

$(PRG): | $(OBJDIR)

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

clean:
	$(RM) $(OBJDIR) *.o

# Rules
$(PRG): $(SRCDEPS)
	$(MKPRG)

$(D64): $(PRG) 
	$(MKD64)
