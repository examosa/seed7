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

include mk_wing.mak

levelup.exe: levelup.c
	$(CC) levelup.c -w -o levelup

sql_db2.o: sql_db2.c
	$(CC) -c $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(CFLAGS_NO_FLTO) $<

sql_ifx.o: sql_ifx.c
	$(CC) -c $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(CFLAGS_NO_FLTO) $<

sql_srv.o: sql_srv.c
	$(CC) -c $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(CFLAGS_NO_FLTO) $<

chkccomp.h:
	echo #define LIST_DIRECTORY_CONTENTS "dir" > chkccomp.h
	echo #define TEST_C_COMPILER "../bin/call_gcc" >> chkccomp.h
	echo #define LINKER_OPT_STATIC_LINKING "-static" >> chkccomp.h
	echo #define CC_FLAGS "-ffunction-sections -fdata-sections" >> chkccomp.h
	echo #define CC_FLAGS64 "-Wa,-mbig-obj" >> chkccomp.h
	echo #define CC_OPT_LINK_TIME_OPTIMIZATION "-flto=auto" >> chkccomp.h
	echo #define CC_OPT_POSITION_INDEPENDENT_CODE "-fPIC" >> chkccomp.h
	echo #define LINKER_OPT_NO_LTO "-fno-lto" >> chkccomp.h
	echo #define USE_GMP 0 >> chkccomp.h
	echo #define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)" >> chkccomp.h
	echo #define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)" >> chkccomp.h
	echo #define INT_DIV_OVERFLOW_INFINITE_LOOP 1 >> chkccomp.h
	echo #define POSTGRESQL_USE_DLL >> chkccomp.h

base.h:
	echo #define PATH_DELIMITER '\\' > base.h
	echo #define OS_STRI_WCHAR >> base.h
	echo #define QUOTE_WHOLE_SHELL_COMMAND >> base.h
	echo #define OBJECT_FILE_EXTENSION ".o" >> base.h
	echo #define EXECUTABLE_FILE_EXTENSION ".exe" >> base.h
	echo #define C_COMPILER_SCRIPT "call_gcc" >> base.h
	echo #define CC_OPT_VERSION_INFO "--version" >> base.h
	echo #define CC_ERROR_FILEDES 2 >> base.h
	echo #define CC_VERSION_INFO_FILEDES 1 >> base.h
	echo #define LINKER_OPT_OUTPUT_FILE "-o " >> base.h
	echo #define DEFAULT_STACK_SIZE 8388608 >> base.h
	echo #define ARCHIVER "..\\bin\\call_ar" >> base.h
	echo #define ARCHIVER_OPT_REPLACE "r " >> base.h
	echo #define FORMAT_LL_TRIGGERS_WARNINGS 1 >> base.h
	echo #define SYSTEM_LIBS "$(SYSTEM_LIBS)" >> base.h
	echo #define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)" >> base.h

settings.h:
	echo #define MAKE_UTILITY_NAME "$(MAKE)" > settings.h
	echo #define MAKEFILE_NAME "mk_mingc.mak" >> settings.h
	echo #define SEARCH_PATH_DELIMITER ';' >> settings.h
	echo #define CONSOLE_WCHAR >> settings.h
	echo #define os_getch _getwch >> settings.h
	echo #define LIBRARY_FILE_EXTENSION ".a" >> settings.h
	echo #define CC_OPT_DEBUG_INFO "-g" >> settings.h
	echo #define CC_OPT_NO_WARNINGS "-w" >> settings.h
	echo #define LINKER_OPT_NO_DEBUG_INFO "-Wl,--strip-debug" >> settings.h
	echo #define LINKER_OPT_STACK_SIZE "-Wl,--stack," >> settings.h
	echo #define LINKER_FLAGS "-Wl,--gc-sections" >> settings.h
	echo #define SEED7_LIB "$(SEED7_LIB)" >> settings.h
	echo #define DRAW_LIB "$(DRAW_LIB)" >> settings.h
	echo #define CONSOLE_LIB "$(CONSOLE_LIB)" >> settings.h
	echo #define DATABASE_LIB "$(DATABASE_LIB)" >> settings.h
	echo #define COMP_DATA_LIB "$(COMP_DATA_LIB)" >> settings.h
	echo #define COMPILER_LIB "$(COMPILER_LIB)" >> settings.h

chkccomp.exe: chkccomp.c chkccomp.h base.h settings.h
	$(CC) chkccomp.c -w -o chkccomp

setwpath.exe: version.h setwpath.c
	$(CC) setwpath.c -w -o setwpath

wrdepend.exe: version.h wrdepend.c
	$(CC) wrdepend.c -w -o wrdepend

sudo.exe: sudo.c
	$(CC) sudo.c -w -o sudo
