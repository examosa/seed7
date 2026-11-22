# Common Windows cmd.exe GNU-make / make7 rules shared by mk_mingw.mak,
# mk_mingc.mak, mk_clangw.mak, and mk_tcc_w.mak.

SYSTEM_CONSOLE_LIBS ?=
SYSTEM_DRAW_LIBS ?= -lgdi32
SYSTEM_MATH_LIBS ?= -lm
STRIP ?= strip
LIB_EXT ?= .a

include mk_lib.mak
include mk_src.mak

ALL_S7_LIBS = $(addprefix ..\bin\,$(S7_LIBS))

S7_OUT ?= ..\bin\s7.exe
VERBOSE_HINTS ?= yes
HAS_DEPEND ?= yes
HAS_CC_ENV_INI ?= no
INSTALL_USE_SUDO ?= no
TEST_HINT ?= both
DEPEND_STYLE ?= wrdepend_hints
AR_STYLE ?= ar_r
SQL_PARTIAL_LINK ?= no
SQL_CFLAGS ?= $(CFLAGS)
LEVELUP_FLAGS ?=
CHKCCOMP_FLAGS ?=
SETWPATH_FLAGS ?=
SETWPATH_LIBS ?=
WRDEPEND_FLAGS ?=
SUDO_FLAGS ?=

USE_GMP ?= 0
BIGINT_LIBS ?=
TEST_C_COMPILER ?=
LINKER_OPT_STATIC ?=
CHKCCOMP_CC_FLAGS ?=
CC_FLAGS64 ?=
CC_OPT_LTO ?=
CC_OPT_PIC ?=
LINKER_OPT_NO_LTO ?=
PARTIAL_LINK_OPTS ?=
INT_DIV_OVERFLOW_LOOP ?= no
POSTGRESQL_USE_DLL ?= yes

C_COMPILER_SCRIPT ?=
CC_OPT_TRAP_OVERFLOW ?=
CC_OPT_VERSION_INFO ?= --version
HAS_BASE_CC_FLAGS ?= no
BASE_CC_FLAGS ?=
DEFAULT_STACK_SIZE ?= 8388608
BASE_ARCHIVER ?=
FORMAT_LL_WARN ?= no
INT_DIV_POPUP ?= no
DO_SIGFPE_DIV_ZERO ?= no
CLANG_MSVC_CRT ?= no

DEF_CMDLINE_ARGV_W ?= no
RENAMED_POSIX ?= no
OS_GETCH ?= _getwch
GETCH_READS_BYTES ?= no
LINKER_OPT_DEBUG_INFO ?=
LINKER_OPT_NO_DEBUG_INFO ?= -Wl,--strip-debug
LINKER_OPT_STACK_SIZE ?= -Wl,--stack,
SETTINGS_LINKER_FLAGS ?= -Wl,--gc-sections

ifeq ($(AR_STYLE),ar_r)
ARFLAGS = r
AR_OUT_PREFIX =
endif
ifeq ($(AR_STYLE),lib_out)
ARFLAGS =
AR_OUT_PREFIX = /out:
endif
ifeq ($(AR_STYLE),ar_direct)
ARFLAGS =
AR_OUT_PREFIX =
endif

IF_TEST_CC = rem
ifneq ($(TEST_C_COMPILER),)
IF_TEST_CC =
endif
IF_STATIC_LNK = rem
ifneq ($(LINKER_OPT_STATIC),)
IF_STATIC_LNK =
endif
IF_CHK_CC_FLAGS = rem
ifneq ($(CHKCCOMP_CC_FLAGS),)
IF_CHK_CC_FLAGS =
endif
IF_CC_FLAGS64 = rem
ifneq ($(CC_FLAGS64),)
IF_CC_FLAGS64 =
endif
IF_CC_LTO = rem
ifneq ($(CC_OPT_LTO),)
IF_CC_LTO =
endif
IF_CC_PIC = rem
ifneq ($(CC_OPT_PIC),)
IF_CC_PIC =
endif
IF_NO_LTO = rem
ifneq ($(LINKER_OPT_NO_LTO),)
IF_NO_LTO =
endif
IF_PARTIAL_LNK = rem
ifneq ($(PARTIAL_LINK_OPTS),)
IF_PARTIAL_LNK =
endif
IF_BIGINT_LIBS = rem
ifneq ($(BIGINT_LIBS),)
IF_BIGINT_LIBS =
endif
IF_INT_DIV_LOOP = rem
ifeq ($(INT_DIV_OVERFLOW_LOOP),yes)
IF_INT_DIV_LOOP =
endif
IF_PG_DLL = rem
ifeq ($(POSTGRESQL_USE_DLL),yes)
IF_PG_DLL =
endif

