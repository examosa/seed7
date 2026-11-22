# Common Unix/Cygwin/MSYS GNU-make rules shared by makefile, mk_linux.mak, mk_clang.mak,
# mk_icc.mak, mk_osx.mak, mk_osxcl.mak, mk_tcc_l.mak, mk_cygw.mak, and mk_msys.mak.

.DEFAULT_GOAL := s7
.DELETE_ON_ERROR:
THIS_MAKEFILE := $(firstword $(MAKEFILE_LIST))
MAKEFILE_NAME ?= $(notdir $(THIS_MAKEFILE))

ifneq ($(and $(filter command environment,$(origin PREFIX)),$(PREFIX))$(and $(filter command environment,$(origin DESTDIR)),$(DESTDIR)),)
INSTALL_MODE ?= copy
else
INSTALL_MODE ?= symlink
endif

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
ifeq ($(INSTALL_MODE),copy)
MANDIR ?= $(PREFIX)/share/man/man1
else
MANDIR ?= /usr/share/man/man1
endif
DESTDIR ?=
INSTALL ?= install

AR ?= ar
ARFLAGS = r
RM ?= rm -f
STRIP ?= strip
SYSTEM_MATH_LIBS ?= -lm
EXE_EXT ?=
LIB_EXT ?= .a

include mk_lib.mak
include mk_src.mak

ALL_S7_LIBS = $(addprefix ../bin/,$(S7_LIBS))

S7_LDFLAGS ?= $(LDFLAGS)
S7_OUT ?= $@
PRG_S7_STYLE ?= symlink
CP_S7C ?= cp -p
SQL_PARTIAL_LINK ?= yes
SQL_CFLAGS ?= $(CFLAGS_NO_FLTO)
INSTALL_STYLE ?= unix
HAS_DEPEND ?= yes
RUN_WARN ?= yes
DEPEND_EXTRA_TOOLS ?=
CLEAN_EXTRA ?=
VERSION_EXTRA_ARGS ?= "LINK_TIME=$(LINK_TIME)"
TEST_INSTALL_HINT ?= sudo
STRIP_TARGETS ?= ../bin/s7$(EXE_EXT) ../bin/s7c$(EXE_EXT) $(ALL_S7_LIBS)

CC_OPT_LTO ?= -flto=auto
CC_OPT_PIC ?= -fPIC
LINKER_OPT_STATIC ?= -static
LINKER_OPT_NO_LTO ?= -fno-lto
LINKER_OPT_DYN_LINK_LIBS ?= -ldl
PARTIAL_LINK_OPTS ?= "-r", "-r -nostdlib"
X11_LIBRARY_PATH ?=
USE_GMP ?= 0
BIGINT_LIBS ?=
ALLOW_REPLACE_SYS_HDRS ?= yes

CC_OPT_TRAP_OVERFLOW ?=
CC_OPT_VERSION_INFO ?= --version
CC_FLAGS ?= -ffunction-sections -fdata-sections
BASE_ARCHIVER ?= yes
CHKCCOMP_FLAGS ?= $(CC_OPT_TRAP_OVERFLOW)

SETTINGS_DSO_HANDLE ?= no
LINKER_OPT_NO_DEBUG_INFO ?= -Wl,--strip-debug

DSRC ?= $(UNX_DSRC)
DRAW_LIB_SRC ?= $(X11_DRAW_SRC)
CONSOLE_LIB_SRC ?= $(UNX_CON_SRC)

include mk_obj_o.mak

UTILS_BIN = $(addprefix ../bin/,$(addsuffix $(EXE_EXT),$(UTILS)))

s7: next_lvl
	$(MAKE) -f $(THIS_MAKEFILE) ../bin/s7$(EXE_EXT) ../prg/s7$(EXE_EXT)
	../bin/s7$(EXE_EXT) -l ../lib level
	@echo
	@echo "  Use 'make s7c' (with your make command) to create the compiler."
	@echo

s7c: ../bin/s7c$(EXE_EXT) ../prg/s7c$(EXE_EXT)
	@echo
	@echo "  Use 'make test' (with your make command) to check Seed7."
	@echo

