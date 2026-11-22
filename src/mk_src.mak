# Shared platform-independent C source lists, OS source groups, and utility lists for Seed7.
# Pure variable assignments only (portable across GNU make, make7, bmake, nmake, and Borland make).
# Platform makefiles must define DSRC, DRAW_LIB_SRC, and CONSOLE_LIB_SRC (or set them via the groups below)
# before including mk_obj_o.mak / mk_obj_w.mak.

ALL_SYSTEM_LIBS = $(SYSTEM_LIBS) $(SYSTEM_BIGINT_LIBS) $(SYSTEM_CONSOLE_LIBS) $(SYSTEM_DATABASE_LIBS) $(SYSTEM_DRAW_LIBS) $(SYSTEM_MATH_LIBS)

UNX_DSRC = big_rtl.c big_gmp.c cmd_unx.c dir_win.c dll_unx.c fil_unx.c pcs_unx.c pol_unx.c soc_none.c \
           tim_unx.c
X11_DRAW_SRC = gkb_rtl.c drw_x11.c gkb_x11.c fwd_x11.c
UNX_CON_SRC = kbd_rtl.c con_inf.c kbd_inf.c kbd_poll.c trm_inf.c trm_cap.c fwd_term.c

WIN_DSRC = big_rtl.c big_gmp.c cmd_win.c dir_win.c dll_win.c fil_win.c pcs_win.c pol_sel.c segv_win.c \
           soc_none.c stat_win.c tim_win.c
WIN_DRAW_SRC = gkb_rtl.c drw_win.c gkb_win.c
WIN_CON_SRC = kbd_rtl.c con_win.c

EMC_DSRC = big_rtl.c big_gmp.c cmd_unx.c dir_win.c dll_unx.c emc_utl.c fil_emc.c pcs_unx.c pol_unx.c \
           soc_none.c tim_emc.c
EMC_DRAW_SRC = gkb_rtl.c drw_emc.c gkb_emc.c
EMC_CON_SRC = kbd_rtl.c con_emc.c

DOS_DSRC = big_rtl.c big_gmp.c cmd_unx.c dir_win.c dll_dos.c fil_dos.c pcs_dos.c pol_dos.c soc_none.c \
           tim_dos.c
DOS_DRAW_SRC = gkb_rtl.c drw_dos.c
DOS_CON_SRC = kbd_rtl.c con_wat.c

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

OBJCOPY_PARAMS = -L SQLAllocHandle -L SQLBindCol -L SQLBindParameter -L SQLBrowseConnectW -L SQLColAttributeW \
                 -L SQLConnectW -L SQLDataSources -L SQLDescribeColW -L SQLDescribeParam -L SQLDisconnect \
                 -L SQLDriverConnectW -L SQLDriversW -L SQLEndTran -L SQLExecute -L SQLFetch -L SQLFreeHandle \
                 -L SQLFreeStmt -L SQLGetConnectAttrW -L SQLGetData -L SQLGetDiagRecW -L SQLGetInfoW \
                 -L SQLGetStmtAttrW -L SQLGetTypeInfoW -L SQLNumParams -L SQLNumResultCols -L SQLPrepareW \
                 -L SQLSetConnectAttrW -L SQLSetDescFieldW -L SQLSetEnvAttr
