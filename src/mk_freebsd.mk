# Makefile for the FreeBSD ports system using whatever compiler the user has set. Commands executed by: sh
# To compile use a command shell and call:
#   make -f mk_freebsd.mak depend
#   make -f mk_freebsd.mak
# If you are under windows you should use MinGW with mk_mingw.mak, mk_nmake.mak or mk_msys.mak instead.

# CFLAGS =
# CFLAGS = -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar -Wc++-compat
# CFLAGS = -O2 -g -x c++ -Wall -Wextra -Wswitch-default -Wswitch-enum -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wextra -Wswitch-default -Wcast-qual -Waggregate-return -Wwrite-strings -Winline -Wconversion -Wshadow -Wpointer-arith -Wmissing-noreturn -Wno-multichar
CFLAGS = -ffunction-sections -fdata-sections $(INCLUDE_OPTIONS) -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv -I%%LOCALBASE%%/include
# CFLAGS = -O2 -g -x c++ -Wall -Winline -Wconversion -Wshadow -Wpointer-arith -ftrapv
# CFLAGS = -O2 -g -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -g -Wall
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -Wl,--gc-sections -L%%LOCALBASE%%/lib
# LDFLAGS = -pg
# LDFLAGS = -pg -lc_p
SYSTEM_LIBS =
# SYSTEM_LIBS = -lm -lgmp
# SYSTEM_LIBS = -lm_p -lc_p
# SYSTEM_BIGINT_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_CONSOLE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DATABASE_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
# SYSTEM_DRAW_LIBS is defined in the file "macros". The program chkccomp.c writes it to "macros" when doing "make depend".
SYSTEM_MATH_LIBS = -lm
ARFLAGS = r
LIB_EXT = .a
USE_GMP ?= 0

.include "mk_lib.mak"
.include "mk_src.mak"

ALL_S7_LIBS = $(S7_LIBS:S,^,../bin/,)
DSRC = $(UNX_DSRC)
DRAW_LIB_SRC = $(X11_DRAW_SRC)
CONSOLE_LIB_SRC = $(UNX_CON_SRC)

.include "mk_obj_o.mak"

UTILS_BIN = $(UTILS:S,^,../bin/,)

s7: ../bin/s7 ../prg/s7
	../bin/s7 -l ../lib level

s7c: ../bin/s7c ../prg/s7c

../bin/s7: levelup next_lvl .WAIT $(OBJ) $(ALL_S7_LIBS)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(ALL_SYSTEM_LIBS) -o ../bin/s7
	rm next_lvl

../prg/s7:
	ln -sf ../bin/s7 ../prg

../bin/s7c: ../prg/s7c
	cp -p ../prg/s7c ../bin

../prg/s7c: ../prg/s7c.sd7 $(ALL_S7_LIBS)
	../bin/s7 -l ../lib ../prg/s7c -l ../lib -b ../bin -O2 ../prg/s7c

levelup: levelup.c
	$(CC) levelup.c -o levelup

next_lvl: levelup
	./levelup
	echo "X" > next_lvl

sql_db2.o: sql_db2.c
	$(CC) $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(CFLAGS) -c -o $@ $<

sql_ifx.o: sql_ifx.c
	$(CC) $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(CFLAGS) -c -o $@ $<

sql_srv.o: sql_srv.c
	$(CC) $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(CFLAGS) -c -o $@ $<

all: depend
	$(MAKE) -f mk_freebsd.mk s7 s7c

.PHONY: clean s7 s7c test minimal_test check install all next_lvl strip clean_utils distclean uninstall utils wc lint lint2 $(UTILS)

clean:
	rm -f *.o $(ALL_S7_LIBS) ../bin/s7 ../bin/s7c ../prg/s7 ../prg/s7c depend macros chkccomp.h base.h settings.h version.h chkccomp wrdepend levelup next_lvl

clean_utils:
	rm -f $(UTILS_BIN)

distclean: clean clean_utils
	rm -f level_bk.h level.h vers_freebsd.h

test:
	../bin/s7 -l ../lib ../prg/chk_all build

minimal_test:
	../bin/s7 -l ../lib ../prg/chk_all build minimal_test

check: test

strip:
	strip ../bin/s7 ../bin/s7c $(ALL_S7_LIBS)

chkccomp.h:
	echo "#include \"sys/stat.h\"" > chkccomp.h
	echo "#include \"sys/types.h\"" >> chkccomp.h
	echo "#define LIST_DIRECTORY_CONTENTS \"ls\"" >> chkccomp.h
	echo "#define CC_OPT_POSITION_INDEPENDENT_CODE \"-fPIC\"" >> chkccomp.h
	echo "#define LINKER_OPT_DYN_LINK_LIBS \"-ldl\"" >> chkccomp.h
	echo "#define USE_GMP $(USE_GMP)" >> chkccomp.h
	echo "#define MYSQL_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include/mysql\"" >> chkccomp.h
	echo "#define MYSQL_LIBRARY_PATH \"-L%%LOCALBASE%%/lib/mysql\"" >> chkccomp.h
	echo "#define SQLITE_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define SQLITE_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define POSTGRESQL_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include/postgresql\"" >> chkccomp.h
	echo "#define POSTGRESQL_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define ODBC_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define ODBC_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define OCI_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define OCI_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define FIRE_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define FIRE_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define DB2_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define DB2_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define INFORMIX_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define INFORMIX_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define SQL_SERVER_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define SQL_SERVER_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h
	echo "#define TDS_INCLUDE_OPTIONS \"-I%%LOCALBASE%%/include\"" >> chkccomp.h
	echo "#define TDS_LIBRARY_PATH \"-L%%LOCALBASE%%/lib\"" >> chkccomp.h

