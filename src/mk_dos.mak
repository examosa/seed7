# Common DOS DJGPP GNU-make rules shared by mk_djgpp.mak and mk_djgp2.mak.

AR ?= ar
ARFLAGS = r
LIB_EXT ?= .a
USE_GMP ?= 0
BIGINT_LIBS ?=
ECHO_STYLE ?= echo

include mk_lib.mak
include mk_src.mak

ALL_S7_LIBS = $(addprefix ..\bin\,$(S7_LIBS))
DSRC = $(DOS_DSRC)
DRAW_LIB_SRC = $(DOS_DRAW_SRC)
CONSOLE_LIB_SRC = $(DOS_CON_SRC)

include mk_obj_o.mak

UTILS_BIN = $(addprefix ../bin/,$(addsuffix .exe,$(UTILS)))

IF_BIGINT_LIBS = rem
ifneq ($(BIGINT_LIBS),)
IF_BIGINT_LIBS =
endif

ifeq ($(ECHO_STYLE),djecho)
ECHO = djecho
EQ = "
IQ = \"
WC_ECHO = @$(ECHO)
IF_DJECHO =
IF_DJGP2 = rem
else
ECHO = echo
EQ =
IQ = "
WC_ECHO = echo
IF_DJECHO = rem
IF_DJGP2 =
endif

ifeq ($(ECHO_STYLE),djecho)
s7: ..\bin\s7.exe ..\prg\s7.exe
	..\bin\s7 -l ..\lib level
	@$(ECHO)
	@$(ECHO) "  Use 'make s7c' (with your make command) to create the compiler."
	@$(ECHO)

s7c: ..\bin\s7c.exe ..\prg\s7c.exe
	@$(ECHO)
	@$(ECHO) "  Use 'make test' (with your make command) to check Seed7."
	@$(ECHO)
else
s7: ..\bin\s7.exe ..\prg\s7.exe
	..\bin\s7 -l ..\lib level
	echo Use 'make s7c' (with your make command) to create the compiler.

s7c: ..\bin\s7c.exe ..\prg\s7c.exe
	echo Use 'make test' (with your make command) to check Seed7.
endif

.PHONY: clean s7 s7c test minimal_test check strip clean_utils distclean utils wc lint lint2

..\bin\s7.exe: levelup.exe next_lvl $(OBJ) $(ALL_S7_LIBS)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(ALL_SYSTEM_LIBS) -o ..\bin\s7.exe
	del next_lvl

..\prg\s7.exe: ..\bin\s7.exe
	copy $< ..\prg /Y

..\bin\s7c.exe: ..\prg\s7c.exe
	copy $< ..\bin /Y

..\prg\s7c.exe: ..\prg\s7c.sd7 $(ALL_S7_LIBS)
	..\bin\s7 -l ..\lib ..\prg\s7c -l ..\lib -b ..\bin -O2 ..\prg\s7c

levelup.exe: levelup.c
	$(CC) $< -o levelup

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
	@$(IF_DJECHO) $(ECHO)
	@$(IF_DJECHO) $(ECHO) "  Use 'make depend' (with your make command) to create the dependencies."
	@$(IF_DJECHO) $(ECHO)
	@$(IF_DJGP2) echo Use 'make depend' (with your make command) to create the dependencies.

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
	del $(VERS_FILE)

test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build

minimal_test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build minimal_test

check: test

strip:
	strip ..\bin\s7.exe

chkccomp.h:
	$(ECHO) $(EQ)#define LIST_DIRECTORY_CONTENTS $(IQ)dir$(IQ)$(EQ) > chkccomp.h
	$(ECHO) $(EQ)#define UNIX_DO_SLEEP$(EQ) >> chkccomp.h
	$(ECHO) $(EQ)#define ERROR_REDIRECTING_FAILS$(EQ) >> chkccomp.h
	$(ECHO) $(EQ)#define LIMIT_PRINTF_MAXIMUM_FLOAT_PRECISION 512$(EQ) >> chkccomp.h
	$(ECHO) $(EQ)#define USE_GMP $(USE_GMP)$(EQ) >> chkccomp.h
	@$(IF_BIGINT_LIBS) $(ECHO) $(EQ)#define BIGINT_LIBS $(IQ)$(BIGINT_LIBS)$(IQ)$(EQ) >> chkccomp.h
	$(ECHO) $(EQ)#define SYSTEM_CONSOLE_LIBS $(IQ)$(SYSTEM_CONSOLE_LIBS)$(IQ)$(EQ) >> chkccomp.h
	$(ECHO) $(EQ)#define SYSTEM_DRAW_LIBS $(IQ)$(SYSTEM_DRAW_LIBS)$(IQ)$(EQ) >> chkccomp.h

base.h:
	$(ECHO) $(EQ)#define PATH_DELIMITER 92 /* backslash (ASCII) */$(EQ) > base.h
	$(ECHO) $(EQ)#define OBJECT_FILE_EXTENSION $(IQ).o$(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define EXECUTABLE_FILE_EXTENSION $(IQ).exe$(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define TEMP_FILE_PREFIX $(IQ)t_$(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define C_COMPILER $(IQ)$(CC)$(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define CC_OPT_VERSION_INFO $(IQ)--version$(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define CC_FLAGS $(IQ)$(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define CC_ERROR_FILEDES 0$(EQ) >> base.h
	$(ECHO) $(EQ)#define CC_VERSION_INFO_FILEDES 1$(EQ) >> base.h
	$(ECHO) $(EQ)#define LINKER_OPT_OUTPUT_FILE $(IQ)-o $(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define OS_STRI_USES_CODE_PAGE$(EQ) >> base.h
	$(ECHO) $(EQ)#define SYSTEM_LIBS $(IQ)$(SYSTEM_LIBS)$(IQ)$(EQ) >> base.h
	$(ECHO) $(EQ)#define SYSTEM_MATH_LIBS $(IQ)$(SYSTEM_MATH_LIBS)$(IQ)$(EQ) >> base.h

