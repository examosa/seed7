/********************************************************************/
/*                                                                  */
/*  fil_rtl.c     Primitive actions for the primitive file type.    */
/*  Copyright (C) 1989 - 2005  Thomas Mertes                        */
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
/*  Free Software Foundation, Inc., 51 Franklin Street,             */
/*  Fifth Floor, Boston, MA  02110-1301, USA.                       */
/*                                                                  */
/*  Module: Seed7 Runtime Library                                   */
/*  File: seed7/src/fil_rtl.c                                       */
/*  Changes: 1992, 1993, 1994  Thomas Mertes                        */
/*  Content: Primitive actions for the primitive file type.         */
/*                                                                  */
/********************************************************************/

#include "version.h"

#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "sys/types.h"
#ifdef USE_LSEEKI64
#include "io.h"
#endif

#include "common.h"
#include "heaputl.h"
#include "striutl.h"
#include "big_rtl.h"
#include "rtl_err.h"

#ifdef USE_MYUNISTD_H
#include "myunistd.h"
#else
#include "unistd.h"
#endif

#undef EXTERN
#define EXTERN
#include "fil_rtl.h"


#if   defined USE_LSEEK
typedef off_t              offsettype;
#define myLseek            lseek

#elif defined USE_LSEEKI64
typedef __int64            offsettype;
#define myLseek            _lseeki64

#elif defined USE_FSEEKO
typedef off_t              offsettype;
#define myFseek            fseeko
#define myFtell            ftello

#elif defined USE_FSEEKO64
typedef off64_t            offsettype;
#define myFseek            fseeko64
#define myFtell            ftello64

#elif defined USE_FSEEKI64
typedef __int64            offsettype;
#define myFseek            _fseeki64
#define myFtell            _ftelli64
extern int __cdecl _fseeki64(FILE *, __int64, int);
extern __int64 __cdecl _ftelli64(FILE *);

#else
typedef long               offsettype;
#define myFseek            fseek
#define myFtell            ftell

#endif


#define BUFFER_SIZE 4096



#ifdef ANSI_C

static void get_mode (char mode[4], stritype file_mode)
#else

static void get_mode (mode)
char mode[4];
stritype file_mode;
#endif

  { /* get_mode */
    mode[0] = '\0';
    if (file_mode->size >= 1 &&
        (file_mode->mem[0] == 'r' ||
         file_mode->mem[0] == 'w' ||
         file_mode->mem[0] == 'a')) {
      if (file_mode->size == 1) {
        /* Binary mode
           r ... Open file for reading. 
           w ... Truncate to zero length or create file for writing. 
           a ... Append; open or create file for writing at end-of-file. 
        */
        mode[0] = file_mode->mem[0];
        mode[1] = 'b';
        mode[2] = '\0';
      } else if (file_mode->size == 2) {
        if (file_mode->mem[1] == '+') {
          /* Binary mode
             r+ ... Open file for update (reading and writing). 
             w+ ... Truncate to zero length or create file for update. 
             a+ ... Append; open or create file for update, writing at end-of-file. 
          */
          mode[0] = file_mode->mem[0];
          mode[1] = 'b';
          mode[2] = '+';
          mode[3] = '\0';
        } else if (file_mode->mem[1] == 't') {
          /* Text mode
             rt ... Open file for reading. 
             wt ... Truncate to zero length or create file for writing. 
             at ... Append; open or create file for writing at end-of-file. 
          */
          mode[0] = file_mode->mem[0];
          mode[1] = '\0';
        } /* if */
      } else if (file_mode->size == 3) {
        if (file_mode->mem[1] == 't' &&
            file_mode->mem[2] == '+') {
          /* Text mode
             rt+ ... Open file for update (reading and writing). 
             wt+ ... Truncate to zero length or create file for update. 
             at+ ... Append; open or create file for update, writing at end-of-file. 
          */
          mode[0] = file_mode->mem[0];
          mode[1] = '+';
          mode[2] = '\0';
        } /* if */
      } /* if */
    } /* if */
  } /* get_mode */



#ifdef ANSI_C

biginttype filBigLng (filetype fil1)
#else