../bin/s7$(EXE_EXT): $(OBJ) $(ALL_S7_LIBS)
	$(CC) $(S7_LDFLAGS) $^ $(ALL_SYSTEM_LIBS) -o $(S7_OUT)

ifeq ($(PRG_S7_STYLE),copy)
../prg/s7$(EXE_EXT): ../bin/s7$(EXE_EXT)
	cp $< ../prg
else
../prg/s7$(EXE_EXT):
	ln -sf ../bin/s7$(EXE_EXT) ../prg
endif

../bin/s7c$(EXE_EXT): ../prg/s7c$(EXE_EXT)
	$(CP_S7C) $< $@

../prg/s7c$(EXE_EXT): ../prg/s7c.sd7 $(ALL_S7_LIBS)
	../bin/s7$(EXE_EXT) -l ../lib ../prg/s7c -l ../lib -b ../bin -O2 $<

levelup$(EXE_EXT): levelup.c
	$(CC) $< -o $@

next_lvl: levelup$(EXE_EXT)
	./levelup$(EXE_EXT)

sql_db2.o: SQL_INC = $(DB2_INCLUDE_OPTION)
sql_db2.o: SQL_LIBS = $(DB2_LIBS)
sql_db2.o: SQL_CC_OPT = $(DB2_CC_OPTION)

sql_ifx.o: SQL_INC = $(INFORMIX_INCLUDE_OPTION)
sql_ifx.o: SQL_LIBS = $(INFORMIX_LIBS)
sql_ifx.o: SQL_CC_OPT = $(INFORMIX_CC_OPTION)

sql_srv.o: SQL_INC = $(SQL_SERVER_INCLUDE_OPTION)
sql_srv.o: SQL_LIBS = $(SQL_SERVER_LIBS)
sql_srv.o: SQL_CC_OPT = $(SQL_SERVER_CC_OPTION)

ifeq ($(SQL_PARTIAL_LINK),yes)
sql_db2.o sql_ifx.o sql_srv.o: %.o: %.c sql_cli.c sql_log.c
	$(CC) $(CPPFLAGS) $(SQL_INC) $(SQL_CFLAGS) $< $(SQL_LIBS) $(SQL_CC_OPT) -o $@
	$(OBJCOPY) $(OBJCOPY_PARAMS) $@
else
sql_db2.o sql_ifx.o sql_srv.o: %.o: %.c
	$(CC) -c $(CPPFLAGS) $(SQL_INC) $(SQL_CFLAGS) $< -o $@
endif

all: depend
	$(MAKE) -f $(THIS_MAKEFILE) s7
	$(MAKE) -f $(THIS_MAKEFILE) s7c

.PHONY: clean s7 s7c test minimal_test check install all next_lvl strip clean_utils distclean uninstall utils wc lint lint2 cppcheck $(UTILS)

clean:
	$(RM) *.o $(ALL_S7_LIBS) ../bin/s7$(EXE_EXT) ../bin/s7c$(EXE_EXT) ../prg/s7$(EXE_EXT) ../prg/s7c$(EXE_EXT) depend macros chkccomp.h base.h settings.h version.h chkccomp$(EXE_EXT) wrdepend$(EXE_EXT) $(DEPEND_EXTRA_TOOLS) levelup$(EXE_EXT) next_lvl
ifneq ($(CLEAN_EXTRA),)
	$(RM) $(CLEAN_EXTRA)
endif
	@echo
	@echo "  Use 'make depend' (with your make command) to create the dependencies."
	@echo

clean_utils:
	$(RM) $(UTILS_BIN)

distclean: clean clean_utils
	$(RM) level_bk.h level.h $(VERS_FILE)

test:
	../bin/s7$(EXE_EXT) -l ../lib ../prg/chk_all build
ifeq ($(TEST_INSTALL_HINT),sudo)
	@echo
	@echo "  Use 'sudo make install' (with your make command) to install Seed7."
	@echo
else ifeq ($(TEST_INSTALL_HINT),plain)
	@echo
	@echo "  Use 'make install' (with your make command) to install Seed7."
	@echo
