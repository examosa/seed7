# Makefile for gmake and gcc from MinGW. Commands executed by: bash
# To compile use a MSYS console and call:
#   mingw32-make -f mk_msys.mak depend
#   mingw32-make -f mk_msys.mak
# It might also be possible to use this makefile from a Windows console instead of the MSYS console.
# When your make utility is mingw32-make, you should use mk_mingw.mak instead.
# When the nmake utility from Windows is available, you can use mk_nmake.mak instead.

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
SYSTEM_CONSOLE_LIBS =
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_DRAW_LIBS = -lgdi32
# CC = g++
CC = gcc
VERS_FILE = vers_msys.h

EXE_EXT = .exe
S7_OUT = ../bin/s7
PRG_S7_STYLE = copy
CP_S7C = cp
VERSION_EXTRA_ARGS =
RUN_WARN = no
DEPEND_EXTRA_TOOLS = setwpath.exe sudo.exe
INSTALL_STYLE = setwpath
TEST_INSTALL_HINT = msys
STRIP_TARGETS = ../bin/s7.exe
DSRC = $(WIN_DSRC)
DRAW_LIB_SRC = $(WIN_DRAW_SRC)
CONSOLE_LIB_SRC = $(WIN_CON_SRC)

include mk_unix.mak

setwpath.exe: setwpath.c version.h
	$(CC) $< -o setwpath

sudo.exe: sudo.c
	$(CC) $< -w -o sudo

define chkccomp.h
#define LIST_DIRECTORY_CONTENTS "dir"
#define LINKER_OPT_STATIC_LINKING "-static"
#define CC_FLAGS "-ffunction-sections -fdata-sections"
#define CC_FLAGS64 "-Wa,-mbig-obj"
#define CC_OPT_LINK_TIME_OPTIMIZATION "-flto=auto"
#define CC_OPT_POSITION_INDEPENDENT_CODE "-fPIC"
#define LINKER_OPT_NO_LTO "-fno-lto"
#define POTENTIAL_PARTIAL_LINKING_OPTIONS "-r"
#define USE_GMP $(USE_GMP)$(if $(BIGINT_LIBS),$(_nl)#define BIGINT_LIBS "$(BIGINT_LIBS)")
#define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)"
#define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)"
#define INT_DIV_OVERFLOW_INFINITE_LOOP 1
#define POSTGRESQL_USE_DLL
endef

define base.h
#define PATH_DELIMITER 92 /* backslash (ASCII) */
#define OS_STRI_WCHAR
#define QUOTE_WHOLE_SHELL_COMMAND
#define OBJECT_FILE_EXTENSION ".o"
#define EXECUTABLE_FILE_EXTENSION "$(EXE_EXT)"
#define C_COMPILER "$(CC)"
#define CC_OPT_VERSION_INFO "--version"
#define CC_ERROR_FILEDES 2
#define CC_VERSION_INFO_FILEDES 1
#define LINKER_OPT_OUTPUT_FILE "-o "
#define DEFAULT_STACK_SIZE 8388608
#define ARCHIVER "$(AR)"
#define ARCHIVER_OPT_REPLACE "$(ARFLAGS) "
#define FORMAT_LL_TRIGGERS_WARNINGS 1
#define SYSTEM_LIBS "$(SYSTEM_LIBS)"
#define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)"
endef

define settings.h
#define MAKE_UTILITY_NAME "$(MAKE)"
#define MAKEFILE_NAME "$(MAKEFILE_NAME)"
#define SEARCH_PATH_DELIMITER ';'
#define CONSOLE_WCHAR
#define os_getch _getwch
#define LIBRARY_FILE_EXTENSION "$(LIB_EXT)"
#define CC_OPT_DEBUG_INFO "-g"
#define CC_OPT_NO_WARNINGS "-w"
#define LINKER_OPT_NO_DEBUG_INFO "-Wl,--strip-debug"
#define LINKER_OPT_STACK_SIZE "-Wl,--stack,"
#define LINKER_FLAGS "-Wl,--gc-sections"
#define SEED7_LIB "$(SEED7_LIB)"
#define DRAW_LIB "$(DRAW_LIB)"
#define CONSOLE_LIB "$(CONSOLE_LIB)"
#define DATABASE_LIB "$(DATABASE_LIB)"
#define COMP_DATA_LIB "$(COMP_DATA_LIB)"
#define COMPILER_LIB "$(COMPILER_LIB)"
endef
