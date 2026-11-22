# Makefile for make7 and gcc from MinGW. Commands executed by: cmd.exe
# To compile use a Windows console and call:
#   ..\bin\make7 -f mk_mingc.mak depend
#   ..\bin\make7 -f mk_mingc.mak
# When your make utility uses Unix commands, you should use mk_msys.mak instead.
# When the nmake utility from Windows is available, you can use mk_nmake.mak instead.
# When you are using the MSYS console from MinGW you should use mk_msys.mak instead.

# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS)
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
CC = ..\bin\call_gcc
AR = ..\bin\call_ar
MAKEFILE_NAME = mk_mingc.mak
VERS_FILE = vers_mingc.h
S7_OUT = ..\bin\s7
VERBOSE_HINTS = no
INSTALL_USE_SUDO = yes
TEST_HINT = none
DEPEND_STYLE = wrdepend_quiet
SQL_CFLAGS = $(CFLAGS_NO_FLTO)
LEVELUP_FLAGS = -w
CHKCCOMP_FLAGS = -w
SETWPATH_FLAGS = -w
WRDEPEND_FLAGS = -w
TEST_C_COMPILER = ../bin/call_gcc
LINKER_OPT_STATIC = -static
CHKCCOMP_CC_FLAGS = -ffunction-sections -fdata-sections
CC_FLAGS64 = -Wa,-mbig-obj
CC_OPT_LTO = -flto=auto
CC_OPT_PIC = -fPIC
LINKER_OPT_NO_LTO = -fno-lto
INT_DIV_OVERFLOW_LOOP = yes
C_COMPILER_SCRIPT = call_gcc
BASE_ARCHIVER = ..\\bin\\call_ar
FORMAT_LL_WARN = yes

include mk_wing.mak
