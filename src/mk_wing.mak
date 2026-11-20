# Common Windows cmd.exe GNU-make / make7 rules shared by mk_mingw.mak,
# mk_mingc.mak, mk_clangw.mak, and mk_tcc_w.mak.

SYSTEM_CONSOLE_LIBS ?=
SYSTEM_DRAW_LIBS ?= -lgdi32
SYSTEM_MATH_LIBS ?= -lm
ALL_SYSTEM_LIBS = $(SYSTEM_LIBS) $(SYSTEM_BIGINT_LIBS) $(SYSTEM_CONSOLE_LIBS) $(SYSTEM_DATABASE_LIBS) $(SYSTEM_DRAW_LIBS) $(SYSTEM_MATH_LIBS)
LIB_EXT ?= .a
SEED7_LIB = seed7_05$(LIB_EXT)
DRAW_LIB = s7_draw$(LIB_EXT)
CONSOLE_LIB = s7_con$(LIB_EXT)
DATABASE_LIB = s7_db$(LIB_EXT)
COMP_DATA_LIB = s7_data$(LIB_EXT)
COMPILER_LIB = s7_comp$(LIB_EXT)
ALL_S7_LIBS = ..\bin\$(COMPILER_LIB) ..\bin\$(COMP_DATA_LIB) ..\bin\$(DRAW_LIB) ..\bin\$(CONSOLE_LIB) ..\bin\$(DATABASE_LIB) ..\bin\$(SEED7_LIB)

S7_OUT ?= ..\bin\s7.exe
VERBOSE_HINTS ?= yes
HAS_DEPEND ?= yes
HAS_CC_ENV_INI ?= no
INSTALL_USE_SUDO ?= no
TEST_HINT ?= both
DEPEND_STYLE ?= wrdepend_hints
AR_STYLE ?= ar_r

CLEAN_PREREQS =
ifeq ($(HAS_DEPEND),yes)
CLEAN_PREREQS += clean_dep_tools
endif
ifeq ($(HAS_CC_ENV_INI),yes)
CLEAN_PREREQS += clean_cc_env
endif

DSRC = big_rtl.c big_gmp.c cmd_win.c dir_win.c dll_win.c fil_win.c pcs_win.c pol_sel.c segv_win.c \
       soc_none.c stat_win.c tim_win.c
DRAW_LIB_SRC = gkb_rtl.c drw_win.c gkb_win.c
CONSOLE_LIB_SRC = kbd_rtl.c con_win.c

include mk_src.mak
include mk_obj_o.mak

ifeq ($(VERBOSE_HINTS),yes)
s7: ..\bin\s7.exe ..\prg\s7.exe
	..\bin\s7 -l ..\lib level
	@echo.
	@echo Use 'make s7c' (with your make command) to create the compiler.
	@echo.
else
s7: ..\bin\s7.exe ..\prg\s7.exe
	..\bin\s7 -l ..\lib level
endif

ifeq ($(VERBOSE_HINTS),yes)
s7c: ..\bin\s7c.exe ..\prg\s7c.exe
	@echo.
	@echo Use 'make test' (with your make command) to check Seed7.
	@echo.
else
s7c: ..\bin\s7c.exe ..\prg\s7c.exe
endif

..\bin\s7.exe: levelup.exe next_lvl $(OBJ) $(ALL_S7_LIBS)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(ALL_SYSTEM_LIBS) -o $(S7_OUT)
	del next_lvl

..\prg\s7.exe: ..\bin\s7.exe
	copy ..\bin\s7.exe ..\prg /Y

..\bin\s7c.exe: ..\prg\s7c.exe
	copy ..\prg\s7c.exe ..\bin /Y

..\prg\s7c.exe: ..\prg\s7c.sd7 $(ALL_S7_LIBS)
	..\bin\s7 -l ..\lib ..\prg\s7c -l ..\lib -b ..\bin -O2 ..\prg\s7c

next_lvl: levelup.exe
	.\levelup.exe
	echo X > next_lvl

all: depend
	$(MAKE) -f $(MAKEFILE_NAME) s7
	$(MAKE) -f $(MAKEFILE_NAME) s7c

.PHONY: clean s7 s7c test check install all next_lvl strip clean_utils distclean uninstall

ifeq ($(HAS_DEPEND),yes)
clean_dep_tools:
	del wrdepend.exe
	del sudo.exe
endif

