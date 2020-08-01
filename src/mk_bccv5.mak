# Makefile for bcc32 version 5.5 and Borland make under windows. Commands executed by: cmd.exe
# To compile use a windows console and call:
#   make -f mk_bccv5.mak depend
#   make -f mk_bccv5.mak
# If you use MinGW you should use mk_mingw.mak, mk_nmake.mak or mk_msys.mak instead.
# If you use msvc you should use mk_msvc.mak instead.

# CFLAGS =
# CFLAGS = -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2
CFLAGS = -O2 -y -v
# CFLAGS = -O2 -v -w-
# CFLAGS = -O2 -g -pg -Wall -Wstrict-prototypes -Winline -Wconversion -Wshadow -Wpointer-arith
# CFLAGS = -O2 -fomit-frame-pointer -funroll-loops -Wall
# CFLAGS = -O2 -funroll-loops -Wall -pg
LDFLAGS = -lS:0x400000
# LDFLAGS = -pg
SYSTEM_LIBS = user32.lib ws2_32.lib
# SYSTEM_LIBS = user32.lib ws2_32.lib gmp.lib
SYSTEM_CONSOLE_LIBS =
SYSTEM_DRAW_LIBS = gdi32.lib
SEED7_LIB = seed7_05.lib
CONSOLE_LIB = s7_con.lib
DRAW_LIB = s7_draw.lib
COMP_DATA_LIB = s7_data.lib
COMPILER_LIB = s7_comp.lib
ALL_S7_LIBS = ..\bin\$(COMPILER_LIB) ..\bin\$(COMP_DATA_LIB) ..\bin\$(DRAW_LIB) ..\bin\$(CONSOLE_LIB) ..\bin\$(SEED7_LIB)
CC = bcc32
GET_CC_VERSION_INFO = bcc32.exe >

BIGINT_LIB_DEFINE = USE_BIG_RTL_LIBRARY
BIGINT_LIB = big_rtl
# BIGINT_LIB_DEFINE = USE_BIG_GMP_LIBRARY
# BIGINT_LIB = big_gmp

MOBJ1 = hi.obj
POBJ1 = runerr.obj option.obj primitiv.obj
LOBJ1 = actlib.obj arrlib.obj biglib.obj blnlib.obj bstlib.obj chrlib.obj cmdlib.obj conlib.obj dcllib.obj drwlib.obj
LOBJ2 = enulib.obj fillib.obj fltlib.obj hshlib.obj intlib.obj itflib.obj kbdlib.obj lstlib.obj prclib.obj prglib.obj
LOBJ3 = reflib.obj rfllib.obj sctlib.obj setlib.obj soclib.obj strlib.obj timlib.obj typlib.obj ut8lib.obj
EOBJ1 = exec.obj doany.obj objutl.obj
AOBJ1 = act_comp.obj prg_comp.obj analyze.obj syntax.obj token.obj parser.obj name.obj type.obj
AOBJ2 = expr.obj atom.obj object.obj scanner.obj literal.obj numlit.obj findid.obj
AOBJ3 = error.obj infile.obj symbol.obj info.obj stat.obj fatal.obj match.obj
GOBJ1 = syvarutl.obj traceutl.obj actutl.obj executl.obj blockutl.obj
GOBJ2 = entutl.obj identutl.obj chclsutl.obj sigutl.obj
ROBJ1 = arr_rtl.obj bln_rtl.obj bst_rtl.obj chr_rtl.obj cmd_rtl.obj con_rtl.obj dir_rtl.obj drw_rtl.obj fil_rtl.obj
ROBJ2 = flt_rtl.obj hsh_rtl.obj int_rtl.obj set_rtl.obj soc_rtl.obj str_rtl.obj tim_rtl.obj ut8_rtl.obj
ROBJ3 = heaputl.obj striutl.obj
DOBJ1 = $(BIGINT_LIB).obj cmd_win.obj fil_win.obj tim_win.obj
OBJ = $(MOBJ1)
SEED7_LIB_OBJ = $(ROBJ1) $(ROBJ2) $(ROBJ3) $(DOBJ1)
DRAW_LIB_OBJ = gkb_rtl.obj drw_win.obj
CONSOLE_LIB_OBJ = kbd_rtl.obj con_win.obj
COMP_DATA_LIB_OBJ = typ_data.obj rfl_data.obj ref_data.obj listutl.obj flistutl.obj typeutl.obj datautl.obj
COMPILER_LIB_OBJ = $(POBJ1) $(LOBJ1) $(LOBJ2) $(LOBJ3) $(EOBJ1) $(AOBJ1) $(AOBJ2) $(AOBJ3) $(GOBJ1) $(GOBJ2)