biginttype filBigLng (fil1)
filetype fil1;
#endif

  {
    offsettype current_file_position;
    offsettype file_length;

  /* filBigLng */
#ifdef myLseek
    fflush(fil1);
    current_file_position = myLseek(fileno(fil1), (offsettype) 0, SEEK_CUR);
    if (current_file_position == (offsettype) -1) {
      raise_error(FILE_ERROR);
      return(NULL);
    } else {
      file_length = myLseek(fileno(fil1), (offsettype) 0, SEEK_END);
      if (file_length == (offsettype) -1) {
        raise_error(FILE_ERROR);
        return(NULL);
      } else if (myLseek(fileno(fil1), current_file_position, SEEK_SET) == (offsettype) -1) {
        raise_error(FILE_ERROR);
        return(NULL);
      } else if (sizeof(offsettype) == 8) {
        return(bigULConv(file_length));
      } else {
        return(bigUIConv(file_length));
      } /* if */
    } /* if */
#else
    current_file_position = myFtell(fil1);
    if (current_file_position == -1) {
      raise_error(FILE_ERROR);
      return(NULL);
    } else if (myFseek(fil1, (offsettype) 0, SEEK_END) != 0) {
      raise_error(FILE_ERROR);
      return(NULL);
    } else {
      file_length = myFtell(fil1);
      if (file_length == -1) {
        raise_error(FILE_ERROR);
        return(NULL);
      } else if (myFseek(fil1, current_file_position, SEEK_SET) != 0) {
        raise_error(FILE_ERROR);
        return(NULL);
      } else if (sizeof(offsettype) == 8) {
        return(bigULConv(file_length));
      } else {
        return(bigUIConv(file_length));
      } /* if */
    } /* if */
#endif
  } /* filBigLng */



#ifdef ANSI_C

void filBigSeek (filetype fil1, biginttype big_position)
#else

void filBigSeek (fil1, big_position)
filetype fil1;
biginttype big_position;
#endif

  {
    offsettype file_position;

  /* filBigSeek */
#ifdef myLseek
    fflush(fil1);
    if (sizeof(offsettype) == 8) {
      file_position = bigLOrd(big_position);
    } else {
      file_position = bigOrd(big_position);
    } /* if */
    if (file_position <= 0) {
      raise_error(RANGE_ERROR);
    } else if (myLseek(fileno(fil1), file_position - 1, SEEK_SET) == (offsettype) -1) {
      raise_error(FILE_ERROR);
    } /* if */
#else
    if (sizeof(offsettype) == 8) {
      file_position = bigLOrd(big_position);
    } else {
      file_position = bigOrd(big_position);
    } /* if */
    if (file_position <= 0) {
      raise_error(RANGE_ERROR);
    } else if (myFseek(fil1, file_position - 1, SEEK_SET) != 0) {
      raise_error(FILE_ERROR);
    } /* if */
#endif
  } /* filBigSeek */



#ifdef ANSI_C

biginttype filBigTell (filetype fil1)
#else

biginttype filBigTell (fil1)
filetype fil1;
#endif

  {
    offsettype current_file_position;

  /* filBigTell */
#ifdef myLseek
    fflush(fil1);
    current_file_position = myLseek(fileno(fil1), (offsettype) 0, SEEK_CUR);
    if (current_file_position == (offsettype) -1) {
      raise_error(FILE_ERROR);
      return(NULL);
    } else if (sizeof(offsettype) == 8) {
      return(bigULConv(current_file_position + 1));
    } else {
      return(bigUIConv(current_file_position + 1));
    } /* if */
#else
    current_file_position = myFtell(fil1);
    if (current_file_position == -1) {
      raise_error(FILE_ERROR);
      return(NULL);
    } else if (sizeof(offsettype) == 8) {
      return(bigULConv(current_file_position + 1));
    } else {
      return(bigUIConv(current_file_position + 1));
    } /* if */
#endif
  } /* filBigTell */



#ifdef ANSI_C

stritype filGets (filetype fil1, inttype length)
#else

