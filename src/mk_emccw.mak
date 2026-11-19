# Makefile for mingw32-make (or make7), emcc from Emscripten and gcc from MinGW. Commands executed by: cmd.exe
# To compile use a Windows console and call:
#   mingw32-make -f mk_emccw.mak depend
#   mingw32-make -f mk_emccw.mak

# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS = -O3 -g -gsource-map -ffunction-sections -fdata-sections -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -ffunction-sections -fdata-sections -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -g -gsource-map -s TOTAL_STACK=1048576 -s ASSERTIONS=0 -s ALLOW_MEMORY_GROWTH=1 -s EXIT_RUNTIME -s EXPORTED_RUNTIME_METHODS=['ccall','cwrap','UTF8ToString'] -s ASYNCIFY -s ASYNCIFY_STACK_SIZE=16384
# LDFLAGS = -Wl,--gc-sections,--stack,8388608,--subsystem,windows
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS = -lnodefs.js
# SYSTEM_LIBS = -lm -lws2_32 -lgmp
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_CONSOLE_LIBS =
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_DRAW_LIBS =
SYSTEM_MATH_LIBS =
ALL_SYSTEM_LIBS = $(SYSTEM_LIBS) $(SYSTEM_BIGINT_LIBS) $(SYSTEM_CONSOLE_LIBS) $(SYSTEM_DATABASE_LIBS) $(SYSTEM_DRAW_LIBS) $(SYSTEM_MATH_LIBS)
SEED7_LIB = seed7_05_emc.a
DRAW_LIB = s7_draw_emc.a
CONSOLE_LIB = s7_con_emc.a
DATABASE_LIB = s7_db_emc.a
COMP_DATA_LIB = s7_data_emc.a
COMPILER_LIB = s7_comp_emc.a
SPECIAL_LIB = pre_js.js
ALL_S7_LIBS = ..\bin\$(COMPILER_LIB) ..\bin\$(COMP_DATA_LIB) ..\bin\$(DRAW_LIB) ..\bin\$(CONSOLE_LIB) ..\bin\$(DATABASE_LIB) ..\bin\$(SEED7_LIB)
# CC = em++
CC = emcc
CC_ENVIRONMENT_INI = emcc_env.ini

DSRC = big_rtl.c big_gmp.c cmd_unx.c dir_win.c dll_unx.c emc_utl.c fil_emc.c pcs_unx.c pol_unx.c \
       soc_none.c tim_emc.c
DRAW_LIB_SRC = gkb_rtl.c drw_emc.c gkb_emc.c
CONSOLE_LIB_SRC = kbd_rtl.c con_emc.c

include mk_src.mak
include mk_obj_o.mak

s7: ..\bin\s7.js ..\prg\s7.js
	node ..\bin\s7.js -l ..\lib level
	node --stack-size=8192 ..\bin\s7.js -l ..\lib -q ..\prg\confval > ..\bin\cc_conf_emcc.prop
	@echo.
	@echo Use 'make s7c' (with your make command) to create the compiler.
	@echo.

s7c: ..\bin\s7c.js ..\prg\s7c.js
	@echo.
	@echo Use 'make test' (with your make command) to check Seed7.
	@echo.

..\bin\s7.js: levelup.exe next_lvl $(OBJ) $(ALL_S7_LIBS) ..\bin\$(SPECIAL_LIB)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(ALL_SYSTEM_LIBS) --pre-js ..\bin\$(SPECIAL_LIB) -o ..\bin\s7.js
	del next_lvl

..\prg\s7.js: ..\bin\s7.js
	copy ..\bin\s7.js ..\prg /Y
	copy ..\bin\s7.wasm ..\prg /Y

..\bin\s7c.js: ..\prg\s7c.js
	copy ..\prg\s7c.js ..\bin /Y
	copy ..\prg\s7c.wasm ..\bin /Y

