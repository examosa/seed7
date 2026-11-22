# Makefile for mingw32-make and clang. Commands executed by: cmd.exe
# To compile use a Windows console and call:
#   mingw32-make -f mk_clangw.mak depend
#   mingw32-make -f mk_clangw.mak
# When your make utility uses Unix commands, you should use mk_clang.mak instead.

# CFLAGS =
# CFLAGS = -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar -Wc++-compat
# CFLAGS = -O2 -g -x c++ -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wextra -Wswitch-default -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
# CFLAGS = -O2 -g -ffunction-sections -fdata-sections -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv -fsanitize=address,integer,undefined,dataflow,alignment,bool,bounds,enum,shift,integer-divide-by-zero -fno-sanitize=unsigned-integer-overflow
# CFLAGS = -O2 -g -ffunction-sections -fdata-sections -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv -fsanitize=address,integer,undefined
CFLAGS = -O2 -g -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) $(CC_OPT_LINK_TIME_OPTIMIZATION) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv
# CFLAGS = -O2 -g -x c++ -Wall -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv
# CFLAGS = -O2 -g -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -Wl,/STACK:8388608
# LDFLAGS = -Wl,--gc-sections,--stack,8388608
# LDFLAGS = -Wl,--gc-sections,--stack,8388608 -fsanitize=address,integer,undefined
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS = -luser32 -lshell32 -lws2_32 -ladvapi32
# SYSTEM_LIBS = -lm -lws2_32 -lgmp
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_MATH_LIBS =
LIB_EXT = .lib
# CC = g++
CC = clang
AR = ..\bin\call_lib
CC_ENVIRONMENT_INI = clangenv.ini
MAKEFILE_NAME = mk_clangw.mak
VERS_FILE = vers_clangw.h
HAS_CC_ENV_INI = yes
AR_STYLE = lib_out
CHKCCOMP_FLAGS = -ftrapv -Wno-deprecated-declarations
SETWPATH_LIBS = -luser32 -ladvapi32
WRDEPEND_FLAGS = -Wno-deprecated-declarations
SUDO_FLAGS = -lshell32
CC_OPT_LTO = -flto=auto
CC_OPT_TRAP_OVERFLOW = -ftrapv
HAS_BASE_CC_FLAGS = yes
BASE_CC_FLAGS = -ffunction-sections -fdata-sections
BASE_ARCHIVER = ..\\bin\\call_lib
INT_DIV_POPUP = yes
CLANG_MSVC_CRT = yes
RENAMED_POSIX = yes
LINKER_OPT_DEBUG_INFO = -g
LINKER_OPT_STACK_SIZE = -Wl,/STACK:
SETTINGS_LINKER_FLAGS =

include mk_wing.mak

dep: depend
