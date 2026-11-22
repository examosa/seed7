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
LIB_EXT = _emc.a
USE_GMP ?= 0
MAKEFILE_NAME = mk_emccw.mak
SPECIAL_LIB = pre_js.js
# CC = em++
CC = emcc
CXX = em++
HOST_CC ?= gcc
AR = emar
ARFLAGS = r
CC_ENVIRONMENT_INI = emcc_env.ini

include mk_lib.mak
include mk_src.mak

ALL_S7_LIBS = $(addprefix ..\bin\,$(S7_LIBS))
DSRC = $(EMC_DSRC)
DRAW_LIB_SRC = $(EMC_DRAW_SRC)
CONSOLE_LIB_SRC = $(EMC_CON_SRC)

include mk_obj_o.mak

EMCC_UTILS = $(filter-out db7 ide7,$(UTILS))
UTILS_BIN = $(addprefix ../bin/,$(addsuffix .js,$(EMCC_UTILS)))
UTILS_JS_WIN = $(addprefix ..\bin\,$(addsuffix .js,$(UTILS)))
UTILS_WASM_WIN = $(addprefix ..\bin\,$(addsuffix .wasm,$(UTILS)))

s7: next_lvl
	$(MAKE) -f $(MAKEFILE_NAME) ..\bin\s7.js ..\prg\s7.js
	node ..\bin\s7.js -l ..\lib level
	node --stack-size=8192 ..\bin\s7.js -l ..\lib -q ..\prg\confval > ..\bin\cc_conf_emcc.prop
	@echo.
	@echo Use 'make s7c' (with your make command) to create the compiler.
	@echo.

s7c: ..\bin\s7c.js ..\prg\s7c.js
	@echo.
	@echo Use 'make test' (with your make command) to check Seed7.
	@echo.

..\bin\s7.js: $(OBJ) $(ALL_S7_LIBS) ..\bin\$(SPECIAL_LIB)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(ALL_SYSTEM_LIBS) --pre-js ..\bin\$(SPECIAL_LIB) -o ..\bin\s7.js

..\prg\s7.js: ..\bin\s7.js
	copy ..\bin\s7.js ..\prg /Y
	copy ..\bin\s7.wasm ..\prg /Y

..\bin\s7c.js: ..\prg\s7c.js
	copy ..\prg\s7c.js ..\bin /Y
	copy ..\prg\s7c.wasm ..\bin /Y

..\prg\s7c.js: ..\prg\s7c.sd7 $(ALL_S7_LIBS) ..\bin\$(SPECIAL_LIB)
	node --stack-size=8192 ..\bin\s7.js -l ..\lib ..\prg\s7c -l ..\lib -b ..\bin -O2 ..\prg\s7c

levelup.exe: levelup.c
	$(HOST_CC) $< -o levelup

next_lvl: levelup.exe
	.\levelup.exe

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

.PHONY: clean s7 s7c test minimal_test check install all next_lvl strip clean_utils distclean uninstall utils wc lint lint2

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
	del $(UTILS_JS_WIN)
	del $(UTILS_WASM_WIN)

distclean: clean clean_utils
	del level_bk.h level.h vers_emccw.h

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
	@echo.
	@echo Cannot strip.
	@echo.

chkccomp.h:
	echo #define LIST_DIRECTORY_CONTENTS "dir" > chkccomp.h
	echo #define UNIX_DO_SLEEP >> chkccomp.h
	echo #define REMOVE_WASM >> chkccomp.h
	echo #define USE_GMP $(USE_GMP) >> chkccomp.h
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
	echo #define MAKEFILE_NAME "$(MAKEFILE_NAME)" >> settings.h
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
	echo #define CPLUSPLUS_COMPILER "$(CXX)" >> settings.h
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
	$(HOST_CC) $< -o chkccomp

setwpath.exe: setwpath.c version.h
	$(HOST_CC) $< -o setwpath

wrdepend.exe: wrdepend.c version.h
	$(HOST_CC) $< -o wrdepend

sudo.exe: sudo.c
	$(HOST_CC) $< -w -o sudo

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

..\bin\$(SPECIAL_LIB): pre_js.js
	copy $< $@

../bin/%.js: ../prg/%.sd7 ..\bin\s7c.js
	node --stack-size=8192 ..\bin\s7c.js -l ..\lib -b ..\bin -O2 $(subst /,\,$(<:.sd7=))
	copy $(subst /,\,$(<:.sd7=.js)) ..\bin /Y
	del $(subst /,\,$(<:.sd7=.js))
	copy $(subst /,\,$(<:.sd7=.wasm)) ..\bin /Y
	del $(subst /,\,$(<:.sd7=.wasm))

bas7: ../bin/bas7.js
bigfiles: ../bin/bigfiles.js
calc7: ../bin/calc7.js
cat: ../bin/cat.js
comanche: ../bin/comanche.js
db7: ../bin/db7.js
diff7: ../bin/diff7.js
find7: ../bin/find7.js
findchar: ../bin/findchar.js
ftp7: ../bin/ftp7.js
ftpserv: ../bin/ftpserv.js
hd: ../bin/hd.js
ide7: ../bin/ide7.js
make7: ../bin/make7.js
portfwd7: ../bin/portfwd7.js
pv7: ../bin/pv7.js
s7check: ../bin/s7check.js
sql7: ../bin/sql7.js
sydir7: ../bin/sydir7.js
tar7: ../bin/tar7.js
toutf8: ../bin/toutf8.js
which: ../bin/which.js

utils: $(UTILS_BIN)

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
