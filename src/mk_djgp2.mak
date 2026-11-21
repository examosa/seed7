# Makefile for make and gcc from DJGPP. Commands executed by: cmd.exe
# To compile use a windows console and call:
#   make -f mk_djgp2.mak depend
#   make -f mk_djgp2.mak
# If your get errors you can try mk_djgpp.mak instead.

# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS = -O2 -g -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -funroll-loops -Wall -pg
# Since there is no linker option to determine the stack size
# it is determined with STACK_SIZE_DEFINITION (see below).
LDFLAGS =
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS = -lm
# SYSTEM_LIBS = -lm -lgmp
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_CONSOLE_LIBS =
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_DRAW_LIBS =
SYSTEM_MATH_LIBS =
ALL_SYSTEM_LIBS = $(SYSTEM_LIBS) $(SYSTEM_BIGINT_LIBS) $(SYSTEM_CONSOLE_LIBS) $(SYSTEM_DATABASE_LIBS) $(SYSTEM_DRAW_LIBS) $(SYSTEM_MATH_LIBS)
SEED7_LIB = seed7_05.a
DRAW_LIB = s7_draw.a
CONSOLE_LIB = s7_con.a
DATABASE_LIB = s7_db.a
COMP_DATA_LIB = s7_data.a
COMPILER_LIB = s7_comp.a
ALL_S7_LIBS = ..\bin\$(COMPILER_LIB) ..\bin\$(COMP_DATA_LIB) ..\bin\$(DRAW_LIB) ..\bin\$(CONSOLE_LIB) ..\bin\$(DATABASE_LIB) ..\bin\$(SEED7_LIB)
# CC = g++
CC = gcc

DSRC = big_rtl.c big_gmp.c cmd_unx.c dir_win.c dll_dos.c fil_dos.c pcs_dos.c pol_dos.c soc_none.c \
       tim_dos.c
DRAW_LIB_SRC = gkb_rtl.c drw_dos.c
CONSOLE_LIB_SRC = kbd_rtl.c con_wat.c

include mk_src.mak
include mk_obj_o.mak

s7: ..\bin\s7.exe ..\prg\s7.exe
	..\bin\s7 -l ..\lib level
	echo Use 'make s7c' (with your make command) to create the compiler.

s7c: ..\bin\s7c.exe ..\prg\s7c.exe
	echo Use 'make test' (with your make command) to check Seed7.

..\bin\s7.exe: levelup.exe next_lvl $(OBJ) $(ALL_S7_LIBS)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(ALL_SYSTEM_LIBS) -o ..\bin\s7.exe
	del next_lvl

..\prg\s7.exe: ..\bin\s7.exe
	copy ..\bin\s7.exe ..\prg /Y

..\bin\s7c.exe: ..\prg\s7c.exe
	copy ..\prg\s7c.exe ..\bin /Y

..\prg\s7c.exe: ..\prg\s7c.sd7 $(ALL_S7_LIBS)
	..\bin\s7 -l ..\lib ..\prg\s7c -l ..\lib -b ..\bin -O2 ..\prg\s7c

levelup.exe: levelup.c
	$(CC) levelup.c -o levelup

next_lvl: levelup.exe
	.\levelup.exe
	echo X > next_lvl

sql_db2.o: sql_db2.c
	$(CC) -c $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(CFLAGS) $< -o $@

sql_ifx.o: sql_ifx.c
	$(CC) -c $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(CFLAGS) $< -o $@

sql_srv.o: sql_srv.c
	$(CC) -c $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(CFLAGS) $< -o $@

clean:
	del *.o
	del ..\bin\$(COMPILER_LIB)
	del ..\bin\$(COMP_DATA_LIB)
	del ..\bin\$(DRAW_LIB)
	del ..\bin\$(CONSOLE_LIB)
	del ..\bin\$(DATABASE_LIB)
	del ..\bin\$(SEED7_LIB)
	del ..\bin\s7.exe
	del ..\bin\s7c.exe
	del ..\prg\s7.exe
	del ..\prg\s7c.exe
	del depend
	del chkccomp.h
	del base.h
	del settings.h
	del version.h
	del chkccomp.exe
	del levelup.exe
	del next_lvl
	echo Use 'make depend' (with your make command) to create the dependencies.