..\prg\s7c.js: ..\prg\s7c.sd7 $(ALL_S7_LIBS) ..\bin\$(SPECIAL_LIB)
	node --stack-size=8192 ..\bin\s7.js -l ..\lib ..\prg\s7c -l ..\lib -b ..\bin -O2 ..\prg\s7c

levelup.exe: levelup.c
	gcc levelup.c -o levelup

next_lvl: levelup.exe
	.\levelup.exe
	echo X > next_lvl

sql_%.o: sql_%.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INCLUDE_OPTIONS) $< -o $@

big_%.o: big_%.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INCLUDE_OPTIONS) $< -o $@

sql_db2.o: sql_db2.c
	$(CC) -c $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(CFLAGS) $(INCLUDE_OPTIONS) $<

sql_ifx.o: sql_ifx.c
	$(CC) -c $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(CFLAGS) $(INCLUDE_OPTIONS) $<

sql_srv.o: sql_srv.c
	$(CC) -c $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(CFLAGS) $(INCLUDE_OPTIONS) $<

.PHONY: clean s7 s7c test check install all next_lvl strip clean_utils distclean uninstall

clean:
	del *.o
	del $(ALL_S7_LIBS)
	del ..\bin\s7.js
	del ..\bin\s7.wasm
	del ..\bin\$(CC_ENVIRONMENT_INI)
	del ..\bin\s7c.js
	del ..\bin\s7c.wasm
	del ..\bin\$(SPECIAL_LIB)
	del ..\prg\s7.js
	del ..\prg\s7.wasm
	del ..\prg\s7c.js
	del ..\prg\s7c.wasm
	del depend
	del macros
	del chkccomp.h
	del base.h
	del settings.h
	del version.h
	del chkccomp.exe
	del setwpath.exe
	del wrdepend.exe
	del sudo.exe
	del levelup.exe
	del next_lvl
	@echo.
	@echo Use 'make depend' (with your make command) to create the dependencies.
	@echo.

clean_utils:
	del ..\bin\bas7.js
	del ..\bin\bigfiles.js
	del ..\bin\calc7.js
	del ..\bin\cat.js
	del ..\bin\comanche.js
	del ..\bin\db7.js
	del ..\bin\diff7.js
	del ..\bin\find7.js
	del ..\bin\findchar.js
	del ..\bin\ftp7.js
	del ..\bin\ftpserv.js
	del ..\bin\hd.js
	del ..\bin\ide7.js
	del ..\bin\make7.js
	del ..\bin\portfwd7.js
	del ..\bin\pv7.js
	del ..\bin\s7check.js
	del ..\bin\sql7.js
	del ..\bin\sydir7.js
	del ..\bin\tar7.js
	del ..\bin\toutf8.js
	del ..\bin\which.js
	del ..\bin\bas7.wasm
	del ..\bin\bigfiles.wasm
	del ..\bin\calc7.wasm
	del ..\bin\cat.wasm
	del ..\bin\comanche.wasm
	del ..\bin\db7.wasm
	del ..\bin\diff7.wasm
	del ..\bin\find7.wasm
	del ..\bin\findchar.wasm
	del ..\bin\ftp7.wasm
	del ..\bin\ftpserv.wasm
	del ..\bin\hd.wasm
	del ..\bin\ide7.wasm
	del ..\bin\make7.wasm
	del ..\bin\portfwd7.wasm
	del ..\bin\pv7.wasm
	del ..\bin\s7check.wasm
	del ..\bin\sql7.wasm
	del ..\bin\sydir7.wasm
	del ..\bin\tar7.wasm
	del ..\bin\toutf8.wasm
	del ..\bin\which.wasm

distclean: clean clean_utils
	del level_bk.h
	del level.h
	del vers_emccw.h

test:
	node ..\bin\s7.js -l ..\lib ..\prg\chk_all build
	@echo.
	@echo Use 'sudo make install' (with your make command) to install Seed7.
	@echo Or open a console as administrator, go to the directory seed7/src
	@echo and use 'make install' (with your make command) to install Seed7.
	@echo.

