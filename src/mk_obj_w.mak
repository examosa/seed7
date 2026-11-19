# Shared object file lists (.obj extension) derived from mk_src.mak and platform *SRC variables.
# Uses flat literal suffix substitutions only (portable across nmake, Borland make, and make7).

MOBJ = $(MSRC:.c=.obj)
POBJ = $(PSRC:.c=.obj)
LOBJ = $(LSRC:.c=.obj)
EOBJ = $(ESRC:.c=.obj)
AOBJ = $(ASRC:.c=.obj)
GOBJ = $(GSRC:.c=.obj)
ROBJ = $(RSRC:.c=.obj)
DOBJ = $(DSRC:.c=.obj)
OBJ = $(MOBJ)
SEED7_LIB_OBJ = $(ROBJ) $(DOBJ)
DRAW_LIB_OBJ = $(DRAW_LIB_SRC:.c=.obj)
CONSOLE_LIB_OBJ = $(CONSOLE_LIB_SRC:.c=.obj)
DATABASE_LIB_OBJ_STD_INCL = $(DATABASE_LIB_SRC_STD_INCL:.c=.obj)
DATABASE_LIB_OBJ = $(DATABASE_LIB_OBJ_STD_INCL) sql_db2.obj sql_ifx.obj sql_srv.obj
COMP_DATA_LIB_OBJ = $(COMP_DATA_LIB_SRC:.c=.obj)
COMPILER_LIB_OBJ = $(POBJ) $(LOBJ) $(EOBJ) $(AOBJ) $(GOBJ)
