# Cross-platform Makefile for C projects
# Works on Linux/WSL and native Windows PowerShell
# Windows Clang emits PDB debug info for VS

.PHONY: all clean linux windows

#-------------------------------------------------------------
# DETECT PLATFORM
#-------------------------------------------------------------
ifeq ($(OS),Windows_NT)
    IS_WINDOWS = 1
else
    IS_WINDOWS = 0
endif

#-------------------------------------------------------------
# COMPILER AND FLAGS
#-------------------------------------------------------------
ifeq ($(IS_WINDOWS),1)
    CC = clang
    # Debug info for Visual Studio
    CFLAGS = -Wall -Wextra -Iinclude -gcodeview -fmsc-version=1933
    LDFLAGS = -mwindows -luser32 -lgdi32 -gcodeview -Xlinker /DEBUG
    OBJDIR = build/windows
    OUTDIR = bin/windows
    EXE_EXT = .exe
else
    CC = clang
    CFLAGS = -Wall -Wextra -Iinclude -g
    LDFLAGS =
    OBJDIR = build/linux
    OUTDIR = bin/linux
    EXE_EXT =
endif

#-------------------------------------------------------------
# SOURCE AND OBJECT FILES
#-------------------------------------------------------------
SRCS = $(wildcard src/*.c)
OBJS = $(SRCS:src/%.c=$(OBJDIR)/%.o)

#-------------------------------------------------------------
# TARGET
#-------------------------------------------------------------
TARGET = $(OUTDIR)/noodling$(EXE_EXT)

#-------------------------------------------------------------
# RULES
#-------------------------------------------------------------
all: $(TARGET)

$(TARGET): $(OBJS) | $(OBJDIR) $(OUTDIR)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(OBJDIR)/%.o: src/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# PowerShell-compatible directory creation
$(OBJDIR):
ifeq ($(IS_WINDOWS),1)
	PowerShell -Command "New-Item -ItemType Directory -Force -Path '$(OBJDIR)' | Out-Null"
else
	mkdir -p $(OBJDIR)
endif

$(OUTDIR):
ifeq ($(IS_WINDOWS),1)
	PowerShell -Command "New-Item -ItemType Directory -Force -Path '$(OUTDIR)' | Out-Null"
else
	mkdir -p $(OUTDIR)
endif

#-------------------------------------------------------------
# CLEAN
#-------------------------------------------------------------
clean:
ifeq ($(IS_WINDOWS),1)
	PowerShell -Command "Remove-Item -Recurse -Force build, bin"
else
	rm -rf build bin
endif
