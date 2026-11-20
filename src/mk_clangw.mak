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

include mk_wing.mak

dep: depend

levelup.exe: levelup.c
	$(CC) levelup.c -o levelup.exe

sql_db2.o: sql_db2.c
	$(CC) -c $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(CFLAGS) $<

sql_ifx.o: sql_ifx.c
	$(CC) -c $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(CFLAGS) $<

sql_srv.o: sql_srv.c
	$(CC) -c $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(CFLAGS) $<

chkccomp.h:
	echo #define LIST_DIRECTORY_CONTENTS "dir" > chkccomp.h
	echo #define CC_OPT_LINK_TIME_OPTIMIZATION "-flto=auto" >> chkccomp.h
	echo #define USE_GMP 0 >> chkccomp.h
	echo #define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)" >> chkccomp.h
	echo #define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)" >> chkccomp.h
	echo #define POSTGRESQL_USE_DLL >> chkccomp.h

base.h:
	echo #define PATH_DELIMITER '\\' > base.h
	echo #define OS_STRI_WCHAR >> base.h
	echo #define QUOTE_WHOLE_SHELL_COMMAND >> base.h
	echo #define OBJECT_FILE_EXTENSION ".o" >> base.h
	echo #define EXECUTABLE_FILE_EXTENSION ".exe" >> base.h
	echo #define C_COMPILER "$(CC)" >> base.h
	echo #define CC_OPT_TRAP_OVERFLOW "-ftrapv" >> base.h
	echo #define CC_OPT_VERSION_INFO "--version" >> base.h
	echo #define CC_FLAGS "-ffunction-sections -fdata-sections" >> base.h
	echo #define CC_ERROR_FILEDES 2 >> base.h
	echo #define CC_VERSION_INFO_FILEDES 1 >> base.h
	echo #define LINKER_OPT_OUTPUT_FILE "-o " >> base.h
	echo #define DEFAULT_STACK_SIZE 8388608 >> base.h
	echo #define ARCHIVER "..\\bin\\call_lib" >> base.h
	echo #define ARCHIVER_OPT_REPLACE "/out:" >> base.h
	echo #define INT_DIV_BY_ZERO_POPUP >> base.h
	echo #define FILENO_WORKS_FOR_NULL 0 >> base.h
	echo #define _CRT_SECURE_NO_WARNINGS >> base.h
	echo #define _CRT_NONSTDC_NO_DEPRECATE >> base.h
	echo #define SYSTEM_LIBS "$(SYSTEM_LIBS)" >> base.h
	echo #define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)" >> base.h

settings.h:
	echo #define MAKE_UTILITY_NAME "$(MAKE)" > settings.h
	echo #define MAKEFILE_NAME "mk_clangw.mak" >> settings.h
	echo #define SEARCH_PATH_DELIMITER ';' >> settings.h
	echo #define CONSOLE_WCHAR >> settings.h
	echo #define RENAMED_POSIX_FUNCTIONS >> settings.h
	echo #define os_getch _getwch >> settings.h
	echo #define LIBRARY_FILE_EXTENSION "$(LIB_EXT)" >> settings.h
	echo #define CC_OPT_DEBUG_INFO "-g" >> settings.h
	echo #define CC_OPT_NO_WARNINGS "-w" >> settings.h
	echo #define LINKER_OPT_DEBUG_INFO "-g" >> settings.h
	echo #define LINKER_OPT_NO_DEBUG_INFO "-Wl,--strip-debug" >> settings.h
	echo #define LINKER_OPT_STACK_SIZE "-Wl,/STACK:" >> settings.h
	echo #define LINKER_FLAGS "" >> settings.h
	echo #define SEED7_LIB "$(SEED7_LIB)" >> settings.h
	echo #define DRAW_LIB "$(DRAW_LIB)" >> settings.h
	echo #define CONSOLE_LIB "$(CONSOLE_LIB)" >> settings.h
	echo #define DATABASE_LIB "$(DATABASE_LIB)" >> settings.h
	echo #define COMP_DATA_LIB "$(COMP_DATA_LIB)" >> settings.h
	echo #define COMPILER_LIB "$(COMPILER_LIB)" >> settings.h

chkccomp.exe: chkccomp.c chkccomp.h base.h settings.h
	$(CC) -ftrapv -Wno-deprecated-declarations chkccomp.c -o chkccomp.exe

setwpath.exe: version.h setwpath.c
	$(CC) -luser32 -ladvapi32 setwpath.c -o setwpath.exe

wrdepend.exe: version.h wrdepend.c
	$(CC) -Wno-deprecated-declarations wrdepend.c -o wrdepend.exe

sudo.exe: sudo.c
	$(CC) -lshell32 sudo.c -w -o sudo.exe