minimal_test:
	node ..\bin\s7.js -l ..\lib ..\prg\chk_all build minimal_test

check: test

install: setwpath.exe
	.\setwpath.exe add ..\bin

uninstall: setwpath.exe
	.\setwpath.exe remove ..\bin

strip:
	strip ..\bin\s7.exe

chkccomp.h:
	echo #define LIST_DIRECTORY_CONTENTS "dir" > chkccomp.h
	echo #define UNIX_DO_SLEEP >> chkccomp.h
	echo #define REMOVE_WASM >> chkccomp.h
	echo #define USE_GMP 0 >> chkccomp.h
	echo #define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)" >> chkccomp.h
	echo #define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)" >> chkccomp.h

base.h:
	echo #define PATH_DELIMITER '\\' > base.h
	echo #define QUOTE_WHOLE_SHELL_COMMAND >> base.h
	echo #define OBJECT_FILE_EXTENSION ".o" >> base.h
	echo #define C_COMPILER "$(CC)" >> base.h
	echo #define CC_OPT_VERSION_INFO "--version" >> base.h
	echo #define CC_FLAGS "" >> base.h
	echo #define CC_ERROR_FILEDES 2 >> base.h
	echo #define CC_VERSION_INFO_FILEDES 1 >> base.h
	echo #define LINKER_OPT_OUTPUT_FILE "-o " >> base.h
	echo #define LINKED_PROGRAM_EXTENSION ".js" >> base.h
	echo #define INTERPRETER_FOR_LINKED_PROGRAM "node" >> base.h
	echo #define MOUNT_NODEFS >> base.h
	echo #define EMULATE_ENVIRONMENT >> base.h
	echo #define EMULATE_NODE_ENVIRONMENT >> base.h
	echo #define DETERMINE_OS_PROPERTIES_AT_RUNTIME >> base.h
	echo #define SYSTEM_LIBS "$(SYSTEM_LIBS)" >> base.h
	echo #define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)" >> base.h

settings.h:
	echo #define MAKE_UTILITY_NAME "$(MAKE)" > settings.h
	echo #define MAKEFILE_NAME "mk_emccw.mak" >> settings.h
	echo #define SEARCH_PATH_DELIMITER 0 >> settings.h
	echo #define AWAIT_WITH_NANOSLEEP >> settings.h
	echo #define IMPLEMENT_PTY_WITH_PIPE2 >> settings.h
	echo #define USE_EGL >> settings.h
	echo #define CONSOLE_UTF8 >> settings.h
	echo #define OS_STRI_UTF8 >> settings.h
	echo #define LIBRARY_FILE_EXTENSION ".a" >> settings.h
	echo #define USE_CONSOLE_FOR_PROT_CSTRI >> settings.h
	echo #define DEFINE_SYSTEM_FUNCTION >> settings.h
	echo #define USE_START_MAIN >> settings.h
	echo #define USE_DO_EXIT >> settings.h
	echo #define os_exit doExit >> settings.h
	echo #define os_atexit registerExitFunction >> settings.h
	echo #define CALL_C_COMPILER_FROM_SHELL 1 >> settings.h
	echo #define CPLUSPLUS_COMPILER "em++" >> settings.h
	echo #define CC_OPT_DEBUG_INFO "-g" >> settings.h
	echo #define CC_OPT_NO_WARNINGS "-w" >> settings.h
	echo #define LINKER_OPT_NO_DEBUG_INFO "-Wl,--strip-debug" >> settings.h
	echo #define LINKER_OPT_SPECIAL_LIB "--pre-js" >> settings.h
	echo #define LINKER_FLAGS "$(LDFLAGS)" >> settings.h
	echo #define SEED7_LIB "$(SEED7_LIB)" >> settings.h
	echo #define DRAW_LIB "$(DRAW_LIB)" >> settings.h
	echo #define CONSOLE_LIB "$(CONSOLE_LIB)" >> settings.h
	echo #define DATABASE_LIB "$(DATABASE_LIB)" >> settings.h
	echo #define COMP_DATA_LIB "$(COMP_DATA_LIB)" >> settings.h
	echo #define COMPILER_LIB "$(COMPILER_LIB)" >> settings.h
	echo #define SPECIAL_LIB "$(SPECIAL_LIB)" >> settings.h

