/********************************************************************/
/*                                                                  */
/*  hi   Interpreter for Seed7 programs.                            */
/*  Copyright (C) 1990 - 2000  Thomas Mertes                        */
/*                                                                  */
/*  This program is free software; you can redistribute it and/or   */
/*  modify it under the terms of the GNU General Public License as  */
/*  published by the Free Software Foundation; either version 2 of  */
/*  the License, or (at your option) any later version.             */
/*                                                                  */
/*  This program is distributed in the hope that it will be useful, */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of  */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the   */
/*  GNU General Public License for more details.                    */
/*                                                                  */
/*  You should have received a copy of the GNU General Public       */
/*  License along with this program; if not, write to the           */
/*  Free Software Foundation, Inc., 51 Franklin Street,             */
/*  Fifth Floor, Boston, MA  02110-1301, USA.                       */
/*                                                                  */
/*  Module: General                                                 */
/*  File: seed7/src/syvarutl.c                                      */
/*  Changes: 1991, 1992, 1993, 1994  Thomas Mertes                  */
/*  Content: Maintains the interpreter system variables.            */
/*                                                                  */
/********************************************************************/

#include "version.h"

#include "stdio.h"
#include "string.h"

#include "common.h"
#include "data.h"
#include "heaputl.h"
#include "striutl.h"

#undef EXTERN
#define EXTERN
#include "syvarutl.h"


static const_cstritype sys_name[NUMBER_OF_SYSVARS] = {
    "empty",
    "memory_error",
    "numeric_error",
    "range_error",
    "file_error",
    "illegal_action",
    "false",
    "true",
    "type",
    "expr",
    "integer",
    "bigInteger",
    "char",
    "string",
    "proc",
    "float",
    "assign",
    "create",
    "destroy",
    "ord",
    "in",
    "prot_outfile",
    "flush",
    "write",
    "writeln",
    "main",
  };



#ifdef ANSI_C

int find_sysvar (const_stritype stri)
#else

int find_sysvar (stri)
stritype stri;
#endif

  {
    int result;
    char sysvar_name[151];

  /* find_sysvar */
#ifdef TRACE_SYSVAR
    printf("BEGIN find_sysvar\n");
#endif
    if (stri->size >= 151 / MAX_UTF8_EXPANSION_FACTOR) {
      result = -1;
    } else {
      stri_export((ustritype) sysvar_name, stri);
      result = NUMBER_OF_SYSVARS - 1;
      while (result >= 0 &&
          strcmp(sysvar_name, sys_name[result]) != 0) {
        result--;
      } /* while */
    } /* if */
#ifdef TRACE_SYSVAR
    printf("END find_sysvar\n");
#endif
    return result;
  } /* find_sysvar */



#ifdef ANSI_C

void init_sysvar (void)
#else

void init_sysvar ()
#endif

  {
    int number;

  /* init_sysvar */
#ifdef TRACE_SYSVAR
    printf("BEGIN init_sysvar\n");
#endif
    for (number = 0; number < NUMBER_OF_SYSVARS; number++) {
      prog.sys_var[number] = NULL;
    } /* for */
#ifdef TRACE_SYSVAR
    printf("END init_sysvar\n");
#endif
  } /* init_sysvar */