IF_CC_SCRIPT = rem
IF_C_COMPILER =
ifneq ($(C_COMPILER_SCRIPT),)
IF_CC_SCRIPT =
IF_C_COMPILER = rem
endif
IF_TRAP_OVF = rem
ifneq ($(CC_OPT_TRAP_OVERFLOW),)
IF_TRAP_OVF =
endif
IF_BASE_CC_FLAGS = rem
ifeq ($(HAS_BASE_CC_FLAGS),yes)
IF_BASE_CC_FLAGS =
endif
IF_ARCHIVER = rem
IF_AR_OPT_R = rem
IF_AR_OPT_PREFIX = rem
ifneq ($(BASE_ARCHIVER),)
IF_ARCHIVER =
ifeq ($(AR_STYLE),lib_out)
IF_AR_OPT_PREFIX =
else
IF_AR_OPT_R =
endif
endif
IF_FORMAT_LL = rem
ifeq ($(FORMAT_LL_WARN),yes)
IF_FORMAT_LL =
endif
IF_INT_DIV_POPUP = rem
ifeq ($(INT_DIV_POPUP),yes)
IF_INT_DIV_POPUP =
endif
IF_SIGFPE_ZERO = rem
ifeq ($(DO_SIGFPE_DIV_ZERO),yes)
IF_SIGFPE_ZERO =
endif
IF_MSVC_CRT = rem
ifeq ($(CLANG_MSVC_CRT),yes)
IF_MSVC_CRT =
endif

IF_CMDLINE_ARGV = rem
ifeq ($(DEF_CMDLINE_ARGV_W),yes)
IF_CMDLINE_ARGV =
endif
IF_RENAMED_POSIX = rem
ifeq ($(RENAMED_POSIX),yes)
IF_RENAMED_POSIX =
endif
IF_GETCH_BYTES = rem
ifeq ($(GETCH_READS_BYTES),yes)
IF_GETCH_BYTES =
endif
IF_LNK_DBG = rem
ifneq ($(LINKER_OPT_DEBUG_INFO),)
IF_LNK_DBG =
endif
IF_LNK_NO_DBG = rem
ifneq ($(LINKER_OPT_NO_DEBUG_INFO),)
IF_LNK_NO_DBG =
endif

S7_HINT_1 =
S7_HINT_2 =
S7_HINT_3 =
S7C_HINT_1 =
S7C_HINT_2 =
S7C_HINT_3 =
CLEAN_HINT_1 =
CLEAN_HINT_2 =
CLEAN_HINT_3 =
ifeq ($(VERBOSE_HINTS),yes)
S7_HINT_1 = echo.
S7_HINT_2 = echo Use 'make s7c' (with your make command) to create the compiler.
S7_HINT_3 = echo.
S7C_HINT_1 = echo.
S7C_HINT_2 = echo Use 'make test' (with your make command) to check Seed7.
S7C_HINT_3 = echo.
CLEAN_HINT_1 = echo.
CLEAN_HINT_2 = echo Use 'make depend' (with your make command) to create the dependencies.
CLEAN_HINT_3 = echo.
endif

DEPEND_HINT_1 =
DEPEND_HINT_2 =
DEPEND_HINT_3 =
ifeq ($(DEPEND_STYLE),wrdepend_hints)
DEPEND_HINT_1 = echo.
DEPEND_HINT_2 = echo Use 'make' (with your make command) to create the interpreter.
DEPEND_HINT_3 = echo.
endif

CLEAN_FILES = *.o $(ALL_S7_LIBS) ..\bin\s7.exe ..\bin\s7c.exe ..\prg\s7.exe ..\prg\s7c.exe \
              depend macros chkccomp.h base.h settings.h version.h chkccomp.exe setwpath.exe \
              levelup.exe next_lvl
ifeq ($(HAS_DEPEND),yes)
CLEAN_FILES += wrdepend.exe sudo.exe
endif
ifeq ($(HAS_CC_ENV_INI),yes)
CLEAN_FILES += ..\bin\$(CC_ENVIRONMENT_INI)
endif