MSRC1 = hi.c
PSRC1 = runerr.c option.c primitiv.c
LSRC1 = actlib.c arrlib.c biglib.c blnlib.c bstlib.c chrlib.c cmdlib.c conlib.c dcllib.c drwlib.c
LSRC2 = enulib.c fillib.c fltlib.c hshlib.c intlib.c itflib.c kbdlib.c lstlib.c prclib.c prglib.c
LSRC3 = reflib.c rfllib.c sctlib.c setlib.c soclib.c strlib.c timlib.c typlib.c ut8lib.c
ESRC1 = exec.c doany.c objutl.c
ASRC1 = act_comp.c prg_comp.c analyze.c syntax.c token.c parser.c name.c type.c
ASRC2 = expr.c atom.c object.c scanner.c literal.c numlit.c findid.c
ASRC3 = error.c infile.c symbol.c info.c stat.c fatal.c match.c
GSRC1 = syvarutl.c traceutl.c actutl.c executl.c blockutl.c
GSRC2 = entutl.c identutl.c chclsutl.c sigutl.c
RSRC1 = arr_rtl.c bln_rtl.c bst_rtl.c chr_rtl.c cmd_rtl.c con_rtl.c dir_rtl.c drw_rtl.c fil_rtl.c
RSRC2 = flt_rtl.c hsh_rtl.c int_rtl.c set_rtl.c soc_rtl.c str_rtl.c tim_rtl.c ut8_rtl.c
RSRC3 = heaputl.c striutl.c
DSRC1 = $(BIGINT_LIB).c cmd_win.c fil_win.c tim_win.c
SRC = $(MSRC1)
SEED7_LIB_SRC = $(RSRC1) $(RSRC2) $(RSRC3) $(DSRC1)
DRAW_LIB_SRC = gkb_rtl.c drw_win.c
CONSOLE_LIB_SRC = kbd_rtl.c con_win.c
COMP_DATA_LIB_SRC = typ_data.c rfl_data.c ref_data.c listutl.c flistutl.c typeutl.c datautl.c
COMPILER_LIB_SRC = $(PSRC1) $(LSRC1) $(LSRC2) $(LSRC3) $(ESRC1) $(ASRC1) $(ASRC2) $(ASRC3) $(GSRC1) $(GSRC2)

hi: ..\bin\hi.exe ..\prg\hi.exe
	..\bin\hi level

..\bin\hi.exe: $(OBJ) $(ALL_S7_LIBS)
	$(CC) $(LDFLAGS) $(OBJ) $(ALL_S7_LIBS) $(SYSTEM_DRAW_LIBS) $(SYSTEM_CONSOLE_LIBS) $(SYSTEM_LIBS)
	move hi.exe ..\bin

..\prg\hi.exe: ..\bin\hi.exe
	copy ..\bin\hi.exe ..\prg /Y

clear: clean

clean:
	del version.h
	del calltlib.exe
	del *.obj
	del ..\bin\*.lib
	del ..\prg\hi.exe
	del *.tds
	del depend

dep: depend