else ifeq ($(TEST_INSTALL_HINT),msys)
	@echo
	@echo "  Use './sudo make install' (with your make command) to install Seed7."
	@echo "  Or open a console as administrator, go to the directory seed7/src"
	@echo "  and use 'make install' (with your make command) to install Seed7."
	@echo
endif

minimal_test:
	../bin/s7$(EXE_EXT) -l ../lib ../prg/chk_all build minimal_test

check: test

ifeq ($(INSTALL_STYLE),setwpath)
install: setwpath.exe
	./setwpath.exe add ../bin

uninstall: setwpath.exe
	./setwpath.exe remove ../bin
else
ifeq ($(INSTALL_MODE),copy)
install:
	mkdir -p "$(DESTDIR)$(BINDIR)" "$(DESTDIR)$(MANDIR)"
	$(INSTALL) -m 755 ../bin/s7$(EXE_EXT) ../bin/s7c$(EXE_EXT) "$(DESTDIR)$(BINDIR)"
	for prog in $(INSTALL_UTILS); do \
		if [ -f "../bin/$$prog$(EXE_EXT)" ]; then $(INSTALL) -m 755 "../bin/$$prog$(EXE_EXT)" "$(DESTDIR)$(BINDIR)"; fi; \
	done
	gzip -c ../doc/s7.1 > "$(DESTDIR)$(MANDIR)/s7.1.gz"
	gzip -c ../doc/s7c.1 > "$(DESTDIR)$(MANDIR)/s7c.1.gz"
ifneq ($(S7_LIB_DIR),)
	mkdir -p "$(DESTDIR)$(S7_LIB_DIR)"
	$(INSTALL) -m 644 $(ALL_S7_LIBS) "$(DESTDIR)$(S7_LIB_DIR)"
