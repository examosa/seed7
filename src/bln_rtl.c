/********************************************************************/
/*                                                                  */
/*  bln_rtl.c     Primitive actions for the boolean type.           */
/*  Copyright (C) 1989 - 2006  Thomas Mertes                        */
/*                                                                  */
/*  This file is part of the Seed7 Runtime Library.                 */
/*                                                                  */
/*  The Seed7 Runtime Library is free software; you can             */
/*  redistribute it and/or modify it under the terms of the GNU     */
/*  Lesser General Public License as published by the Free Software */
/*  Foundation; either version 2.1 of the License, or (at your      */
/*  option) any later version.                                      */
/*                                                                  */
/*  The Seed7 Runtime Library is distributed in the hope that it    */
/*  will be useful, but WITHOUT ANY WARRANTY; without even the      */
/*  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR */
/*  PURPOSE.  See the GNU Lesser General Public License for more    */
/*  details.                                                        */
/*                                                                  */
/*  You should have received a copy of the GNU Lesser General       */
/*  Public License along with this program; if not, write to the    */
/*  Free Software Foundation, Inc., 59 Temple Place, Suite 330,     */
/*  Boston, MA 02111-1307 USA                                       */
/*                                                                  */
/*  Module: Seed7 Runtime Library                                   */
/*  File: seed7/src/bln_rtl.c                                       */
/*  Changes: 1999, 2005  Thomas Mertes                              */
/*  Content: Primitive actions for the boolean type.                */
/*                                                                  */
/********************************************************************/

#include "stdlib.h"
#include "stdio.h"

#include "version.h"
#include "common.h"

#undef EXTERN
#define EXTERN
#include "bln_rtl.h"



#ifdef ANSI_C

void blnCpy (booltype *dest, booltype source)
#else

void blnCpy (dest, source)
booltype *dest;
booltype source;
#endif

  { /* blnCpy */
    *dest = source;
  } /* blnCpy */



#ifdef ANSI_C

void blnCreate (booltype *dest, booltype source)
#else

void blnCreate (dest, source)
booltype *dest;
booltype source;
#endif

  { /* blnCreate */
    *dest = source;
  } /* blnCreate */