version.h:
	echo ^#define ANSI_C > version.h
	echo ^#define USE_DIRENT >> version.h
	echo ^#define PATH_DELIMITER '\\' >> version.h
	echo ^#define MAP_ABSOLUTE_PATH_TO_DRIVE_LETTERS >> version.h
	echo ^#define NO_EMPTY_STRUCTS >> version.h
	echo ^#define CATCH_SIGNALS >> version.h
	echo ^#define USE_LOCALTIME_R >> version.h
	echo ^#define USE_ALTERNATE_LOCALTIME_R >> version.h
	echo ^#define USE_ALTERNATE_UTIME >> version.h
	echo ^#define UTIME_ORIG_BUGGY_FOR_FAT_FILES >> version.h
	echo ^#define TURN_OFF_FP_EXCEPTIONS >> version.h
	echo ^#define DEFINE_MATHERR_FUNCTION >> version.h
	echo ^#define ISNAN_WITH_UNDERLINE >> version.h
	echo ^#define CHECK_INT_DIV_BY_ZERO >> version.h
	echo ^#define USE_MYUNISTD_H >> version.h
	echo ^#define CONSOLE_WCHAR >> version.h
	echo ^#define OS_STRI_WCHAR >> version.h
	echo ^#define OS_WIDE_DIR_INCLUDE_DIR_H >> version.h
	echo ^#define OS_CHMOD_INCLUDE_IO_H >> version.h
	echo ^#define os_chdir _wchdir >> version.h
	echo ^#define os_getcwd _wgetcwd >> version.h
	echo ^#define os_mkdir(path,mode) _wmkdir(path) >> version.h
	echo ^#define os_rmdir _wrmdir >> version.h
	echo ^#define os_opendir wopendir >> version.h
	echo ^#define os_readdir wreaddir >> version.h
	echo ^#define os_closedir wclosedir >> version.h
	echo ^#define os_DIR wDIR >> version.h
	echo ^#define os_dirent_struct struct wdirent >> version.h
	echo ^#define os_fstat fstat >> version.h
	echo ^#define os_lstat _wstati64 >> version.h
	echo ^#define os_stat _wstati64 >> version.h
	echo ^#define os_fstat_struct struct stat >> version.h
	echo ^#define os_stat_struct struct stati64 >> version.h
	echo ^#define os_chown(name,uid,gid) >> version.h
	echo ^#define os_chmod _wchmod >> version.h
	echo ^#define os_utime_orig _wutime >> version.h
	echo ^#define os_utime alternate_utime >> version.h
	echo ^#define os_utimbuf_struct struct utimbuf >> version.h
	echo ^#define os_remove _wremove >> version.h
	echo ^#define os_rename _wrename >> version.h
	echo ^#define os_system _wsystem >> version.h
	echo ^#define os_pclose _pclose >> version.h
	echo ^#define os_popen _wpopen >> version.h
	echo ^#define os_fopen _wfopen >> version.h
	echo ^#define os_fseek fseek >> version.h
	echo ^#define os_ftell ftell >> version.h
	echo ^#define OS_FSEEK_OFFSET_BITS 32 >> version.h
	echo ^#define os_off_t __int64 >> version.h
	echo ^#define DEFINE_WGETENV >> version.h
	echo ^#define os_getenv wgetenv >> version.h
	echo ^#define DEFINE_WSETENV >> version.h
	echo ^#define os_setenv wsetenv >> version.h
	echo ^#define USE_WINSOCK >> version.h
	echo ^#define $(BIGINT_LIB_DEFINE) >> version.h
	echo bcc32.exe %* > bcc32.bat
	$(GET_CC_VERSION_INFO) cc_vers.txt
	echo ^#include "dir.h" > chkccomp.h
	echo ^#define popen _popen >> chkccomp.h
	echo ^#define mkdir(path,mode) mkdir(path) >> chkccomp.h
	echo ^#define rmdir _rmdir >> chkccomp.h
	echo ^#define LIST_DIRECTORY_CONTENTS "dir" >> chkccomp.h
	echo ^#define __int64_EXISTS >> chkccomp.h
	echo ^#define TURN_OFF_FP_EXCEPTIONS >> chkccomp.h
	$(CC) chkccomp.c
	chkccomp.exe >> version.h
	del chkccomp.h
	del chkccomp.obj
	del chkccomp.tds
	del chkccomp.exe
	del cc_vers.txt
	echo ^#define OBJECT_FILE_EXTENSION ".obj" >> version.h
	echo ^#define LIBRARY_FILE_EXTENSION ".lib" >> version.h
	echo ^#define EXECUTABLE_FILE_EXTENSION ".exe" >> version.h
	echo ^#define C_COMPILER "$(CC)" >> version.h
	echo ^#define GET_CC_VERSION_INFO "bcc32.exe \076" >> version.h
	echo ^#define CC_OPT_DEBUG_INFO "-y -v" >> version.h
	echo ^#define CC_OPT_NO_WARNINGS "-w-" >> version.h
	echo ^#define REDIRECT_C_ERRORS "\076" >> version.h
	echo ^#define LINKER_OPT_DEBUG_INFO "-v" >> version.h
	echo ^#define LINKER_FLAGS "$(LDFLAGS)" >> version.h
	echo ^#define SYSTEM_LIBS "$(SYSTEM_LIBS)" >> version.h
	echo ^#define SYSTEM_CONSOLE_LIBS "$(SYSTEM_CONSOLE_LIBS)" >> version.h
	echo ^#define SYSTEM_DRAW_LIBS "$(SYSTEM_DRAW_LIBS)" >> version.h
	echo ^#define SEED7_LIB "$(SEED7_LIB)" >> version.h
	echo ^#define CONSOLE_LIB "$(CONSOLE_LIB)" >> version.h
	echo ^#define DRAW_LIB "$(DRAW_LIB)" >> version.h
	echo ^#define COMP_DATA_LIB "$(COMP_DATA_LIB)" >> version.h
	echo ^#define COMPILER_LIB "$(COMPILER_LIB)" >> version.h
	$(CC) setpaths.c
	setpaths.exe >> version.h
	del setpaths.obj
	del setpaths.tds
	del setpaths.exe
	echo ^#include "stdio.h" > calltlib.c
	echo ^#include "string.h" >> calltlib.c
	echo int main (int argc, char **argv) >> calltlib.c
	echo { >> calltlib.c
	echo char buffer[4096]; >> calltlib.c
	echo int number; >> calltlib.c
	echo strcpy(buffer, "tlib /C "); >> calltlib.c
	echo strcat(buffer, argv[1]); >> calltlib.c
	echo strcat(buffer, " "); >> calltlib.c
	"echo for (number = 2; number ^< argc; number++) {" >> calltlib.c
	echo   strcat(buffer, "-+"); >> calltlib.c
	echo   strcat(buffer, argv[number]); >> calltlib.c
	echo } >> calltlib.c
	echo puts(buffer); >> calltlib.c
	echo system(buffer); >> calltlib.c
	echo return 0; >> calltlib.c
	echo } >> calltlib.c
	$(CC) calltlib.c
	del calltlib.c
	del calltlib.obj
	del calltlib.tds

