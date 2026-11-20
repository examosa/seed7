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

include mk_wing.mak

levelup.exe: levelup.c
	$(CC) levelup.c -o levelup.exe

sql_db2.o: sql_db2.c
	$(CC) -c $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(CFLAGS) $< -o $@

sql_ifx.o: sql_ifx.c
	$(CC) -c $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(CFLAGS) $< -o $@

sql_srv.o: sql_srv.c
	$(CC) -c $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(CFLAGS) $< -o $@

chkccomp.h:
	echo #define LIST_DIRECTORY_CONTENTS "dir" > chkccomp.h
	echo #define USE_GMP 0 >> chkccomp.h
	echo #define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)" >> chkccomp.h
	echo #define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)" >> chkccomp.h

base.h:
	echo #define PATH_DELIMITER '\\' > base.h
	echo #define OS_STRI_WCHAR >> base.h
	echo #define QUOTE_WHOLE_SHELL_COMMAND >> base.h
	echo #define OBJECT_FILE_EXTENSION ".o" >> base.h
	echo #define EXECUTABLE_FILE_EXTENSION ".exe" >> base.h
	echo #define C_COMPILER "$(CC)" >> base.h
	echo #define CC_OPT_VERSION_INFO "-v" >> base.h
	echo #define CC_FLAGS "" >> base.h
	echo #define CC_ERROR_FILEDES 2 >> base.h
	echo #define CC_VERSION_INFO_FILEDES 1 >> base.h
	echo #define LINKER_OPT_OUTPUT_FILE "-o " >> base.h
	echo #define DEFAULT_STACK_SIZE 16777216 >> base.h
	echo #define INT_DIV_BY_ZERO_POPUP >> base.h
	echo #define DO_SIGFPE_WITH_DIV_BY_ZERO 1 >> base.h
	echo #define SYSTEM_LIBS "$(SYSTEM_LIBS)" >> base.h
	echo #define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)" >> base.h

settings.h:
	echo #define MAKE_UTILITY_NAME "$(MAKE)" > settings.h
	echo #define MAKEFILE_NAME "mk_tcc_w.mak" >> settings.h
	echo #define SEARCH_PATH_DELIMITER ';' >> settings.h
	echo #define DEFINE_COMMAND_LINE_TO_ARGV_W >> settings.h
	echo #define CONSOLE_WCHAR >> settings.h
	echo #define os_getch getch >> settings.h
	echo #define OS_GETCH_READS_BYTES >> settings.h
	echo #define LIBRARY_FILE_EXTENSION ".a" >> settings.h
	echo #define CC_OPT_DEBUG_INFO "-g" >> settings.h
	echo #define CC_OPT_NO_WARNINGS "-w" >> settings.h
	echo #define LINKER_OPT_STACK_SIZE "-Wl,-stack=" >> settings.h
	echo #define LINKER_FLAGS "" >> settings.h
	echo #define SEED7_LIB "$(SEED7_LIB)" >> settings.h
	echo #define DRAW_LIB "$(DRAW_LIB)" >> settings.h
	echo #define CONSOLE_LIB "$(CONSOLE_LIB)" >> settings.h
	echo #define DATABASE_LIB "$(DATABASE_LIB)" >> settings.h
	echo #define COMP_DATA_LIB "$(COMP_DATA_LIB)" >> settings.h
	echo #define COMPILER_LIB "$(COMPILER_LIB)" >> settings.h

chkccomp.exe: chkccomp.c chkccomp.h base.h settings.h
	$(CC) chkccomp.c -o chkccomp.exe

setwpath.exe: version.h setwpath.c
	$(CC) setwpath.c -luser32 -ladvapi32 -o setwpath.exe