clean_utils:
	del ..\bin\bas7.exe
	del ..\bin\bigfiles.exe
	del ..\bin\calc7.exe
	del ..\bin\cat.exe
	del ..\bin\comanche.exe
	del ..\bin\db7.exe
	del ..\bin\diff7.exe
	del ..\bin\find7.exe
	del ..\bin\findchar.exe
	del ..\bin\ftp7.exe
	del ..\bin\ftpserv.exe
	del ..\bin\hd.exe
	del ..\bin\ide7.exe
	del ..\bin\make7.exe
	del ..\bin\portfwd7.exe
	del ..\bin\pv7.exe
	del ..\bin\s7check.exe
	del ..\bin\sql7.exe
	del ..\bin\sydir7.exe
	del ..\bin\tar7.exe
	del ..\bin\toutf8.exe
	del ..\bin\which.exe

distclean: clean clean_utils
	del level_bk.h
	del level.h
	del vers_dj2.h

test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build

minimal_test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build minimal_test

check: test

strip:
	strip ..\bin\s7.exe

chkccomp.h:
	echo #define LIST_DIRECTORY_CONTENTS "dir" > chkccomp.h
	echo #define UNIX_DO_SLEEP >> chkccomp.h
	echo #define ERROR_REDIRECTING_FAILS >> chkccomp.h
	echo #define LIMIT_PRINTF_MAXIMUM_FLOAT_PRECISION 512 >> chkccomp.h
	echo #define USE_GMP 0 >> chkccomp.h
	echo #define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)" >> chkccomp.h
	echo #define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)" >> chkccomp.h

base.h:
	echo #define PATH_DELIMITER 92 /* backslash (ASCII) */ > base.h
	echo #define OBJECT_FILE_EXTENSION ".o" >> base.h
	echo #define EXECUTABLE_FILE_EXTENSION ".exe" >> base.h
	echo #define TEMP_FILE_PREFIX "t_" >> base.h
	echo #define C_COMPILER "$(CC)" >> base.h
	echo #define CC_OPT_VERSION_INFO "--version" >> base.h
	echo #define CC_FLAGS "" >> base.h
	echo #define CC_ERROR_FILEDES 0 >> base.h
	echo #define CC_VERSION_INFO_FILEDES 1 >> base.h
	echo #define LINKER_OPT_OUTPUT_FILE "-o " >> base.h
	echo #define OS_STRI_USES_CODE_PAGE >> base.h
	echo #define SYSTEM_LIBS "$(SYSTEM_LIBS)" >> base.h
	echo #define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)" >> base.h

settings.h:
	echo #define MAKE_UTILITY_NAME "$(MAKE)" > settings.h
	echo #define MAKEFILE_NAME "mk_djgp2.mak" >> settings.h
	echo #define SEARCH_PATH_DELIMITER ';' >> settings.h
	echo #define AWAIT_WITH_SELECT >> settings.h
	echo #define IMPLEMENT_PTY_WITH_PIPE2 >> settings.h
	echo #define USE_CONSOLE_FOR_PROT_CSTRI >> settings.h
	echo #define LIBRARY_FILE_EXTENSION ".a" >> settings.h
	echo #define CALL_C_COMPILER_FROM_SHELL 1 >> settings.h
	echo #define CC_OPT_DEBUG_INFO "-g" >> settings.h
	echo #define CC_OPT_NO_WARNINGS "-w" >> settings.h
	echo #define LINKER_FLAGS "$(LDFLAGS)" >> settings.h
	echo #define SEED7_LIB "$(SEED7_LIB)" >> settings.h
	echo #define DRAW_LIB "$(DRAW_LIB)" >> settings.h
	echo #define CONSOLE_LIB "$(CONSOLE_LIB)" >> settings.h
	echo #define DATABASE_LIB "$(DATABASE_LIB)" >> settings.h
	echo #define COMP_DATA_LIB "$(COMP_DATA_LIB)" >> settings.h
	echo #define COMPILER_LIB "$(COMPILER_LIB)" >> settings.h
	echo #define STACK_SIZE_DEFINITION unsigned _stklen = 4194304 >> settings.h