DSRC = $(WIN_DSRC)
DRAW_LIB_SRC = $(WIN_DRAW_SRC)
CONSOLE_LIB_SRC = $(WIN_CON_SRC)

include mk_obj_o.mak

UTILS_BIN = $(addprefix ../bin/,$(addsuffix .exe,$(UTILS)))
UTILS_BIN_WIN = $(addprefix ..\bin\,$(addsuffix .exe,$(UTILS)))

s7: next_lvl
	$(MAKE) -f $(MAKEFILE_NAME) ..\bin\s7.exe ..\prg\s7.exe
	..\bin\s7 -l ..\lib level
	@$(S7_HINT_1)
	@$(S7_HINT_2)
	@$(S7_HINT_3)

s7c: ..\bin\s7c.exe ..\prg\s7c.exe
	@$(S7C_HINT_1)
	@$(S7C_HINT_2)
	@$(S7C_HINT_3)

..\bin\s7.exe: $(OBJ) $(ALL_S7_LIBS)
	$(CC) $(LDFLAGS) $^ $(ALL_SYSTEM_LIBS) -o $(S7_OUT)

..\prg\s7.exe: ..\bin\s7.exe
	copy $< ..\prg /Y

..\bin\s7c.exe: ..\prg\s7c.exe
	copy $< ..\bin /Y

..\prg\s7c.exe: ..\prg\s7c.sd7 $(ALL_S7_LIBS)
	..\bin\s7 -l ..\lib ..\prg\s7c -l ..\lib -b ..\bin -O2 ..\prg\s7c

levelup.exe: levelup.c
	$(CC) $(LEVELUP_FLAGS) $< -o $@

next_lvl: levelup.exe
	.\levelup.exe

ifeq ($(SQL_PARTIAL_LINK),yes)
sql_db2.o: sql_db2.c sql_cli.c sql_log.c
	$(CC) $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(SQL_CFLAGS) $< $(DB2_LIBS) $(DB2_CC_OPTION) -o $@
	$(OBJCOPY) $(OBJCOPY_PARAMS) $@

sql_ifx.o: sql_ifx.c sql_cli.c sql_log.c
	$(CC) $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(SQL_CFLAGS) $< $(INFORMIX_LIBS) $(INFORMIX_CC_OPTION) -o $@
	$(OBJCOPY) $(OBJCOPY_PARAMS) $@

sql_srv.o: sql_srv.c sql_cli.c sql_log.c
	$(CC) $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(SQL_CFLAGS) $< $(SQL_SERVER_LIBS) $(SQL_SERVER_CC_OPTION) -o $@
	$(OBJCOPY) $(OBJCOPY_PARAMS) $@
else
sql_db2.o: sql_db2.c
	$(CC) -c $(CPPFLAGS) $(DB2_INCLUDE_OPTION) $(SQL_CFLAGS) $< -o $@

sql_ifx.o: sql_ifx.c
	$(CC) -c $(CPPFLAGS) $(INFORMIX_INCLUDE_OPTION) $(SQL_CFLAGS) $< -o $@

sql_srv.o: sql_srv.c
	$(CC) -c $(CPPFLAGS) $(SQL_SERVER_INCLUDE_OPTION) $(SQL_CFLAGS) $< -o $@
endif

all: depend
	$(MAKE) -f $(MAKEFILE_NAME) s7
	$(MAKE) -f $(MAKEFILE_NAME) s7c

.PHONY: clean s7 s7c test minimal_test check install all next_lvl strip clean_utils distclean uninstall utils wc lint lint2

clean:
	del $(CLEAN_FILES)
	@$(CLEAN_HINT_1)
	@$(CLEAN_HINT_2)
	@$(CLEAN_HINT_3)

clean_utils:
	del $(UTILS_BIN_WIN)

distclean: clean clean_utils
	del level_bk.h level.h $(VERS_FILE)

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
	$(STRIP) ..\bin\s7.exe

