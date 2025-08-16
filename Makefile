# compiler and flags
CC = clang
# enables warnings, extra warnings, check for headers in include, and include debug symbols, in that order
CFLAGS = -Wall -Wextra -Iinclude -g

# build target
TARGET = noodling

# source files, all c files in src/
SRCS = $(wildcard src/*.c)
# object files, simply converts all .c filenames into .o filenames
OBJS = $(SRCS:.c=.o)

all: $(TARGET)


# to build the target, check if all object files exist. If it does not exist, apply the pattern rule below and generate the object files.
# once the object files exist, run a command similar to the one below:
# clang -Wall -Wextra -Iinclude -g -c src/main.c -o src/main.o
# The $@, $^, and $< are automatic variables, referring to the target, all prerequisites, and the first prerequisite, in that order.

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