base.h:
	echo "#define PATH_DELIMITER '/'" > base.h
	echo "#define OBJECT_FILE_EXTENSION \".o\"" >> base.h
	echo "#define C_COMPILER \"$(CC)\"" >> base.h
	echo "#define CC_OPT_TRAP_OVERFLOW \"-ftrapv\"" >> base.h
	echo "#define CC_OPT_VERSION_INFO \"--version\"" >> base.h
	echo "#define CC_FLAGS \"-ffunction-sections -fdata-sections\"" >> base.h
	echo "#define CC_ERROR_FILEDES 2" >> base.h
	echo "#define CC_VERSION_INFO_FILEDES 1" >> base.h
	echo "#define LINKER_OPT_OUTPUT_FILE \"-o \"" >> base.h
	echo "#define SYSTEM_LIBS \"$(SYSTEM_LIBS)\"" >> base.h
	echo "#define SYSTEM_MATH_LIBS \"$(SYSTEM_MATH_LIBS)\"" >> base.h

settings.h:
	echo "#define MAKE_UTILITY_NAME \"$(MAKE)\"" > settings.h
	echo "#define MAKEFILE_NAME \"mk_freebsd.mk\"" >> settings.h
	echo "#define SEARCH_PATH_DELIMITER ':'" >> settings.h
	echo "#define AWAIT_WITH_SELECT" >> settings.h
	echo "#define SIGNAL_HANDLER_CAN_DO_IO" >> settings.h
	echo "#define CONSOLE_UTF8" >> settings.h
	echo "#define OS_STRI_UTF8" >> settings.h
	echo "#define ESCAPE_SHELL_COMMANDS" >> settings.h
	echo "#define LIBRARY_FILE_EXTENSION \".a\"" >> settings.h
	echo "#define CPLUSPLUS_COMPILER \"$(CC) -x c++\"" >> settings.h
	echo "#define CC_SOURCE_UTF8" >> settings.h
	echo "#define CC_OPT_DEBUG_INFO \"-g\"" >> settings.h
	echo "#define CC_OPT_NO_WARNINGS \"-w\"" >> settings.h
	echo "#define LINKER_OPT_NO_DEBUG_INFO \"-Wl,--strip-debug\"" >> settings.h
	echo "#define LINKER_FLAGS \"$(LDFLAGS)\"" >> settings.h
	echo "#define SEED7_LIB \"$(SEED7_LIB)\"" >> settings.h
	echo "#define DRAW_LIB \"$(DRAW_LIB)\"" >> settings.h
	echo "#define CONSOLE_LIB \"$(CONSOLE_LIB)\"" >> settings.h
	echo "#define DATABASE_LIB \"$(DATABASE_LIB)\"" >> settings.h
	echo "#define COMP_DATA_LIB \"$(COMP_DATA_LIB)\"" >> settings.h
	echo "#define COMPILER_LIB \"$(COMPILER_LIB)\"" >> settings.h

version.h: chkccomp base.h settings.h
	./chkccomp version.h "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)" "LINK_TIME=$(LINK_TIME)"
	cp version.h vers_freebsd.h

chkccomp: chkccomp.c chkccomp.h base.h settings.h
	$(CC) -ftrapv chkccomp.c -o chkccomp

wrdepend: version.h wrdepend.c
	$(CC) wrdepend.c -o wrdepend

depend: version.h wrdepend
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SRC) "> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SEED7_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DRAW_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(CONSOLE_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DATABASE_LIB_SRC_STD_INCL) ">> depend"
	./wrdepend OPTION=DB2_INCLUDE_OPTION $(CFLAGS) -M sql_db2.c ">> depend"
	./wrdepend OPTION=INFORMIX_INCLUDE_OPTION $(CFLAGS) -M sql_ifx.c ">> depend"
	./wrdepend OPTION=SQL_SERVER_INCLUDE_OPTION $(CFLAGS) -M sql_srv.c ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMP_DATA_LIB_SRC) ">> depend"
	./wrdepend OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMPILER_LIB_SRC) ">> depend"

../bin/$(SEED7_LIB): $(SEED7_LIB_OBJ)
../bin/$(DRAW_LIB): $(DRAW_LIB_OBJ)
../bin/$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
../bin/$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
../bin/$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
../bin/$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
$(ALL_S7_LIBS):
	$(AR) $(ARFLAGS) $@ $>

.for u in $(UTILS)
../bin/$(u): ../prg/$(u).sd7 ../bin/s7c
	../bin/s7c -l ../lib -b ../bin -O3 -oc3 ../prg/$(u).sd7
	mv ../prg/$(u) ../bin

$(u): ../bin/$(u)
.endfor

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

.if exists(depend)
.include "depend"
.endif

.if exists(macros)
.include "macros"
.endif