version.h: chkccomp.exe base.h settings.h
	echo The following C compiler errors can be safely ignored
	.\chkccomp.exe version.h S7_LIB_DIR=$(S7_LIB_DIR) SEED7_LIBRARY=$(SEED7_LIBRARY)
	copy version.h vers_dj2.h /Y

chkccomp.exe: chkccomp.c chkccomp.h base.h settings.h
	$(CC) chkccomp.c -o chkccomp.exe

depend: version.h
	echo Working without C header dependency checks.
	echo Use 'make' (with your make command) to create the interpreter.

..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	ar r ..\bin\$(SEED7_LIB) $(SEED7_LIB_OBJ)

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	ar r ..\bin\$(DRAW_LIB) $(DRAW_LIB_OBJ)

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	ar r ..\bin\$(CONSOLE_LIB) $(CONSOLE_LIB_OBJ)

..\bin\$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
	ar r ..\bin\$(DATABASE_LIB) $(DATABASE_LIB_OBJ)

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	ar r ..\bin\$(COMP_DATA_LIB) $(COMP_DATA_LIB_OBJ)

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	ar r ..\bin\$(COMPILER_LIB) $(COMPILER_LIB_OBJ)

..\bin\bas7.exe: ..\prg\bas7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\bas7
	copy ..\prg\bas7.exe ..\bin /Y
	del ..\prg\bas7.exe

..\bin\bigfiles.exe: ..\prg\bigfiles.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\bigfiles
	copy ..\prg\bigfiles.exe ..\bin /Y
	del ..\prg\bigfiles.exe

..\bin\calc7.exe: ..\prg\calc7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\calc7
	copy ..\prg\calc7.exe ..\bin /Y
	del ..\prg\calc7.exe

..\bin\cat.exe: ..\prg\cat.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\cat
	copy ..\prg\cat.exe ..\bin /Y
	del ..\prg\cat.exe

..\bin\comanche.exe: ..\prg\comanche.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\comanche
	copy ..\prg\comanche.exe ..\bin /Y
	del ..\prg\comanche.exe

..\bin\db7.exe: ..\prg\db7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\db7
	copy ..\prg\db7.exe ..\bin /Y
	del ..\prg\db7.exe

..\bin\diff7.exe: ..\prg\diff7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\diff7
	copy ..\prg\diff7.exe ..\bin /Y
	del ..\prg\diff7.exe

..\bin\find7.exe: ..\prg\find7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\find7
	copy ..\prg\find7.exe ..\bin /Y
	del ..\prg\find7.exe

..\bin\findchar.exe: ..\prg\findchar.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\findchar
	copy ..\prg\findchar.exe ..\bin /Y
	del ..\prg\findchar.exe

..\bin\ftp7.exe: ..\prg\ftp7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\ftp7
	copy ..\prg\ftp7.exe ..\bin /Y
	del ..\prg\ftp7.exe

..\bin\ftpserv.exe: ..\prg\ftpserv.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\ftpserv
	copy ..\prg\ftpserv.exe ..\bin /Y
	del ..\prg\ftpserv.exe

..\bin\hd.exe: ..\prg\hd.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\hd
	copy ..\prg\hd.exe ..\bin /Y
	del ..\prg\hd.exe

..\bin\ide7.exe: ..\prg\ide7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\ide7
	copy ..\prg\ide7.exe ..\bin /Y
	del ..\prg\ide7.exe

..\bin\make7.exe: ..\prg\make7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\make7
	copy ..\prg\make7.exe ..\bin /Y
	del ..\prg\make7.exe

