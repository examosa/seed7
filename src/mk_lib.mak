# Shared Seed7 library filenames derived from LIB_EXT (e.g. .a, .lib, _emc.a).
# Pure variable assignments only (portable across all make dialects).

SEED7_LIB = seed7_05$(LIB_EXT)
DRAW_LIB = s7_draw$(LIB_EXT)
CONSOLE_LIB = s7_con$(LIB_EXT)
DATABASE_LIB = s7_db$(LIB_EXT)
COMP_DATA_LIB = s7_data$(LIB_EXT)
COMPILER_LIB = s7_comp$(LIB_EXT)
S7_LIBS = $(COMPILER_LIB) $(COMP_DATA_LIB) $(DRAW_LIB) $(CONSOLE_LIB) $(DATABASE_LIB) $(SEED7_LIB)