.c.obj:
	$(CC) $(CFLAGS) -c $<

depend: version.h
	echo Working without C header dependency checks.

level.h:
	..\bin\hi level

..\bin\$(SEED7_LIB): $(SEED7_LIB_OBJ)
	calltlib ..\bin\$(SEED7_LIB) $(SEED7_LIB_OBJ)

..\bin\$(CONSOLE_LIB): $(CONSOLE_LIB_OBJ)
	calltlib ..\bin\$(CONSOLE_LIB) $(CONSOLE_LIB_OBJ)

..\bin\$(DRAW_LIB): $(DRAW_LIB_OBJ)
	calltlib ..\bin\$(DRAW_LIB) $(DRAW_LIB_OBJ)

..\bin\$(COMP_DATA_LIB): $(COMP_DATA_LIB_OBJ)
	calltlib ..\bin\$(COMP_DATA_LIB) $(COMP_DATA_LIB_OBJ)

..\bin\$(COMPILER_LIB): $(COMPILER_LIB_OBJ)
	calltlib ..\bin\$(COMPILER_LIB) $(COMPILER_LIB_OBJ)

wc: $(SRC)
	echo SRC:
	wc $(SRC)
	echo SEED7_LIB_SRC:
	wc $(SEED7_LIB_SRC)
	echo CONSOLE_LIB_SRC:
	wc $(CONSOLE_LIB_SRC)
	echo DRAW_LIB_SRC:
	wc $(DRAW_LIB_SRC)
	echo COMP_DATA_LIB_SRC:
	wc $(COMP_DATA_LIB_SRC)
	echo COMPILER_LIB_SRC:
	wc $(COMPILER_LIB_SRC)

lint: $(SRC)
	lint -p $(SRC) $(SYSTEM_DRAW_LIBS) $(SYSTEM_CONSOLE_LIBS) $(SYSTEM_LIBS)

lint2: $(SRC)
	lint -Zn2048 $(SRC) $(SYSTEM_DRAW_LIBS) $(SYSTEM_CONSOLE_LIBS) $(SYSTEM_LIBS)