chkccomp.h:
	echo #define LIST_DIRECTORY_CONTENTS "dir" > chkccomp.h
	@$(IF_TEST_CC) echo #define TEST_C_COMPILER "$(TEST_C_COMPILER)" >> chkccomp.h
	@$(IF_STATIC_LNK) echo #define LINKER_OPT_STATIC_LINKING "$(LINKER_OPT_STATIC)" >> chkccomp.h
	@$(IF_CHK_CC_FLAGS) echo #define CC_FLAGS "$(CHKCCOMP_CC_FLAGS)" >> chkccomp.h
	@$(IF_CC_FLAGS64) echo #define CC_FLAGS64 "$(CC_FLAGS64)" >> chkccomp.h
	@$(IF_CC_LTO) echo #define CC_OPT_LINK_TIME_OPTIMIZATION "$(CC_OPT_LTO)" >> chkccomp.h
	@$(IF_CC_PIC) echo #define CC_OPT_POSITION_INDEPENDENT_CODE "$(CC_OPT_PIC)" >> chkccomp.h
	@$(IF_NO_LTO) echo #define LINKER_OPT_NO_LTO "$(LINKER_OPT_NO_LTO)" >> chkccomp.h
	@$(IF_PARTIAL_LNK) echo #define POTENTIAL_PARTIAL_LINKING_OPTIONS $(PARTIAL_LINK_OPTS) >> chkccomp.h
	echo #define USE_GMP $(USE_GMP) >> chkccomp.h
	@$(IF_BIGINT_LIBS) echo #define BIGINT_LIBS "$(BIGINT_LIBS)" >> chkccomp.h
	echo #define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)" >> chkccomp.h
	echo #define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)" >> chkccomp.h
	@$(IF_INT_DIV_LOOP) echo #define INT_DIV_OVERFLOW_INFINITE_LOOP 1 >> chkccomp.h
	@$(IF_PG_DLL) echo #define POSTGRESQL_USE_DLL >> chkccomp.h

base.h:
	echo #define PATH_DELIMITER '\\' > base.h
	echo #define OS_STRI_WCHAR >> base.h
	echo #define QUOTE_WHOLE_SHELL_COMMAND >> base.h
	echo #define OBJECT_FILE_EXTENSION ".o" >> base.h
	echo #define EXECUTABLE_FILE_EXTENSION ".exe" >> base.h
	@$(IF_CC_SCRIPT) echo #define C_COMPILER_SCRIPT "$(C_COMPILER_SCRIPT)" >> base.h
	@$(IF_C_COMPILER) echo #define C_COMPILER "$(CC)" >> base.h
	@$(IF_TRAP_OVF) echo #define CC_OPT_TRAP_OVERFLOW "$(CC_OPT_TRAP_OVERFLOW)" >> base.h
	echo #define CC_OPT_VERSION_INFO "$(CC_OPT_VERSION_INFO)" >> base.h
	@$(IF_BASE_CC_FLAGS) echo #define CC_FLAGS "$(BASE_CC_FLAGS)" >> base.h
	echo #define CC_ERROR_FILEDES 2 >> base.h
	echo #define CC_VERSION_INFO_FILEDES 1 >> base.h
	echo #define LINKER_OPT_OUTPUT_FILE "-o " >> base.h
	echo #define DEFAULT_STACK_SIZE $(DEFAULT_STACK_SIZE) >> base.h
	@$(IF_ARCHIVER) echo #define ARCHIVER "$(BASE_ARCHIVER)" >> base.h
	@$(IF_AR_OPT_R) echo #define ARCHIVER_OPT_REPLACE "$(ARFLAGS) " >> base.h
	@$(IF_AR_OPT_PREFIX) echo #define ARCHIVER_OPT_REPLACE "$(AR_OUT_PREFIX)" >> base.h
	@$(IF_FORMAT_LL) echo #define FORMAT_LL_TRIGGERS_WARNINGS 1 >> base.h
	@$(IF_INT_DIV_POPUP) echo #define INT_DIV_BY_ZERO_POPUP >> base.h
	@$(IF_SIGFPE_ZERO) echo #define DO_SIGFPE_WITH_DIV_BY_ZERO 1 >> base.h
	@$(IF_MSVC_CRT) echo #define FILENO_WORKS_FOR_NULL 0 >> base.h
	@$(IF_MSVC_CRT) echo #define _CRT_SECURE_NO_WARNINGS >> base.h
	@$(IF_MSVC_CRT) echo #define _CRT_NONSTDC_NO_DEPRECATE >> base.h
	echo #define SYSTEM_LIBS "$(SYSTEM_LIBS)" >> base.h
	echo #define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)" >> base.h