stritype filGets (fil1, length)
filetype fil1;
inttype length;
#endif

  {
    long current_file_position;
    memsizetype bytes_there;
    memsizetype bytes_requested;
    memsizetype result_size;
    stritype result;

  /* filGets */
    if (length < 0) {
      raise_error(RANGE_ERROR);
      return(NULL);
    } else {
      bytes_requested = (memsizetype) length;
      if (!ALLOC_STRI(result, bytes_requested)) {
        if ((current_file_position = ftell(fil1)) != -1) {
          fseek(fil1, 0, SEEK_END);
          bytes_there = (memsizetype) (ftell(fil1) - current_file_position);
          fseek(fil1, current_file_position, SEEK_SET);
          if (bytes_there < bytes_requested) {
            bytes_requested = bytes_there;
            if (!ALLOC_STRI(result, bytes_requested)) {
              raise_error(MEMORY_ERROR);
              return(NULL);
            } /* if */
          } else {
            raise_error(MEMORY_ERROR);
            return(NULL);
          } /* if */
        } else {
          raise_error(MEMORY_ERROR);
          return(NULL);
        } /* if */
      } /* if */
      COUNT_STRI(bytes_requested);
      result_size = (memsizetype) fread(result->mem, 1,
          (SIZE_TYPE) bytes_requested, fil1);
#ifdef WIDE_CHAR_STRINGS
      if (result_size > 0) {
        uchartype *from = &((uchartype *) result->mem)[result_size - 1];
        strelemtype *to = &result->mem[result_size - 1];
        memsizetype number = result_size;

        for (; number > 0; from--, to--, number--) {
          *to = *from;
        } /* for */
      } /* if */
#endif
      result->size = result_size;
      if (result_size < bytes_requested) {
        if (!RESIZE_STRI(result, bytes_requested, result_size)) {
          raise_error(MEMORY_ERROR);
          return(NULL);
        } /* if */
        COUNT3_STRI(bytes_requested, result_size);
      } /* if */
    } /* if */
    return(result);
  } /* filGets */



#ifdef ANSI_C

stritype filLineRead (filetype fil1, chartype *termination_char)
#else

stritype filLineRead (fil1, termination_char)
filetype fil1;
chartype *termination_char;
#endif

  {
    register int ch;
    register memsizetype position;
    strelemtype *memory;
    memsizetype memlength;
    memsizetype newmemlength;
    stritype result;

  /* filLineRead */
    memlength = 256;
    if (!ALLOC_STRI(result, memlength)) {
      raise_error(MEMORY_ERROR);
      return(NULL);
    } else {
      COUNT_STRI(memlength);
      memory = result->mem;
      position = 0;
      while ((ch = getc(fil1)) != '\n' && ch != EOF) {
        if (position >= memlength) {
          newmemlength = memlength + 2048;
          if (!RESIZE_STRI(result, memlength, newmemlength)) {
            raise_error(MEMORY_ERROR);
            return(NULL);
          } /* if */
          COUNT3_STRI(memlength, newmemlength);
          memory = result->mem;
          memlength = newmemlength;
        } /* if */
        memory[position++] = (strelemtype) ch;
      } /* while */
      if (ch == '\n' && position != 0 && memory[position - 1] == '\r') {
        position--;
      } /* if */
      if (!RESIZE_STRI(result, memlength, position)) {
        raise_error(MEMORY_ERROR);
        return(NULL);
      } /* if */
      COUNT3_STRI(memlength, position);
      result->size = position;
      *termination_char = (chartype) ch;
      return(result);
    } /* if */
  } /* filLineRead */



#ifdef ANSI_C

stritype filLit (filetype fil1)
#else

stritype filLit (fil1)
filetype fil1;
#endif

  {
    cstritype file_name;
    memsizetype length;
    stritype result;

  /* filLit */
    if (fil1 == NULL) {
      file_name = "NULL";
    } else if (fil1 == stdin) {
      file_name = "stdin";
    } else if (fil1 == stdout) {
      file_name = "stdout";
    } else if (fil1 == stderr) {
      file_name = "stderr";
    } else {
      file_name = "file";
    } /* if */
    length = strlen(file_name);
    if (!ALLOC_STRI(result, length)) {
      raise_error(MEMORY_ERROR);
      return(NULL);
    } else {
      COUNT_STRI(length);
      result->size = length;
      stri_expand(result->mem, file_name, length);
      return(result);
    } /* if */
  } /* filLit */



