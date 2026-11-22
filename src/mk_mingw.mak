# Makefile for mingw32-make and gcc from MinGW. Commands executed by: cmd.exe
# To compile use a Windows console and call:
#   mingw32-make -f mk_mingw.mak depend
#   mingw32-make -f mk_mingw.mak
# When your make utility uses Unix commands, you should use mk_msys.mak instead.
# When the nmake utility from Windows is available, you can use mk_nmake.mak instead.
# When you are using the MSYS console from MinGW you should use mk_msys.mak instead.

# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS = $(CC_OPT_LINK_TIME_OPTIMIZATION) $(CFLAGS_NO_FLTO)
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -Wl,--gc-sections,--stack,8388608
# LDFLAGS = -Wl,--gc-sections,--stack,8388608,--subsystem,windows
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS = -lws2_32
# SYSTEM_LIBS = -lm -lws2_32 -lgmp
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# CC = g++
CC = gcc
AR = ar
MAKEFILE_NAME = mk_mingw.mak
VERS_FILE = vers_mingw.h
S7_OUT = ..\bin\s7
SQL_PARTIAL_LINK = yes
SQL_CFLAGS = $(CFLAGS_NO_FLTO)
LINKER_OPT_STATIC = -static
CHKCCOMP_CC_FLAGS = -ffunction-sections -fdata-sections
CC_FLAGS64 = -Wa,-mbig-obj
CC_OPT_LTO = -flto=auto
CC_OPT_PIC = -fPIC
LINKER_OPT_NO_LTO = -fno-lto
PARTIAL_LINK_OPTS = "-r"
INT_DIV_OVERFLOW_LOOP = yes
BASE_ARCHIVER = $(AR)
FORMAT_LL_WARN = yes

include mk_wing.mak