ifeq ($(HAS_CC_ENV_INI),yes)
clean_cc_env:
	del ..\bin\$(CC_ENVIRONMENT_INI)
endif

ifeq ($(VERBOSE_HINTS),yes)
clean: $(CLEAN_PREREQS)
	del *.o
	del $(ALL_S7_LIBS)
	del ..\bin\s7.exe
	del ..\bin\s7c.exe
	del ..\prg\s7.exe
	del ..\prg\s7c.exe
	del depend
	del macros
	del chkccomp.h
	del base.h
	del settings.h
	del version.h
	del chkccomp.exe
	del setwpath.exe
	del levelup.exe
	del next_lvl
	@echo.
	@echo Use 'make depend' (with your make command) to create the dependencies.
	@echo.
else
clean: $(CLEAN_PREREQS)
	del *.o
	del $(ALL_S7_LIBS)
	del ..\bin\s7.exe
	del ..\bin\s7c.exe
	del ..\prg\s7.exe
	del ..\prg\s7c.exe
	del depend
	del macros
	del chkccomp.h
	del base.h
	del settings.h
	del version.h
	del chkccomp.exe
	del setwpath.exe
	del levelup.exe
	del next_lvl
endif

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

ifeq ($(TEST_HINT),both)
test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build
	@echo.
	@echo Use 'sudo make install' (with your make command) to install Seed7.
	@echo Or open a console as administrator, go to the directory seed7/src
	@echo and use 'make install' (with your make command) to install Seed7.
	@echo.
endif
ifeq ($(TEST_HINT),admin)
test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build
	@echo.
	@echo Open a console as administrator, go to the directory seed7/src and
	@echo use 'make install' (with your make command) to install Seed7.
	@echo.
endif
ifeq ($(TEST_HINT),none)
test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build
endif

minimal_test:
	..\bin\s7 -l ..\lib ..\prg\chk_all build minimal_test

check: test

ifeq ($(INSTALL_USE_SUDO),yes)
install: setwpath.exe sudo.exe
	.\sudo.exe .\setwpath.exe add ..\bin

uninstall: setwpath.exe sudo.exe
	.\sudo.exe .\setwpath.exe remove ..\bin
else
install: setwpath.exe
	.\setwpath.exe add ..\bin

uninstall: setwpath.exe
	.\setwpath.exe remove ..\bin
endif

strip:
	strip ..\bin\s7.exe

ifeq ($(HAS_CC_ENV_INI),yes)
version.h: chkccomp.exe base.h settings.h
	.\chkccomp.exe version.h "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)" "CC_ENVIRONMENT_INI=$(CC_ENVIRONMENT_INI)"
	set > ..\bin\$(CC_ENVIRONMENT_INI)
	copy version.h $(VERS_FILE) /Y
else
version.h: chkccomp.exe base.h settings.h
	.\chkccomp.exe version.h "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)"
	copy version.h $(VERS_FILE) /Y
endif

ifeq ($(DEPEND_STYLE),wrdepend_hints)
depend: version.h setwpath.exe wrdepend.exe sudo.exe
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SRC) "> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SEED7_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DRAW_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(CONSOLE_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DATABASE_LIB_SRC_STD_INCL) ">> depend"
	.\wrdepend.exe OPTION=DB2_INCLUDE_OPTION $(CFLAGS) -M sql_db2.c ">> depend"
	.\wrdepend.exe OPTION=INFORMIX_INCLUDE_OPTION $(CFLAGS) -M sql_ifx.c ">> depend"
	.\wrdepend.exe OPTION=SQL_SERVER_INCLUDE_OPTION $(CFLAGS) -M sql_srv.c ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMP_DATA_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMPILER_LIB_SRC) ">> depend"
	@echo.
	@echo Use 'make' (with your make command) to create the interpreter.
	@echo.
endif
ifeq ($(DEPEND_STYLE),wrdepend_quiet)
depend: version.h setwpath.exe wrdepend.exe sudo.exe
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SRC) "> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SEED7_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DRAW_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(CONSOLE_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DATABASE_LIB_SRC_STD_INCL) ">> depend"
	.\wrdepend.exe OPTION=DB2_INCLUDE_OPTION $(CFLAGS) -M sql_db2.c ">> depend"
	.\wrdepend.exe OPTION=INFORMIX_INCLUDE_OPTION $(CFLAGS) -M sql_ifx.c ">> depend"
	.\wrdepend.exe OPTION=SQL_SERVER_INCLUDE_OPTION $(CFLAGS) -M sql_srv.c ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMP_DATA_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMPILER_LIB_SRC) ">> depend"