settings.h:
	echo #define MAKE_UTILITY_NAME "$(MAKE)" > settings.h
	echo #define MAKEFILE_NAME "$(MAKEFILE_NAME)" >> settings.h
	echo #define SEARCH_PATH_DELIMITER ';' >> settings.h
	@$(IF_CMDLINE_ARGV) echo #define DEFINE_COMMAND_LINE_TO_ARGV_W >> settings.h
	echo #define CONSOLE_WCHAR >> settings.h
	@$(IF_RENAMED_POSIX) echo #define RENAMED_POSIX_FUNCTIONS >> settings.h
	echo #define os_getch $(OS_GETCH) >> settings.h
	@$(IF_GETCH_BYTES) echo #define OS_GETCH_READS_BYTES >> settings.h
	echo #define LIBRARY_FILE_EXTENSION "$(LIB_EXT)" >> settings.h
	echo #define CC_OPT_DEBUG_INFO "-g" >> settings.h
	echo #define CC_OPT_NO_WARNINGS "-w" >> settings.h
	@$(IF_LNK_DBG) echo #define LINKER_OPT_DEBUG_INFO "$(LINKER_OPT_DEBUG_INFO)" >> settings.h
	@$(IF_LNK_NO_DBG) echo #define LINKER_OPT_NO_DEBUG_INFO "$(LINKER_OPT_NO_DEBUG_INFO)" >> settings.h
	echo #define LINKER_OPT_STACK_SIZE "$(LINKER_OPT_STACK_SIZE)" >> settings.h
	echo #define LINKER_FLAGS "$(SETTINGS_LINKER_FLAGS)" >> settings.h
	echo #define SEED7_LIB "$(SEED7_LIB)" >> settings.h
	echo #define DRAW_LIB "$(DRAW_LIB)" >> settings.h
	echo #define CONSOLE_LIB "$(CONSOLE_LIB)" >> settings.h
	echo #define DATABASE_LIB "$(DATABASE_LIB)" >> settings.h
	echo #define COMP_DATA_LIB "$(COMP_DATA_LIB)" >> settings.h
	echo #define COMPILER_LIB "$(COMPILER_LIB)" >> settings.h

chkccomp.exe: chkccomp.c chkccomp.h base.h settings.h
	$(CC) $(CHKCCOMP_FLAGS) $< -o $@

setwpath.exe: setwpath.c version.h
	$(CC) $(SETWPATH_FLAGS) $< $(SETWPATH_LIBS) -o $@

ifeq ($(HAS_DEPEND),yes)
wrdepend.exe: wrdepend.c version.h
	$(CC) $(WRDEPEND_FLAGS) $< -o $@

sudo.exe: sudo.c
	$(CC) $(SUDO_FLAGS) $< -w -o $@
endif

ifeq ($(HAS_CC_ENV_INI),yes)
version.h: chkccomp.exe base.h settings.h
	.\chkccomp.exe $@ "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)" "CC_ENVIRONMENT_INI=$(CC_ENVIRONMENT_INI)"
	set > ..\bin\$(CC_ENVIRONMENT_INI)
	copy $@ $(VERS_FILE) /Y
else
version.h: chkccomp.exe base.h settings.h
	.\chkccomp.exe $@ "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)"
	copy $@ $(VERS_FILE) /Y
endif

ifeq ($(DEPEND_STYLE),none)
depend: version.h setwpath.exe
	@echo Working without C header dependency checks.
	@echo.
	@echo Use 'make' (with your make command) to create the interpreter.
	@echo.
else
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
	@$(DEPEND_HINT_1)
	@$(DEPEND_HINT_2)
	@$(DEPEND_HINT_3)
endif

..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	$(AR) $(ARFLAGS) $(AR_OUT_PREFIX)$@ $^

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	$(AR) $(ARFLAGS) $(AR_OUT_PREFIX)$@ $^

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	$(AR) $(ARFLAGS) $(AR_OUT_PREFIX)$@ $^

..\bin\$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
	$(AR) $(ARFLAGS) $(AR_OUT_PREFIX)$@ $^

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	$(AR) $(ARFLAGS) $(AR_OUT_PREFIX)$@ $^

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	$(AR) $(ARFLAGS) $(AR_OUT_PREFIX)$@ $^

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