settings.h:
	$(ECHO) $(EQ)#define MAKE_UTILITY_NAME $(IQ)$(MAKE)$(IQ)$(EQ) > settings.h
	$(ECHO) $(EQ)#define MAKEFILE_NAME $(IQ)$(MAKEFILE_NAME)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define SEARCH_PATH_DELIMITER ';'$(EQ) >> settings.h
	$(ECHO) $(EQ)#define AWAIT_WITH_SELECT$(EQ) >> settings.h
	$(ECHO) $(EQ)#define IMPLEMENT_PTY_WITH_PIPE2$(EQ) >> settings.h
	$(ECHO) $(EQ)#define USE_CONSOLE_FOR_PROT_CSTRI$(EQ) >> settings.h
	$(ECHO) $(EQ)#define LIBRARY_FILE_EXTENSION $(IQ)$(LIB_EXT)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define CALL_C_COMPILER_FROM_SHELL 1$(EQ) >> settings.h
	$(ECHO) $(EQ)#define CC_OPT_DEBUG_INFO $(IQ)-g$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define CC_OPT_NO_WARNINGS $(IQ)-w$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define LINKER_FLAGS $(IQ)$(LDFLAGS)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define SEED7_LIB $(IQ)$(SEED7_LIB)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define DRAW_LIB $(IQ)$(DRAW_LIB)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define CONSOLE_LIB $(IQ)$(CONSOLE_LIB)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define DATABASE_LIB $(IQ)$(DATABASE_LIB)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define COMP_DATA_LIB $(IQ)$(COMP_DATA_LIB)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define COMPILER_LIB $(IQ)$(COMPILER_LIB)$(IQ)$(EQ) >> settings.h
	$(ECHO) $(EQ)#define STACK_SIZE_DEFINITION unsigned _stklen = 4194304$(EQ) >> settings.h

version.h: chkccomp.exe base.h settings.h
	@$(IF_DJECHO) $(ECHO)
	@$(IF_DJECHO) $(ECHO) "The following C compiler errors can be safely ignored"
	@$(IF_DJGP2) echo The following C compiler errors can be safely ignored
	.\chkccomp.exe $@ S7_LIB_DIR=$(S7_LIB_DIR) SEED7_LIBRARY=$(SEED7_LIBRARY)
	copy $@ $(VERS_FILE) /Y

chkccomp.exe: chkccomp.c chkccomp.h base.h settings.h
	$(CC) $< -o $@

ifeq ($(ECHO_STYLE),djecho)
depend: version.h
	@$(ECHO) "Working without C header dependency checks."
	@$(ECHO)
	@$(ECHO) "  Use 'make' (with your make command) to create the interpreter."
	@$(ECHO)
else
depend: version.h
	echo Working without C header dependency checks.
	echo Use 'make' (with your make command) to create the interpreter.
endif

..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $^

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $^

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $^

..\bin\$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $^

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $^

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $^

../bin/%.exe: ../prg/%.sd7 ..\bin\s7c.exe
	..\bin\s7c.exe -l ..\lib -b ..\bin -O3 -oc3 $(subst /,\,$(<:.sd7=))
	copy $(subst /,\,$(<:.sd7=.exe)) ..\bin /Y
	del $(subst /,\,$(<:.sd7=.exe))

bas7: ../bin/bas7.exe
bigfiles: ../bin/bigfiles.exe
calc7: ../bin/calc7.exe
cat: ../bin/cat.exe
comanche: ../bin/comanche.exe
db7: ../bin/db7.exe
diff7: ../bin/diff7.exe
find7: ../bin/find7.exe
findchar: ../bin/findchar.exe
ftp7: ../bin/ftp7.exe
ftpserv: ../bin/ftpserv.exe
hd: ../bin/hd.exe
ide7: ../bin/ide7.exe
make7: ../bin/make7.exe
portfwd7: ../bin/portfwd7.exe
pv7: ../bin/pv7.exe
s7check: ../bin/s7check.exe
sql7: ../bin/sql7.exe
sydir7: ../bin/sydir7.exe
tar7: ../bin/tar7.exe
toutf8: ../bin/toutf8.exe
which: ../bin/which.exe

utils: $(UTILS_BIN)

wc: $(SRC)
	$(WC_ECHO) SRC:
	wc $(SRC)
	$(WC_ECHO) SEED7_LIB_SRC:
	wc $(SEED7_LIB_SRC)
	$(WC_ECHO) DRAW_LIB_SRC:
	wc $(DRAW_LIB_SRC)
	$(WC_ECHO) CONSOLE_LIB_SRC:
	wc $(CONSOLE_LIB_SRC)
	$(WC_ECHO) DATABASE_LIB_SRC:
	wc $(DATABASE_LIB_SRC)
	$(WC_ECHO) COMP_DATA_LIB_SRC:
	wc $(COMP_DATA_LIB_SRC)
	$(WC_ECHO) COMPILER_LIB_SRC:
	wc $(COMPILER_LIB_SRC)

lint: $(SRC)
	lint -p $(SRC) $(ALL_SYSTEM_LIBS)

lint2: $(SRC)
	lint -Zn2048 $(SRC) $(ALL_SYSTEM_LIBS)
