# Makefile for linux/bsd/unix and gcc. Commands executed by: bash
# To compile use a command shell and call:
#   make -f mk_linux.mak depend
#   make -f mk_linux.mak
# If you are under windows you should use MinGW with mk_mingw.mak, mk_nmake.mak or mk_msys.mak instead.

# CFLAGS =
# CFLAGS = -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -x c++ -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wextra -Wswitch-default -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
# CFLAGS = -O2 -g -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv
# CFLAGS = -O2 -g -x c++ -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -ffunction-sections -fdata-sections -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv
# CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar -Wc++-compat
CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -Wstrict-aliasing -Wstrict-overflow -Wuninitialized
# CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS = $(CC_OPT_LINK_TIME_OPTIMIZATION) $(CFLAGS_NO_FLTO)
# CFLAGS = -O2 -g -std=c99 -D_POSIX_SOURCE -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -std=c1x -D_XOPEN_SOURCE -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -Wl,--gc-sections
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS =
# SYSTEM_LIBS = -lm -ldl -lgmp
# SYSTEM_LIBS = -lm_p -lc_p
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_CONSOLE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DRAW_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# CC = g++
CC = gcc
CXX = g++
VERS_FILE = vers_linux.h

include mk_unix.mak