#ifdef ANSI_C

inttype filLng (filetype fil1)
#else

inttype filLng (fil1)
filetype fil1;
#endif

  {
    offsettype current_file_position;
    offsettype file_length;

  /* filLng */
#ifdef myLseek
    fflush(fil1);
    current_file_position = myLseek(fileno(fil1), (offsettype) 0, SEEK_CUR);
    if (current_file_position == (offsettype) -1) {
      raise_error(FILE_ERROR);
      return(0);
    } else {
      file_length = myLseek(fileno(fil1), (offsettype) 0, SEEK_END);
      if (file_length == (offsettype) -1) {
        raise_error(FILE_ERROR);
        return(0);
      } else {
        if (myLseek(fileno(fil1), current_file_position, SEEK_SET) == (offsettype) -1) {
          raise_error(FILE_ERROR);
          return(0);
        } else {
          if (file_length > MAX_INTEGER || file_length < (offsettype) 0) {
            raise_error(RANGE_ERROR);
            return(0);
          } else {
            return(file_length);
          } /* if */
        } /* if */
      } /* if */
    } /* if */
#else
    current_file_position = myFtell(fil1);
    if (current_file_position == -1) {
      raise_error(FILE_ERROR);
      return(0);
    } else if (myFseek(fil1, (offsettype) 0, SEEK_END) != 0) {
      raise_error(FILE_ERROR);
      return(0);
    } else {
      file_length = myFtell(fil1);
      if (file_length == -1) {
        raise_error(FILE_ERROR);
        return(0);
      } else if (myFseek(fil1, current_file_position, SEEK_SET) != 0) {
        raise_error(FILE_ERROR);
        return(0);
      } else {
        if (file_length > MAX_INTEGER || file_length < (offsettype) 0) {
          raise_error(RANGE_ERROR);
          return(0);
        } else {
          return(file_length);
        } /* if */
      } /* if */
    } /* if */
#endif
  } /* filLng */



#ifdef ANSI_C

filetype filOpen (stritype file_name, stritype file_mode)
#else

filetype filOpen (file_name, file_mode)
stritype file_name;
stritype file_mode;
#endif

  {
#ifdef USE_WFOPEN
    wchar_t *name;
    wchar_t wide_mode[4];
#else
    cstritype name;
#endif
    char mode[4];
    filetype result;

  /* filOpen */
#ifdef USE_WFOPEN
    name = cp_to_wstri(file_name);
#else
    name = cp_to_cstri(file_name);
#endif
    if (name == NULL) {
      raise_error(MEMORY_ERROR);
      result = NULL;
    } else {
      get_mode(mode, file_mode);
      if (mode[0] == '\0') {
        raise_error(RANGE_ERROR);
        result = NULL;
      } else {
#ifdef USE_WFOPEN
        wide_mode[0] = mode[0];
        wide_mode[1] = mode[1];
        wide_mode[2] = mode[2];
        wide_mode[3] = mode[3];
        result = _wfopen(name, wide_mode);
#else
        result = fopen(name, mode);
#endif
      } /* if */
      free_cstri(name, file_name);
    } /* if */
    return(result);
  } /* filOpen */



#ifdef ANSI_C

filetype filPopen (stritype command, stritype file_mode)
#else

filetype filPopen (command, file_mode)
stritype command;
stritype file_mode;
#endif

  {
    cstritype cmd;
    char mode[4];
    filetype result;

  /* filPopen */
    cmd = cp_to_cstri(command);
    if (cmd == NULL) {
      raise_error(MEMORY_ERROR);
      result = NULL;
    } else {
      get_mode(mode, file_mode);
      if (mode[0] == '\0') {
        raise_error(RANGE_ERROR);
        result = NULL;
      } else {
        result = popen(cmd, mode);
      } /* if */
      free_cstri(cmd, command);
    } /* if */
    return(result);
  } /* filPopen */



