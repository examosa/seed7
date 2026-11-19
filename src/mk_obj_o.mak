# Shared object file lists (.o extension) derived from mk_src.mak and platform *SRC variables.
# Uses flat literal suffix substitutions only (portable across GNU make, make7, bmake, and nmake).

MOBJ = $(MSRC:.c=.o)
POBJ = $(PSRC:.c=.o)
LOBJ = $(LSRC:.c=.o)
EOBJ = $(ESRC:.c=.o)
AOBJ = $(ASRC:.c=.o)
GOBJ = $(GSRC:.c=.o)
ROBJ = $(RSRC:.c=.o)
DOBJ = $(DSRC:.c=.o)
OBJ = $(MOBJ)
SEED7_LIB_OBJ = $(ROBJ) $(DOBJ)
DRAW_LIB_OBJ = $(DRAW_LIB_SRC:.c=.o)
CONSOLE_LIB_OBJ = $(CONSOLE_LIB_SRC:.c=.o)
DATABASE_LIB_OBJ_STD_INCL = $(DATABASE_LIB_SRC_STD_INCL:.c=.o)
DATABASE_LIB_OBJ = $(DATABASE_LIB_OBJ_STD_INCL) sql_db2.o sql_ifx.o sql_srv.o
COMP_DATA_LIB_OBJ = $(COMP_DATA_LIB_SRC:.c=.o)
COMPILER_LIB_OBJ = $(POBJ) $(LOBJ) $(EOBJ) $(AOBJ) $(GOBJ)
