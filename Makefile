# Makefile for cross-platform C Development
# Theoretically should build the project for both native linux and windows using clang and mingw-w64
#
# Directory layout:
# src/        -> source files
# include/    -> headers
# build/      -> per-platform object files
# bin/        -> Linux output
# /mnt/p/../bin/ -> Windows binary output on the windows host drive, will need to be hardcoded on a different device
#
# Usage:
# make -j     -> makes both
# make linux  -> builds linux
# make windows-> builds windows
# make clean  -> cleans Directory




# tells make these aren't real files (just in case I name things poorly)
.PHONY: clean all linux windows




#-------------------------------------------------------------
#COMPILER CONFIG
#-------------------------------------------------------------

#Linux build uses clang
CC = clang
# enables warnings, extra warnings, check for headers in include, and include debug symbols, in that order
CFLAGS = -Wall -Wextra -Iinclude -g
TARGET_LINUX = bin/noodling

# Windows-specific config using MingGW-w64
WIN_CC = x86_64-w64-mingw32-gcc
WIN_CFLAGS = -Wall -Wextra -Iinclude -g
# build a GUI subsystem binary (aka no console)
WIN_LDFLAGS = -mwindows
WINDOWS_OUTDIR = /mnt/p/Development/CProjects/Noodling/bin/
TARGET_WINDOWS = $(WINDOWS_OUTDIR)/noodling.exe

#------------------------------------------------------------ 
#SOURCE AND OBJ FILES
#------------------------------------------------------------

# source files, all c files in src/
SRCS = $(wildcard src/*.c)

#platform-specific object directories
LINUX_OBJDIR = build/linux
WIN_OBJDIR = build/windows


# object files, simply converts all .c filenames into .o filenames
OBJS = $(SRCS:src/%.c=$(LINUX_OBJDIR)/%.o)

# Windows object files
WIN_OBJS = $(SRCS:src/%.c=$(WIN_OBJDIR)/%.o)

all: linux windows

linux: $(TARGET_LINUX)

$(TARGET_LINUX): $(OBJS) | bin
	$(CC) $(CFLAGS) $^ -o $@

$(LINUX_OBJDIR)/%.o: src/%.c | $(LINUX_OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(LINUX_OBJDIR):
	mkdir -p $(LINUX_OBJDIR)


# windows build

windows: $(TARGET_WINDOWS)

$(TARGET_WINDOWS): $(WIN_OBJS) | $(WIN_OBJDIR) $(WINDOWS_OUTDIR)
	$(WIN_CC) $(WIN_CFLAGS) $^ -o $@ $(WIN_LDFLAGS)

$(WIN_OBJDIR)/%.o: src/%.c | $(WIN_OBJDIR)
	$(WIN_CC) $(WIN_CFLAGS) -c $< -o $@

$(WIN_OBJDIR): 
	mkdir -p $(WIN_OBJDIR)

$(WINDOWS_OUTDIR):
	mkdir -p $(WINDOWS_OUTDIR)
clean: 
	rm -rf build $(TARGET_LINUX) $(TARGET_WINDOWS)

bin:
	mkdir -p bin

# to build the target, check if all object files exist. If it does not exist, apply the pattern rule below and generate the object files.
# once the object files exist, run a command similar to the one below:
# clang -Wall -Wextra -Iinclude -g -c src/main.c -o src/main.o
# The $@, $^, and $< are automatic variables, referring to the target, all prerequisites, and the first prerequisite, in that order.
