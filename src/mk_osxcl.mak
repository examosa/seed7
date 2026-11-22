# Makefile for Mac OS X with clang from Xcode. Commands executed by: bash
# To compile use a command shell and call:
#   make -f mk_osxcl.mak depend
#   make -f mk_osxcl.mak
# If you are not using Mac OS X with Xcode look into the file read_me.txt for the makefile to use.

# CFLAGS =
# CFLAGS = -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar -Wc++-compat
# CFLAGS = -O2 -g -x c++ -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wextra -Wswitch-default -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
# CFLAGS = -O2 -g -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv
# CFLAGS = -O2 -g -x c++ $(INCLUDE_OPTIONS) -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS)  -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv
CFLAGS = $(CC_OPT_LINK_TIME_OPTIMIZATION) $(CFLAGS_NO_FLTO)
# CFLAGS = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv -fsanitize=address,integer,undefined -fno-sanitize=unsigned-integer-overflow
# CFLAGS = -O2 -g -std=c99 -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS =
# LDFLAGS = -Wl,-L/usr/X11R6/lib
# LDFLAGS = -Wl,-L/usr/X11R6/lib -fsanitize=address,integer,undefined -fno-sanitize=unsigned-integer-overflow
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS =
# SYSTEM_LIBS = -lm -ldl -lgmp
# SYSTEM_LIBS = -lm_p -lc_p
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_CONSOLE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DRAW_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# CC = clang++
CC = clang
CXX = $(CC) -x c++
VERS_FILE = vers_osxcl.h
SQL_PARTIAL_LINK = no
INSTALL_STYLE = osx
CC_OPT_TRAP_OVERFLOW = -ftrapv
LINKER_OPT_STATIC =
LINKER_OPT_NO_LTO =
PARTIAL_LINK_OPTS =
X11_LIBRARY_PATH = /usr/X11R6/lib
LINKER_OPT_NO_DEBUG_INFO =

include mk_unix.mak

.PHONY: dep
dep: depend