version.h: chkccomp.exe base.h settings.h
	.\chkccomp.exe version.h "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)" "CC_ENVIRONMENT_INI=$(CC_ENVIRONMENT_INI)"
	del ctest*.wasm
	set > ..\bin\$(CC_ENVIRONMENT_INI)
	copy version.h vers_emccw.h /Y

chkccomp.exe: chkccomp.c chkccomp.h base.h settings.h
	gcc chkccomp.c -o chkccomp

setwpath.exe: version.h setwpath.c
	gcc setwpath.c -o setwpath

wrdepend.exe: version.h wrdepend.c
	gcc wrdepend.c -o wrdepend

sudo.exe: sudo.c
	gcc sudo.c -w -o sudo

depend: version.h setwpath.exe wrdepend.exe sudo.exe
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(SRC) "> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(SEED7_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(DRAW_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(CONSOLE_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(DATABASE_LIB_SRC_STD_INCL) ">> depend"
	.\wrdepend.exe OPTION=DB2_INCLUDE_OPTION $(CFLAGS) -M -c sql_db2.c ">> depend"
	.\wrdepend.exe OPTION=INFORMIX_INCLUDE_OPTION $(CFLAGS) -M -c sql_ifx.c ">> depend"
	.\wrdepend.exe OPTION=SQL_SERVER_INCLUDE_OPTION $(CFLAGS) -M -c sql_srv.c ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(COMP_DATA_LIB_SRC) ">> depend"
	.\wrdepend.exe OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(COMPILER_LIB_SRC) ">> depend"
	@echo.
	@echo Use 'make' (with your make command) to create the interpreter.
	@echo.

..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	emar r ..\bin\$(SEED7_LIB) $(SEED7_LIB_OBJ)

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	emar r ..\bin\$(DRAW_LIB) $(DRAW_LIB_OBJ)

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	emar r ..\bin\$(CONSOLE_LIB) $(CONSOLE_LIB_OBJ)

..\bin\$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
	emar r ..\bin\$(DATABASE_LIB) $(DATABASE_LIB_OBJ)

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	emar r ..\bin\$(COMP_DATA_LIB) $(COMP_DATA_LIB_OBJ)

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	emar r ..\bin\$(COMPILER_LIB) $(COMPILER_LIB_OBJ)

..\bin\$(SPECIAL_LIB): pre_js.js
	copy pre_js.js ..\bin\$(SPECIAL_LIB)

..\bin\bas7.js: ..\prg\bas7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\bas7
	copy ..\prg\bas7.js ..\bin /Y
	del ..\prg\bas7.js

..\bin\bigfiles.js: ..\prg\bigfiles.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\bigfiles
	copy ..\prg\bigfiles.js ..\bin /Y
	del ..\prg\bigfiles.js

..\bin\calc7.js: ..\prg\calc7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\calc7
	copy ..\prg\calc7.js ..\bin /Y
	del ..\prg\calc7.js

..\bin\cat.js: ..\prg\cat.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\cat
	copy ..\prg\cat.js ..\bin /Y
	del ..\prg\cat.js

..\bin\comanche.js: ..\prg\comanche.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\comanche
	copy ..\prg\comanche.js ..\bin /Y
	del ..\prg\comanche.js

..\bin\db7.js: ..\prg\db7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\db7
	copy ..\prg\db7.js ..\bin /Y
	del ..\prg\db7.js

..\bin\diff7.js: ..\prg\diff7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\diff7
	copy ..\prg\diff7.js ..\bin /Y
	del ..\prg\diff7.js

..\bin\find7.js: ..\prg\find7.sd7 ..\bin\s7c.js
	node ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\find7
	copy ..\prg\find7.js ..\bin /Y
	del ..\prg\find7.js