endif
ifeq ($(DEPEND_STYLE),none)
depend: version.h setwpath.exe
	@echo Working without C header dependency checks.
	@echo.
	@echo Use 'make' (with your make command) to create the interpreter.
	@echo.
endif

ifeq ($(AR_STYLE),ar_r)
..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	$(AR) r ..\bin\$(SEED7_LIB) $(SEED7_LIB_OBJ)

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	$(AR) r ..\bin\$(DRAW_LIB) $(DRAW_LIB_OBJ)

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	$(AR) r ..\bin\$(CONSOLE_LIB) $(CONSOLE_LIB_OBJ)

..\bin\$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
	$(AR) r ..\bin\$(DATABASE_LIB) $(DATABASE_LIB_OBJ)

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	$(AR) r ..\bin\$(COMP_DATA_LIB) $(COMP_DATA_LIB_OBJ)

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	$(AR) r ..\bin\$(COMPILER_LIB) $(COMPILER_LIB_OBJ)
endif
ifeq ($(AR_STYLE),lib_out)
..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	$(AR) /out:..\bin\$(SEED7_LIB) $(SEED7_LIB_OBJ)

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	$(AR) /out:..\bin\$(DRAW_LIB) $(DRAW_LIB_OBJ)

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	$(AR) /out:..\bin\$(CONSOLE_LIB) $(CONSOLE_LIB_OBJ)

..\bin\$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
	$(AR) /out:..\bin\$(DATABASE_LIB) $(DATABASE_LIB_OBJ)

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	$(AR) /out:..\bin\$(COMP_DATA_LIB) $(COMP_DATA_LIB_OBJ)

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	$(AR) /out:..\bin\$(COMPILER_LIB) $(COMPILER_LIB_OBJ)
endif
ifeq ($(AR_STYLE),ar_direct)
..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	$(AR) ..\bin\$(SEED7_LIB) $(SEED7_LIB_OBJ)

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	$(AR) ..\bin\$(DRAW_LIB) $(DRAW_LIB_OBJ)

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	$(AR) ..\bin\$(CONSOLE_LIB) $(CONSOLE_LIB_OBJ)

..\bin\$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
	$(AR) ..\bin\$(DATABASE_LIB) $(DATABASE_LIB_OBJ)

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	$(AR) ..\bin\$(COMP_DATA_LIB) $(COMP_DATA_LIB_OBJ)

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	$(AR) ..\bin\$(COMPILER_LIB) $(COMPILER_LIB_OBJ)
endif

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

utils: ../bin/bas7.exe ../bin/bigfiles.exe ../bin/calc7.exe ../bin/cat.exe ../bin/comanche.exe ../bin/db7.exe \
       ../bin/diff7.exe ../bin/find7.exe ../bin/findchar.exe ../bin/ftp7.exe ../bin/ftpserv.exe ../bin/hd.exe \
       ../bin/ide7.exe ../bin/make7.exe ../bin/portfwd7.exe ../bin/pv7.exe ../bin/s7check.exe ../bin/sql7.exe \
       ../bin/sydir7.exe ../bin/tar7.exe ../bin/toutf8.exe ../bin/which.exe

wc: $(SRC)
	@echo SRC:
	wc $(SRC)
	@echo SEED7_LIB_SRC:
	wc $(SEED7_LIB_SRC)
	@echo DRAW_LIB_SRC:
	wc $(DRAW_LIB_SRC)
	@echo CONSOLE_LIB_SRC:
	wc $(CONSOLE_LIB_SRC)
	@echo DATABASE_LIB_SRC:
	wc $(DATABASE_LIB_SRC)
	@echo COMP_DATA_LIB_SRC:
	wc $(COMP_DATA_LIB_SRC)
	@echo COMPILER_LIB_SRC:
	wc $(COMPILER_LIB_SRC)

lint: $(SRC)
	lint -p $(SRC) $(ALL_SYSTEM_LIBS)

lint2: $(SRC)
	lint -Zn2048 $(SRC) $(ALL_SYSTEM_LIBS)

ifeq ($(HAS_DEPEND),yes)
ifeq (depend,$(wildcard depend))
include depend
endif
endif

ifeq (macros,$(wildcard macros))
include macros
endif
