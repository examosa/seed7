# Shared platform-independent C source lists and utility lists for Seed7.
# Pure variable assignments only (portable across GNU make, make7, bmake, nmake, and Borland make).
# Platform makefiles must define DSRC, DRAW_LIB_SRC, and CONSOLE_LIB_SRC before including this file.

MSRC = s7.c
PSRC = runerr.c option.c primitiv.c
LSRC = actlib.c arrlib.c biglib.c binlib.c blnlib.c bstlib.c chrlib.c cmdlib.c conlib.c dcllib.c \
       drwlib.c enulib.c fillib.c fltlib.c hshlib.c intlib.c itflib.c kbdlib.c pcslib.c pollib.c \
       prclib.c prglib.c reflib.c rfllib.c sctlib.c sellib.c setlib.c soclib.c sqllib.c strlib.c \
       timlib.c typlib.c ut8lib.c
ESRC = exec.c doany.c objutl.c
ASRC = act_comp.c prg_comp.c analyze.c syntax.c token.c parser.c name.c type.c \
       expr.c atom.c object.c scanner.c literal.c numlit.c findid.c msg_stri.c \
       error.c infile.c libpath.c symbol.c info.c stat.c fatal.c match.c
GSRC = syvarutl.c traceutl.c actutl.c executl.c blockutl.c \
       entutl.c identutl.c chclsutl.c arrutl.c
RSRC = arr_rtl.c bln_rtl.c bst_rtl.c chr_rtl.c cmd_rtl.c con_rtl.c dir_rtl.c drw_rtl.c fil_rtl.c \
       flt_rtl.c hsh_rtl.c int_rtl.c itf_rtl.c pcs_rtl.c set_rtl.c soc_rtl.c sql_rtl.c str_rtl.c \
       tim_rtl.c ut8_rtl.c heaputl.c numutl.c sigutl.c stackutl.c striutl.c
SRC = $(MSRC)
SEED7_LIB_SRC = $(RSRC) $(DSRC)
DATABASE_LIB_SRC_STD_INCL = sql_base.c sql_fire.c sql_lite.c sql_my.c sql_oci.c sql_odbc.c \
                            sql_post.c sql_tds.c
DATABASE_LIB_SRC = $(DATABASE_LIB_SRC_STD_INCL) sql_db2.c sql_ifx.c sql_srv.c
COMP_DATA_LIB_SRC = typ_data.c rfl_data.c ref_data.c listutl.c flistutl.c typeutl.c datautl.c
COMPILER_LIB_SRC = $(PSRC) $(LSRC) $(ESRC) $(ASRC) $(GSRC)

UTILS = bas7 bigfiles calc7 cat comanche db7 diff7 find7 findchar ftp7 ftpserv hd \
        ide7 make7 portfwd7 pv7 s7check sql7 sydir7 tar7 toutf8 which
INSTALL_UTILS = bas7 calc7 db7 diff7 find7 ftp7 ide7 make7 portfwd7 pv7 s7check \
                sql7 sydir7 tar7 toutf8