..\bin\findchar.js: ..\prg\findchar.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\findchar
	copy ..\prg\findchar.js ..\bin /Y
	del ..\prg\findchar.js

..\bin\ftp7.js: ..\prg\ftp7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\ftp7
	copy ..\prg\ftp7.js ..\bin /Y
	del ..\prg\ftp7.js

..\bin\ftpserv.js: ..\prg\ftpserv.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\ftpserv
	copy ..\prg\ftpserv.js ..\bin /Y
	del ..\prg\ftpserv.js

..\bin\hd.js: ..\prg\hd.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\hd
	copy ..\prg\hd.js ..\bin /Y
	del ..\prg\hd.js

..\bin\ide7.js: ..\prg\ide7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\ide7
	copy ..\prg\ide7.js ..\bin /Y
	del ..\prg\ide7.js

..\bin\make7.js: ..\prg\make7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\make7
	copy ..\prg\make7.js ..\bin /Y
	del ..\prg\make7.js

..\bin\portfwd7.js: ..\prg\portfwd7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\portfwd7
	copy ..\prg\portfwd7.js ..\bin /Y
	del ..\prg\portfwd7.js

..\bin\pv7.js: ..\prg\pv7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\pv7
	copy ..\prg\pv7.js ..\bin /Y
	del ..\prg\pv7.js

..\bin\s7check.js: ..\prg\s7check.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\s7check
	copy ..\prg\s7check.js ..\bin /Y
	del ..\prg\s7check.js

..\bin\sql7.js: ..\prg\sql7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\sql7
	copy ..\prg\sql7.js ..\bin /Y
	del ..\prg\sql7.js

..\bin\sydir7.js: ..\prg\sydir7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\sydir7
	copy ..\prg\sydir7.js ..\bin /Y
	del ..\prg\sydir7.js

..\bin\tar7.js: ..\prg\tar7.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\tar7
	copy ..\prg\tar7.js ..\bin /Y
	del ..\prg\tar7.js

..\bin\toutf8.js: ..\prg\toutf8.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\toutf8
	copy ..\prg\toutf8.js ..\bin /Y
	del ..\prg\toutf8.js

..\bin\which.js: ..\prg\which.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 ..\prg\which
	copy ..\prg\which.js ..\bin /Y
	del ..\prg\which.js

bas7: ..\bin\bas7.js
bigfiles: ..\bin\bigfiles.js
calc7: ..\bin\calc7.js
cat: ..\bin\cat.js
comanche: ..\bin\comanche.js
db7: ..\bin\db7.js
diff7: ..\bin\diff7.js
find7: ..\bin\find7.js
findchar: ..\bin\findchar.js
ftp7: ..\bin\ftp7.js
ftpserv: ..\bin\ftpserv.js
hd: ..\bin\hd.js
ide7: ..\bin\ide7.js
make7: ..\bin\make7.js
portfwd7: ..\bin\portfwd7.js
pv7: ..\bin\pv7.js
s7check: ..\bin\s7check.js
sql7: ..\bin\sql7.js
sydir7: ..\bin\sydir7.js
tar7: ..\bin\tar7.js
toutf8: ..\bin\toutf8.js
which: ..\bin\which.js

utils: ..\bin\bas7.js ..\bin\bigfiles.js ..\bin\calc7.js ..\bin\cat.js ..\bin\comanche.js \
       ..\bin\diff7.js ..\bin\find7.js ..\bin\findchar.js ..\bin\ftp7.js ..\bin\ftpserv.js ..\bin\hd.js \
       ..\bin\make7.js ..\bin\portfwd7.js ..\bin\pv7.js ..\bin\s7check.js ..\bin\sql7.js \
       ..\bin\sydir7.js ..\bin\tar7.js ..\bin\toutf8.js ..\bin\which.js

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

ifeq (depend,$(wildcard depend))
include depend
endif

ifeq (macros,$(wildcard macros))
include macros
endif
