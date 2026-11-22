# Makefile for mingw32-make and tcc. Commands executed by: cmd.exe
# To compile use a Windows console and call:
#   mingw32-make -f mk_tcc_w.mak depend
#   mingw32-make -f mk_tcc_w.mak
# If you are using tcc under linux/unix/bsd you should use mk_tcc_l.mak instead.

# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS = -g $(INCLUDE_OPTIONS) -Wall -Wimplicit-function-declaration -Wunusupported -Wwrite-strings
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -Wl,-stack=16777216
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS = -lws2_32 -ladvapi32
# SYSTEM_LIBS = -lgmp
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_DRAW_LIBS = -lgdi32 -luser32
SYSTEM_MATH_LIBS =
CC = tcc
AR = ar -r
# AR = tiny_libmaker
MAKEFILE_NAME = mk_tcc_w.mak
VERS_FILE = vers_tcc_w.h
HAS_DEPEND = no
TEST_HINT = admin
DEPEND_STYLE = none
AR_STYLE = ar_direct
SETWPATH_LIBS = -luser32 -ladvapi32
POSTGRESQL_USE_DLL = no
CC_OPT_VERSION_INFO = -v
HAS_BASE_CC_FLAGS = yes
BASE_CC_FLAGS =
DEFAULT_STACK_SIZE = 16777216
INT_DIV_POPUP = yes
DO_SIGFPE_DIV_ZERO = yes
DEF_CMDLINE_ARGV_W = yes
OS_GETCH = getch
GETCH_READS_BYTES = yes
LINKER_OPT_NO_DEBUG_INFO =
LINKER_OPT_STACK_SIZE = -Wl,-stack=
SETTINGS_LINKER_FLAGS =

include mk_wing.mak