..\bin\portfwd7.exe: ..\prg\portfwd7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\portfwd7
	copy ..\prg\portfwd7.exe ..\bin /Y
	del ..\prg\portfwd7.exe

..\bin\pv7.exe: ..\prg\pv7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\pv7
	copy ..\prg\pv7.exe ..\bin /Y
	del ..\prg\pv7.exe

..\bin\s7check.exe: ..\prg\s7check.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\s7check
	copy ..\prg\s7check.exe ..\bin /Y
	del ..\prg\s7check.exe

..\bin\sql7.exe: ..\prg\sql7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\sql7
	copy ..\prg\sql7.exe ..\bin /Y
	del ..\prg\sql7.exe

..\bin\sydir7.exe: ..\prg\sydir7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\sydir7
	copy ..\prg\sydir7.exe ..\bin /Y
	del ..\prg\sydir7.exe

..\bin\tar7.exe: ..\prg\tar7.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\tar7
	copy ..\prg\tar7.exe ..\bin /Y
	del ..\prg\tar7.exe

..\bin\toutf8.exe: ..\prg\toutf8.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\toutf8
	copy ..\prg\toutf8.exe ..\bin /Y
	del ..\prg\toutf8.exe

..\bin\which.exe: ..\prg\which.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 ..\prg\which
	copy ..\prg\which.exe ..\bin /Y
	del ..\prg\which.exe

bas7: ..\bin\bas7.exe
bigfiles: ..\bin\bigfiles.exe
calc7: ..\bin\calc7.exe
cat: ..\bin\cat.exe
comanche: ..\bin\comanche.exe
db7: ..\bin\db7.exe
diff7: ..\bin\diff7.exe
find7: ..\bin\find7.exe
findchar: ..\bin\findchar.exe
ftp7: ..\bin\ftp7.exe
ftpserv: ..\bin\ftpserv.exe
hd: ..\bin\hd.exe
ide7: ..\bin\ide7.exe
make7: ..\bin\make7.exe
portfwd7: ..\bin\portfwd7.exe
pv7: ..\bin\pv7.exe
s7check: ..\bin\s7check.exe
sql7: ..\bin\sql7.exe
sydir7: ..\bin\sydir7.exe
tar7: ..\bin\tar7.exe
toutf8: ..\bin\toutf8.exe
which: ..\bin\which.exe

utils: ..\bin\bas7.exe ..\bin\bigfiles.exe ..\bin\calc7.exe ..\bin\cat.exe ..\bin\comanche.exe ..\bin\db7.exe \
       ..\bin\diff7.exe ..\bin\find7.exe ..\bin\findchar.exe ..\bin\ftp7.exe ..\bin\ftpserv.exe ..\bin\hd.exe \
       ..\bin\ide7.exe ..\bin\make7.exe ..\bin\portfwd7.exe ..\bin\pv7.exe ..\bin\s7check.exe ..\bin\sql7.exe \
       ..\bin\sydir7.exe ..\bin\tar7.exe ..\bin\toutf8.exe ..\bin\which.exe

wc: $(SRC)
	echo SRC:
	wc $(SRC)
	echo SEED7_LIB_SRC:
	wc $(SEED7_LIB_SRC)
	echo DRAW_LIB_SRC:
	wc $(DRAW_LIB_SRC)
	echo CONSOLE_LIB_SRC:
	wc $(CONSOLE_LIB_SRC)
	echo DATABASE_LIB_SRC:
	wc $(DATABASE_LIB_SRC)
	echo COMP_DATA_LIB_SRC:
	wc $(COMP_DATA_LIB_SRC)
	echo COMPILER_LIB_SRC:
	wc $(COMPILER_LIB_SRC)

lint: $(SRC)
	lint -p $(SRC) $(ALL_SYSTEM_LIBS)

lint2: $(SRC)
	lint -Zn2048 $(SRC) $(ALL_SYSTEM_LIBS)
