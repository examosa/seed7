# Makefile for gmake and gcc from Cygwin. Commands executed by: bash
# To compile use a Cygwin console and call:
#   make -f mk_cygw.mak depend
#   make -f mk_cygw.mak
# If you do not have Cygwin you could use MinGW and MSYS together with mk_msys.mak.

# CFLAGS =
# CFLAGS = -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar -Wc++-compat
# CFLAGS = -O2 -fomit-frame-pointer -pedantic -Wall -Wextra -Wswitch-default -Wcast-qual -Wlogical-op -Waggregate-return -Wwrite-strings -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar -Wpadded
CFLAGS_NO_FLTO = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS = $(CC_OPT_LINK_TIME_OPTIMIZATION) $(CFLAGS_NO_FLTO)
# CFLAGS = -O2 -g -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -Wl,--gc-sections,--stack,16777216
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS =
# SYSTEM_LIBS = -lm -lgmp
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_CONSOLE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DRAW_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# CC = g++
CC = gcc
VERS_FILE = vers_cygw.h

EXE_EXT = .exe
S7_OUT = ../bin/s7
CP_S7C = cp
VERSION_EXTRA_ARGS =
RUN_WARN = no
TEST_INSTALL_HINT = plain
STRIP_TARGETS = ../bin/s7.exe
LINKER_OPT_DYN_LINK_LIBS =
PARTIAL_LINK_OPTS = "-r"
CLEAN_EXTRA = chkint chkovf chkflt chkbin chkchr chkstr chkidx chkbst chkarr chkprc chkbig chkbool chkbitdata chkset chkhsh chkfil chkexc ../bin/s7 ../bin/s7c ../prg/s7 ../prg/s7c
DSRC = $(subst pol_unx.c,pol_sel.c segv_win.c,$(UNX_DSRC))

include mk_unix.mak

define base.h
#define PATH_DELIMITER '/'
#define QUOTE_WHOLE_SHELL_COMMAND
#define OBJECT_FILE_EXTENSION ".o"
#define EXECUTABLE_FILE_EXTENSION "$(EXE_EXT)"
#define C_COMPILER "$(CC)"
#define CC_OPT_VERSION_INFO "--version"
#define CC_FLAGS "-ffunction-sections -fdata-sections"
#define CC_ERROR_FILEDES 2
#define CC_VERSION_INFO_FILEDES 1
#define LINKER_OPT_OUTPUT_FILE "-o "
#define DEFAULT_STACK_SIZE 16777216
#define ARCHIVER "$(AR)"
#define ARCHIVER_OPT_REPLACE "$(ARFLAGS) "
#define SYSTEM_LIBS "$(SYSTEM_LIBS)"
#define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)"
endef

define settings.h
#define MAKE_UTILITY_NAME "$(MAKE)"
#define MAKEFILE_NAME "$(MAKEFILE_NAME)"
#define SEARCH_PATH_DELIMITER ':'
#define AWAIT_WITH_SIGACTION
#define INCL_NCURSES_TERM
#define SIGNAL_HANDLER_CAN_DO_IO
#define CONSOLE_UTF8
#define OS_STRI_UTF8
#define APPEND_EXTENSION_TO_EXECUTABLE_PATH
#define LIBRARY_FILE_EXTENSION "$(LIB_EXT)"
#define CC_SOURCE_UTF8
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