endif
ifneq ($(SEED7_LIBRARY),)
	mkdir -p "$(DESTDIR)$(SEED7_LIBRARY)"
	$(INSTALL) -m 644 ../lib/*.s7i "$(DESTDIR)$(SEED7_LIBRARY)"
endif
else ifeq ($(INSTALL_STYLE),osx)
install:
	mkdir -p "$(DESTDIR)$(BINDIR)"
	cd ../bin && bin_dir="$$(pwd)" && for prog in s7 s7c $(INSTALL_UTILS); do \
		ln -fs "$$bin_dir/$$prog$(EXE_EXT)" "$(DESTDIR)$(BINDIR)"; \
	done
	gzip -c ../doc/s7.1 > ../doc/s7.1.gz
	-mv ../doc/s7.1.gz "$(DESTDIR)$(MANDIR)"
	gzip -c ../doc/s7c.1 > ../doc/s7c.1.gz
	-mv ../doc/s7c.1.gz "$(DESTDIR)$(MANDIR)"
else
install:
	mkdir -p "$(DESTDIR)$(BINDIR)" "$(DESTDIR)$(MANDIR)"
	cd ../bin && bin_dir="$$(pwd)" && for prog in s7 s7c $(INSTALL_UTILS); do \
		ln -fs "$$bin_dir/$$prog$(EXE_EXT)" "$(DESTDIR)$(BINDIR)"; \
	done
	gzip -c ../doc/s7.1 > "$(DESTDIR)$(MANDIR)/s7.1.gz"
	gzip -c ../doc/s7c.1 > "$(DESTDIR)$(MANDIR)/s7c.1.gz"
endif

uninstall:
	$(RM) $(addprefix $(DESTDIR)$(BINDIR)/,$(addsuffix $(EXE_EXT),s7 s7c $(INSTALL_UTILS))) \
	      $(DESTDIR)$(MANDIR)/s7.1.gz $(DESTDIR)$(MANDIR)/s7c.1.gz
ifneq ($(S7_LIB_DIR),)
	$(RM) $(addprefix $(DESTDIR)$(S7_LIB_DIR)/,$(S7_LIBS))
endif
ifneq ($(SEED7_LIBRARY),)
	$(RM) $(DESTDIR)$(SEED7_LIBRARY)/*.s7i
endif
endif

strip:
	$(STRIP) $(STRIP_TARGETS)

define _nl


endef

define chkccomp.h
#define LIST_DIRECTORY_CONTENTS "ls"$(if $(CC_OPT_LTO),$(_nl)#define CC_OPT_LINK_TIME_OPTIMIZATION "$(CC_OPT_LTO)")$(if $(CC_OPT_PIC),$(_nl)#define CC_OPT_POSITION_INDEPENDENT_CODE "$(CC_OPT_PIC)")$(if $(LINKER_OPT_STATIC),$(_nl)#define LINKER_OPT_STATIC_LINKING "$(LINKER_OPT_STATIC)")$(if $(LINKER_OPT_NO_LTO),$(_nl)#define LINKER_OPT_NO_LTO "$(LINKER_OPT_NO_LTO)")$(if $(LINKER_OPT_DYN_LINK_LIBS),$(_nl)#define LINKER_OPT_DYN_LINK_LIBS "$(LINKER_OPT_DYN_LINK_LIBS)")$(if $(PARTIAL_LINK_OPTS),$(_nl)#define POTENTIAL_PARTIAL_LINKING_OPTIONS $(PARTIAL_LINK_OPTS))$(if $(X11_LIBRARY_PATH),$(_nl)#define X11_LIBRARY_PATH "$(X11_LIBRARY_PATH)")
#define USE_GMP $(USE_GMP)$(if $(BIGINT_LIBS),$(_nl)#define BIGINT_LIBS "$(BIGINT_LIBS)")$(if $(filter yes,$(ALLOW_REPLACE_SYS_HDRS)),$(_nl)#define ALLOW_REPLACEMENT_OF_SYSTEM_HEADERS)
endef

define base.h
#define PATH_DELIMITER '/'
#define OBJECT_FILE_EXTENSION ".o"
#define C_COMPILER "$(CC)"$(if $(CC_OPT_TRAP_OVERFLOW),$(_nl)#define CC_OPT_TRAP_OVERFLOW "$(CC_OPT_TRAP_OVERFLOW)")
#define CC_OPT_VERSION_INFO "$(CC_OPT_VERSION_INFO)"
#define CC_FLAGS "$(CC_FLAGS)"
#define CC_ERROR_FILEDES 2
#define CC_VERSION_INFO_FILEDES 1
#define LINKER_OPT_OUTPUT_FILE "-o "$(if $(filter yes,$(BASE_ARCHIVER)),$(_nl)#define ARCHIVER "$(AR)"$(_nl)#define ARCHIVER_OPT_REPLACE "$(ARFLAGS) ")
#define SYSTEM_LIBS "$(SYSTEM_LIBS)"
#define SYSTEM_MATH_LIBS "$(SYSTEM_MATH_LIBS)"
endef

define settings.h
#define MAKE_UTILITY_NAME "$(MAKE)"
#define MAKEFILE_NAME "$(MAKEFILE_NAME)"
#define SEARCH_PATH_DELIMITER ':'
#define AWAIT_WITH_SELECT$(if $(filter yes,$(SETTINGS_DSO_HANDLE)),$(_nl)#define DEFINE_DSO_HANDLE)
#define SIGNAL_HANDLER_CAN_DO_IO
#define CONSOLE_UTF8
#define OS_STRI_UTF8
#define ESCAPE_SHELL_COMMANDS
#define LIBRARY_FILE_EXTENSION "$(LIB_EXT)"$(if $(CXX),$(_nl)#define CPLUSPLUS_COMPILER "$(CXX)")
#define CC_SOURCE_UTF8
#define CC_OPT_DEBUG_INFO "-g"
#define CC_OPT_NO_WARNINGS "-w"$(if $(LINKER_OPT_NO_DEBUG_INFO),$(_nl)#define LINKER_OPT_NO_DEBUG_INFO "$(LINKER_OPT_NO_DEBUG_INFO)")
#define LINKER_FLAGS "$(LDFLAGS)"
#define SEED7_LIB "$(SEED7_LIB)"
#define DRAW_LIB "$(DRAW_LIB)"
#define CONSOLE_LIB "$(CONSOLE_LIB)"
#define DATABASE_LIB "$(DATABASE_LIB)"
#define COMP_DATA_LIB "$(COMP_DATA_LIB)"
#define COMPILER_LIB "$(COMPILER_LIB)"
endef

chkccomp.h base.h settings.h: export _HDR = $($@)
chkccomp.h base.h settings.h:
	@printf '%s\n' "$$_HDR" > $@

version.h: chkccomp$(EXE_EXT) base.h settings.h
	./$< $@ "S7_LIB_DIR=$(S7_LIB_DIR)" "SEED7_LIBRARY=$(SEED7_LIBRARY)" $(VERSION_EXTRA_ARGS)
	cp $@ $(VERS_FILE)

chkccomp$(EXE_EXT): chkccomp.c chkccomp.h base.h settings.h
	$(CC) $(CHKCCOMP_FLAGS) $< -o $@

ifeq ($(HAS_DEPEND),yes)
wrdepend$(EXE_EXT): wrdepend.c version.h
	$(CC) $< -o $@

depend: version.h wrdepend$(EXE_EXT) $(DEPEND_EXTRA_TOOLS)
	./wrdepend$(EXE_EXT) OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SRC) "> depend"
	./wrdepend$(EXE_EXT) OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(SEED7_LIB_SRC) ">> depend"
	./wrdepend$(EXE_EXT) OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DRAW_LIB_SRC) ">> depend"
	./wrdepend$(EXE_EXT) OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(CONSOLE_LIB_SRC) ">> depend"
	./wrdepend$(EXE_EXT) OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(DATABASE_LIB_SRC_STD_INCL) ">> depend"
	./wrdepend$(EXE_EXT) OPTION=DB2_INCLUDE_OPTION $(CFLAGS) -M sql_db2.c ">> depend"
	./wrdepend$(EXE_EXT) OPTION=INFORMIX_INCLUDE_OPTION $(CFLAGS) -M sql_ifx.c ">> depend"
	./wrdepend$(EXE_EXT) OPTION=SQL_SERVER_INCLUDE_OPTION $(CFLAGS) -M sql_srv.c ">> depend"
	./wrdepend$(EXE_EXT) OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMP_DATA_LIB_SRC) ">> depend"
	./wrdepend$(EXE_EXT) OPTION=INCLUDE_OPTIONS $(CFLAGS) -M $(COMPILER_LIB_SRC) ">> depend"
ifeq ($(RUN_WARN),yes)
	$(CC) warn.c -o warn
	@./warn
	@$(RM) warn
endif
	@echo
	@echo "  Use 'make' (with your make command) to create the interpreter."
	@echo
else
depend: version.h
	@echo "Working without C header dependency checks."
	@echo
	@echo "  Use 'make' (with your make command) to create the interpreter."
	@echo
endif

../bin/$(SEED7_LIB): $(SEED7_LIB_OBJ)
../bin/$(DRAW_LIB): $(DRAW_LIB_OBJ)
../bin/$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
../bin/$(DATABASE_LIB): $(DATABASE_LIB_OBJ)
../bin/$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
../bin/$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
$(ALL_S7_LIBS):
	$(AR) $(ARFLAGS) $@ $^

../bin/%$(EXE_EXT): ../prg/%.sd7 ../bin/s7c$(EXE_EXT)
	../bin/s7c$(EXE_EXT) -l ../lib -b ../bin -O3 -oc3 $<
	mv $(<:.sd7=$(EXE_EXT)) $@

$(UTILS): %: ../bin/%$(EXE_EXT)

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

cppcheck: $(SRC) $(SEED7_LIB_SRC) $(DRAW_LIB_SRC) $(COMP_DATA_LIB_SRC) $(COMPILER_LIB_SRC)
	cppcheck --force --enable=all $^

ifeq ($(HAS_DEPEND),yes)
ifeq (depend,$(wildcard depend))
include depend
endif
endif

ifeq (macros,$(wildcard macros))
include macros
endif
