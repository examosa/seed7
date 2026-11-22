# Makefile for linux/bsd/unix, emcc from Emscripten and gcc. Commands executed by: bash
# To compile use a command shell and call:
#   make -f mk_emccl.mak depend
#   make -f mk_emccl.mak

.DEFAULT_GOAL := s7
.DELETE_ON_ERROR:
THIS_MAKEFILE := $(firstword $(MAKEFILE_LIST))
MAKEFILE_NAME ?= $(notdir $(THIS_MAKEFILE))

# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
CFLAGS = -O3 -g -gsource-map -ffunction-sections -fdata-sections -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -ffunction-sections -fdata-sections -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -g -gsource-map -s TOTAL_STACK=1048576 -s ASSERTIONS=0 -s ALLOW_MEMORY_GROWTH=1 -s EXIT_RUNTIME -s EXPORTED_RUNTIME_METHODS=['ccall','cwrap','UTF8ToString'] -s ASYNCIFY -s ASYNCIFY_STACK_SIZE=16384
# LDFLAGS = -Wl,--gc-sections,--stack,8388608
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS = -lnodefs.js
# SYSTEM_LIBS = -lm -lws2_32 -lgmp
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_CONSOLE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DRAW_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_MATH_LIBS = -lm
LIB_EXT = _emc.a
USE_GMP ?= 0
BIGINT_LIBS ?=
SPECIAL_LIB = pre_js.js
# CC = em++
CC = emcc
CXX = em++
HOST_CC ?= gcc
AR = emar
ARFLAGS = r
RM ?= rm -f
CC_ENVIRONMENT_INI = emcc_env.ini
# Some make tools terminate with the error "make: node: Permission denied" if node is called directly.
NODE = `which node`

include mk_lib.mak
include mk_src.mak

ALL_S7_LIBS = $(addprefix ../bin/,$(S7_LIBS))
DSRC = $(EMC_DSRC)
DRAW_LIB_SRC = $(EMC_DRAW_SRC)
CONSOLE_LIB_SRC = $(EMC_CON_SRC)

include mk_obj_o.mak

EMCC_UTILS = $(filter-out db7 ide7,$(UTILS))
UTILS_JS = $(addprefix ../bin/,$(addsuffix .js,$(UTILS)))
UTILS_WASM = $(addprefix ../bin/,$(addsuffix .wasm,$(UTILS)))

s7: next_lvl
	$(MAKE) -f $(THIS_MAKEFILE) ../bin/s7.js ../prg/s7.js
	$(NODE) ../bin/s7.js -l ../lib level
	$(NODE) --stack-size=8192 ../bin/s7.js -l ../lib -q ../prg/confval > ../bin/cc_conf_emcc.prop
	@echo
	@echo "  Use 'make s7c' (with your make command) to create the compiler."
	@echo

s7c: ../bin/s7c.js ../prg/s7c.js
	@echo
	@echo "  Use 'make test' (with your make command) to check Seed7."
	@echo

../bin/s7.js: $(OBJ) $(ALL_S7_LIBS) ../bin/$(SPECIAL_LIB)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(ALL_SYSTEM_LIBS) --pre-js ../bin/$(SPECIAL_LIB) -o $@

../prg/s7.js: ../bin/s7.js
	ln -sf ../bin/s7.js ../prg
	ln -sf ../bin/s7.wasm ../prg

../bin/s7c.js: ../prg/s7c.js
	cp -p ../prg/s7c.js ../bin
	cp -p ../prg/s7c.wasm ../bin

../prg/s7c.js: ../prg/s7c.sd7 $(ALL_S7_LIBS) ../bin/$(SPECIAL_LIB)
	$(NODE) --stack-size=8192 ../bin/s7.js -l ../lib ../prg/s7c -l ../lib -b ../bin -O2 ../prg/s7c

levelup: levelup.c
	$(HOST_CC) $< -o $@

next_lvl: levelup
	./levelup

sql_%.o: sql_%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INCLUDE_OPTIONS) -c $< -o $@

big_%.o: big_%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INCLUDE_OPTIONS) -c $< -o $@

sql_db2.o: sql_db2.c
	$(CC) $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(CFLAGS) $(INCLUDE_OPTIONS) -c $<

sql_ifx.o: sql_ifx.c
	$(CC) $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(CFLAGS) $(INCLUDE_OPTIONS) -c $<

sql_srv.o: sql_srv.c
	$(CC) $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(CFLAGS) $(INCLUDE_OPTIONS) -c $<

.PHONY: clean s7 s7c test minimal_test check install all next_lvl dep strip clean_utils distclean uninstall utils wc lint lint2 $(UTILS)

clean:
	$(RM) *.o $(ALL_S7_LIBS) ../bin/s7.js ../bin/s7.wasm ../bin/$(CC_ENVIRONMENT_INI) ../bin/s7c.js ../bin/s7c.wasm ../bin/$(SPECIAL_LIB)
	$(RM) ../prg/s7.js ../prg/s7.wasm ../prg/s7c.js ../prg/s7c.wasm
	$(RM) depend macros chkccomp.h base.h settings.h version.h chkccomp wrdepend levelup next_lvl
	@echo
	@echo "  Use 'make depend' (with your make command) to create the dependencies."
	@echo

clean_utils:
	$(RM) $(UTILS_JS) $(UTILS_WASM)

distclean: clean clean_utils
	$(RM) level_bk.h level.h vers_emccl.h

test:
	$(NODE) ../bin/s7.js -l ../lib ../prg/chk_all build
	@echo
	@echo "  Use 'sudo make install' (with your make command) to install Seed7."
	@echo