#ifdef ANSI_C

void filSeek (filetype fil1, inttype file_position)
#else

void filSeek (fil1, file_position)
filetype fil1;
inttype file_position;
#endif

  { /* filSeek */
    if (file_position <= 0) {
      raise_error(RANGE_ERROR);
    } else if (fseek(fil1, file_position - 1, SEEK_SET) != 0) {
      raise_error(FILE_ERROR);
    } /* if */
  } /* filSeek */



#ifdef ANSI_C

inttype filTell (filetype fil1)
#else

inttype filTell (fil1)
filetype fil1;
#endif

  {
    inttype file_position;

  /* filTell */
    file_position = ftell(fil1);
    if (file_position == -1) {
      raise_error(FILE_ERROR);
      return(0);
    } else if (file_position + 1 <= 0) {
      raise_error(RANGE_ERROR);
      return(0);
    } else {
      return(file_position + 1);
    } /* if */
  } /* filTell */



#ifdef ANSI_C

stritype filWordRead (filetype fil1, chartype *termination_char)
#else

stritype filWordRead (fil1, termination_char)
filetype fil1;
chartype *termination_char;
#endif

  {
    register int ch;
    register memsizetype position;
    strelemtype *memory;
    memsizetype memlength;
    memsizetype newmemlength;
    stritype result;

  /* filWordRead */
    memlength = 256;
    if (!ALLOC_STRI(result, memlength)) {
      raise_error(MEMORY_ERROR);
      return(NULL);
    } else {
      COUNT_STRI(memlength);
      memory = result->mem;
      position = 0;
      do {
        ch = getc(fil1);
      } while (ch == ' ' || ch == '\t');
      while (ch != ' ' && ch != '\t' &&
          ch != '\n' && ch != EOF) {
        if (position >= memlength) {
          newmemlength = memlength + 2048;
          if (!RESIZE_STRI(result, memlength, newmemlength)) {
            raise_error(MEMORY_ERROR);
            return(NULL);
          } /* if */
          COUNT3_STRI(memlength, newmemlength);
          memory = result->mem;
          memlength = newmemlength;
        } /* if */
        memory[position++] = (strelemtype) ch;
        ch = getc(fil1);
      } /* while */
      if (ch == '\n' && position != 0 && memory[position - 1] == '\r') {
        position--;
      } /* if */
      if (!RESIZE_STRI(result, memlength, position)) {
        raise_error(MEMORY_ERROR);
        return(NULL);
      } /* if */
      COUNT3_STRI(memlength, position);
      result->size = position;
      *termination_char = (chartype) ch;
      return(result);
    } /* if */
  } /* filWordRead */



#ifdef ANSI_C

void filWrite (filetype fil1, stritype stri)
#else

void filWrite (stri)
filetype fil1;
stritype stri;
#endif

  { /* filWrite */
#ifdef WIDE_CHAR_STRINGS
    {
      register strelemtype *str;
      memsizetype len;
      register uchartype *ustri;
      register memsizetype buf_len;
      uchartype buffer[BUFFER_SIZE];

      for (str = stri->mem, len = stri->size;
          len >= BUFFER_SIZE; len -= BUFFER_SIZE) {
        for (ustri = buffer, buf_len = BUFFER_SIZE;
            buf_len > 0; str++, ustri++, buf_len--) {
          if (*str >= 256) {
            raise_error(RANGE_ERROR);
            return;
          } /* if */
          *ustri = (uchartype) *str;
        } /* for */
        fwrite(buffer, sizeof(uchartype), BUFFER_SIZE, fil1);
      } /* for */
      if (len > 0) {
        for (ustri = buffer, buf_len = len;
            buf_len > 0; str++, ustri++, buf_len--) {
          if (*str >= 256) {
            raise_error(RANGE_ERROR);
            return;
          } /* if */
          *ustri = (uchartype) *str;
        } /* for */
        fwrite(buffer, sizeof(uchartype), len, fil1);
      } /* if */
    }
#else
    fwrite(stri->mem, sizeof(strelemtype),
        (SIZE_TYPE) stri->size, fil1);
#endif
  } /* filWrite */