minimal_test:
	$(NODE) ../bin/s7.js -l ../lib ../prg/chk_all build minimal_test

check: test

install:
	@echo
	@echo "  Cannot install."
	@echo

uninstall:
	@echo
	@echo "  Cannot uninstall."
	@echo

dep: depend

strip:
	@echo
	@echo "  Cannot strip."
	@echo

define _nl


endef

define chkccomp.h
#define LIST_DIRECTORY_CONTENTS "ls"
#define UNIX_DO_SLEEP
#define REMOVE_WASM
#define USE_GMP $(USE_GMP)$(if $(BIGINT_LIBS),$(_nl)#define BIGINT_LIBS "$(BIGINT_LIBS)")
endef

define base.h
#define PATH_DELIMITER '/'
#define OBJECT_FILE_EXTENSION ".o"
#define C_COMPILER "$(CC)"
#define CC_OPT_VERSION_INFO "--version"
#define CC_FLAGS ""
#define CC_ERROR_FILEDES 2
#define CC_VERSION_INFO_FILEDES 1
#define LINKER_OPT_OUTPUT_FILE "-o "
#define LINKED_PROGRAM_EXTENSION ".js"
#define INTERPRETER_FOR_LINKED_PROGRAM "node"
#define MOUNT_NODEFS
#define EMULATE_ENVIRONMENT
#define EMULATE_NODE_ENVIRONMENT
#define DETERMINE_OS_PROPERTIES_AT_RUNTIME
#define SYSTEM_LIBS "$(SYSTEM_LIBS)"
endef

define settings.h
#define MAKE_UTILITY_NAME "$(MAKE)"
#define MAKEFILE_NAME "$(MAKEFILE_NAME)"
#define SEARCH_PATH_DELIMITER 0
#define AWAIT_WITH_NANOSLEEP
#define IMPLEMENT_PTY_WITH_PIPE2
#define USE_EGL
#define CONSOLE_UTF8
#define OS_STRI_UTF8
#define ESCAPE_SHELL_COMMANDS
#define LIBRARY_FILE_EXTENSION ".a"
#define USE_CONSOLE_FOR_PROT_CSTRI
#define DEFINE_SYSTEM_FUNCTION
#define USE_START_MAIN
#define USE_DO_EXIT
#define os_exit doExit
#define os_atexit registerExitFunction
#define CALL_C_COMPILER_FROM_SHELL 1
#define CPLUSPLUS_COMPILER "$(CXX)"
#define CC_OPT_DEBUG_INFO "-g"
#define CC_OPT_NO_WARNINGS "-w"
#define LINKER_OPT_SPECIAL_LIB "--pre-js"
#define LINKER_FLAGS "$(LDFLAGS)"
#define SEED7_LIB "$(SEED7_LIB)"
#define DRAW_LIB "$(DRAW_LIB)"
#define CONSOLE_LIB "$(CONSOLE_LIB)"
#define DATABASE_LIB "$(DATABASE_LIB)"
#define COMP_DATA_LIB "$(COMP_DATA_LIB)"
#define COMPILER_LIB "$(COMPILER_LIB)"
#define SPECIAL_LIB "$(SPECIAL_LIB)"
endef

chkccomp.h base.h settings.h: export _HDR = $($@)
chkccomp.h base.h settings.h:
	@printf '%s\n' "$$_HDR" > $@

version.h: chkccomp base.h settings.h
	./$< $@ "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)" "CC_ENVIRONMENT_INI=$(CC_ENVIRONMENT_INI)"
	$(RM) ctest*.wasm
	env > ../bin/$(CC_ENVIRONMENT_INI)
	cp $@ vers_emccl.h

chkccomp: chkccomp.c chkccomp.h base.h settings.h
	$(HOST_CC) $< -o $@

wrdepend: wrdepend.c version.h
	$(HOST_CC) $< -o $@

depend: version.h wrdepend
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(SRC) "> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(SEED7_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(DRAW_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(CONSOLE_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(DATABASE_LIB_SRC_STD_INCL) ">> depend"
	./wrdepend OPTION=DB2_INCLUDE_OPTION $(CFLAGS) -M -c sql_db2.c ">> depend"
	./wrdepend OPTION=INFORMIX_INCLUDE_OPTION $(CFLAGS) -M -c sql_ifx.c ">> depend"
	./wrdepend OPTION=SQL_SERVER_INCLUDE_OPTION $(CFLAGS) -M -c sql_srv.c ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(COMP_DATA_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M -c $(COMPILER_LIB_SRC) ">> depend"
	@echo
	@echo "  Use 'make' (with your make command) to create the interpreter."
	@echo

../bin/$(SEED7_LIB): $(SEED7_LIB_OBJ)
../bin/$(DRAW_LIB): $(DRAW_LIB_OBJ)
../bin/$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
../bin/$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
../bin/$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
../bin/$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
$(ALL_S7_LIBS):
	$(AR) $(ARFLAGS) $@ $^

../bin/$(SPECIAL_LIB): pre_js.js
	cp $< $@

../bin/%.js: ../prg/%.sd7 ../bin/s7c.js
	$(NODE) --stack-size=8192 ../bin/s7c.js -l ../lib -b ../bin -O3 -oc3 $<
	mv $(<:.sd7=.js) $@
	mv $(<:.sd7=.wasm) ../bin

$(UTILS): %: ../bin/%.js

utils: $(addprefix ../bin/,$(addsuffix .js,$(EMCC_UTILS)))

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
