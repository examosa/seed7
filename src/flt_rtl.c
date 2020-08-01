/********************************************************************/
/*                                                                  */
/*  flt_rtl.c     Primitive actions for the float type.             */
/*  Copyright (C) 1989 - 2010  Thomas Mertes                        */
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
/*  File: seed7/src/flt_rtl.c                                       */
/*  Changes: 1993, 1994, 2005, 2010  Thomas Mertes                  */
/*  Content: Primitive actions for the float type.                  */
/*                                                                  */
/********************************************************************/

#include "version.h"

#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "math.h"
#include "float.h"

#include "common.h"
#include "data_rtl.h"
#include "heaputl.h"
#include "striutl.h"
#include "rtl_err.h"
#include "int_rtl.h"

#undef EXTERN
#define EXTERN
#include "flt_rtl.h"


#define USE_STRTOD
#define IPOW_EXPONENTIATION_BY_SQUARING

#ifdef FLOAT_ZERO_DIV_ERROR
const rtlValueunion f_const[] =
#ifdef FLOATTYPE_DOUBLE
    {0xfff8000000000000, 0x7ff0000000000000, 0xfff0000000000000};
#else
    {0xffc00000, 0x7f800000, 0xff800000};
#endif
#endif

#ifdef USE_NEGATIVE_ZERO_BITPATTERN
static const rtlValueunion neg_zero_const =
#ifdef FLOATTYPE_DOUBLE
    {0x8000000000000000};
#else
    {0x80000000};
#endif
#endif

floattype negativeZero;

#ifndef USE_VARIABLE_FORMATS
#define MAX_FORM 28

static char *form[] = {"%1.0f", "%1.1f", "%1.2f", "%1.3f", "%1.4f",
    "%1.5f",  "%1.6f",  "%1.7f",  "%1.8f",  "%1.9f",  "%1.10f",
    "%1.11f", "%1.12f", "%1.13f", "%1.14f", "%1.15f", "%1.16f",
    "%1.17f", "%1.18f", "%1.19f", "%1.20f", "%1.21f", "%1.22f",
    "%1.23f", "%1.24f", "%1.25f", "%1.26f", "%1.27f", "%1.28f"};
#endif



void setupFloat (void)

  {
#ifndef USE_NEGATIVE_ZERO_BITPATTERN
    floattype zero = 0.0;
    floattype plusInf;
#endif

  /* setupFloat */
#ifdef TURN_OFF_FP_EXCEPTIONS
    _control87(MCW_EM, MCW_EM);
#endif
#ifdef USE_NEGATIVE_ZERO_BITPATTERN
    negativeZero = neg_zero_const.floatvalue;
#else
    plusInf = 1.0 / zero;
    negativeZero = -1.0 / plusInf;
#endif
  } /* setupFloat */



#ifdef DEFINE_MATHERR_FUNCTION
int _matherr (struct _exception *a)

  { /* _matherr */
    a->retval = a->retval;
    return 1;
  } /* _matherr */
#endif



/**
 *  Compare two float numbers.
 *  Because fltCmp is used to sort float values, a total
 *  order of all float values is needed. Therefore fltCmp
 *  considers NaN as equal to itself and greater than
 *  Infinity.
 *  @return -1, 0 or 1 if the first argument is considered to be
 *          respectively less than, equal to, or greater than the
 *          second.
 */
inttype fltCmp (floattype number1, floattype number2)

  { /* fltCmp */
#ifdef NAN_COMPARISON_WRONG
    if (isnan(number1)) {
      if (isnan(number2)) {
        return 0;
      } else {
        return 1;
      } /* if */
    } else if (isnan(number2)) {
      return -1;
    } else if (number1 < number2) {
      return -1;
    } else if (number1 > number2) {
      return 1;
    } else {
      return 0;
    } /* if */
#else
    if (number1 < number2) {
      return -1;
    } else if (number1 > number2) {
      return 1;
    } else if (isnan(number1)) {
      if (isnan(number2)) {
        return 0;
      } else {
        return 1;
      } /* if */
    } else if (isnan(number2)) {
      return -1;
    } else {
      return 0;
    } /* if */
#endif
  } /* fltCmp */



/**
 *  Reinterpret the generic parameters as floattype and call fltCmp.
 *  Function pointers in C programs generated by the Seed7 compiler
 *  may point to this function. This assures correct behaviour even
 *  when sizeof(rtlGenerictype) != sizeof(floattype).
 */
inttype fltCmpGeneric (const rtlGenerictype value1, const rtlGenerictype value2)

  { /* fltCmpGeneric */
    return fltCmp(((const_rtlObjecttype *) &value1)->value.floatvalue,
                  ((const_rtlObjecttype *) &value2)->value.floatvalue);
  } /* fltCmpGeneric */



void fltCpyGeneric (floattype *dest, const rtlGenerictype source)

  { /* fltCpy */
    *dest = ((const_rtlObjecttype *) &source)->value.floatvalue;
  } /* fltCpy */



/**
 *  Convert a float to a string in decimal fixed point notation.
 *  The 'precision' parameter specifies the number of digits after
 *  the decimal point. When the 'precision' is zero the decimal
 *  point is omitted. When all digits in the result are 0 a negative
 *  sign is omitted.
 *  @return the string result of the conversion.
 *  @exception MEMORY_ERROR Not enough memory to represent the result.
 */
stritype fltDgts (floattype number, inttype digits_precision)

  {
    char buffer[2001];
    const_cstritype buffer_ptr;
#ifndef USE_VARIABLE_FORMATS
    char form_buffer[10];
#endif
    memsizetype pos;
    stritype result;

  /* fltDgts */
    if (digits_precision < 0) {
      digits_precision = 0;
    } /* if */
    if (digits_precision > 1000) {
      digits_precision = 1000;
    } /* if */
    if (isnan(number)) {
      buffer_ptr = "NaN";
    } else if (number == POSITIVE_INFINITY) {
      buffer_ptr = "Infinity";
    } else if (number == NEGATIVE_INFINITY) {
      buffer_ptr = "-Infinity";
    } else {
#ifdef USE_VARIABLE_FORMATS
      sprintf(buffer, "%1.*f", (int) digits_precision, number);
#else
      if (digits_precision > MAX_FORM) {
        sprintf(form_buffer, "%%1.%ldf", digits_precision);
        sprintf(buffer, form_buffer, number);
      } else {
        sprintf(buffer, form[digits_precision], number);
      } /* if */
#endif
      buffer_ptr = buffer;
      if (buffer[0] == '-' && buffer[1] == '0') {
        /* All forms of -0 are converted to 0 */
        if (buffer[2] == '.') {
          pos = 3;
          while (buffer[pos] == '0') {
            pos++;
          } /* while */
          if (buffer[pos] == '\0') {
            buffer_ptr++;
          } /* if */
        } else if (buffer[2] == '\0') {
          buffer_ptr++;
        } /* if */
      } /* if */
    } /* if */
    result = cstri_to_stri(buffer_ptr);
    if (unlikely(result == NULL)) {
      raise_error(MEMORY_ERROR);
    } /* if */
    return result;
  } /* fltDgts */



#ifdef NAN_COMPARISON_WRONG
/**
 *  Check if two float numbers are equal.
 *  According to IEEE 754 a NaN is not equal to any float value.
 *  Therefore 'NaN = any_value' and 'any_value = NaN'
 *  always return FALSE. Even 'NaN = NaN' returns FALSE.
 *  @return TRUE if both numbers are equal, FALSE otherwise.
 */
booltype fltEq (floattype number1, floattype number2)

  { /* fltEq */
    if (isnan(number1) || isnan(number2)) {
      return FALSE;
    } else {
      return number1 == number2;
    } /* if */
  } /* fltEq */
#endif



#ifdef NAN_COMPARISON_WRONG
/**
 *  Check if 'number1' is greater than or equal to 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is greater than or equal to 'number2',
 *          FALSE otherwise.
 */
booltype fltGe (floattype number1, floattype number2)

  { /* fltGe */
    if (isnan(number1) || isnan(number2)) {
      return FALSE;
    } else {
      return number1 >= number2;
    } /* if */
  } /* fltGe */
#endif



#ifdef NAN_COMPARISON_WRONG
/**
 *  Check if 'number1' is greater than 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is greater than 'number2',
 *          FALSE otherwise.
 */
booltype fltGt (floattype number1, floattype number2)

  { /* fltGt */
    if (isnan(number1) || isnan(number2)) {
      return FALSE;
    } else {
      return number1 > number2;
    } /* if */
  } /* fltGt */
#endif



/**
 *  Compute the exponentiation of a float 'base' with an integer 'exponent'.
 *  @return the result of the exponentation.
 */
floattype fltIPow (floattype base, inttype exponent)

  {
    booltype neg_exp = FALSE;
    floattype result;

  /* fltIPow */
#ifdef IPOW_EXPONENTIATION_BY_SQUARING
    if (base == 0.0) {
      if (exponent < 0) {
        return POSITIVE_INFINITY;
      } else if (exponent == 0) {
        return 1.0;
      } else {
        return 0.0;
      } /* if */
    } else {
      if (exponent < 0) {
        exponent = -exponent;
        if (exponent < 0) {
          /* In the twos complement representation the most */
          /* negative number is the only one where both the */
          /* number and its negation are negative. When the */
          /* exponent is proven to be to the most negative  */
          /* number fltIPow returns 0.0 .                   */
          return 0.0;
        } /* if */
        neg_exp = TRUE;
      } /* if */
      if (exponent & 1) {
        result = base;
      } else {
        result = 1.0;
      } /* if */
      exponent >>= 1;
      while (exponent != 0) {
        base *= base;
        if (exponent & 1) {
          result *= base;
        } /* if */
        exponent >>= 1;
      } /* while */
      if (neg_exp) {
        return 1.0 / result;
      } else {
        return result;
      } /* if */
    } /* if */
#else
    if (base < 0.0) {
      if (exponent & 1) {
        return -pow(-base, (floattype) exponent);
      } else {
        return pow(-base, (floattype) exponent);
      } /* if */
    } else if (base == 0.0) {
      if (exponent < 0) {
        return POSITIVE_INFINITY;
      } else if (exponent == 0) {
        return 1.0;
      } else {
        return 0.0;
      } /* if */
    } else { /* base > 0.0 */
      return pow(base, (floattype) exponent);
    } /* if */
#endif
  } /* fltIPow */



/**
 *  Determine if a number is -0.0.
 *  This function is the only possibility to determine if a number
 *  is -0.0. The comparison operators (=, <>, <, >, <=, >=) and
 *  the function 'compare' treat 0.0 and -0.0 as equal. The
 *  'digits' operator and the 'str' function convert -0.0 to
 *  the string "0.0".
 *  @return TRUE if the number is -0.0,
 *          FALSE otherwise.
 */
booltype fltIsNegativeZero (floattype number)

  { /* fltIsNegativeZero */
    /* printf("fltIsNegativeZero %f %08x %08x\n",
        number, *(int32type *) &number, *(int32type *) &negativeZero); */
    return memcmp(&number, &negativeZero, sizeof(floattype)) == 0;
  } /* fltIsNegativeZero */



#ifdef NAN_COMPARISON_WRONG
/**
 *  Check if 'number1' is less than or equal to 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is less than or equal to 'number2',
 *          FALSE otherwise.
 */
booltype fltLe (floattype number1, floattype number2)

  { /* fltLe */
    if (isnan(number1) || isnan(number2)) {
      return FALSE;
    } else {
      return number1 <= number2;
    } /* if */
  } /* fltLe */
#endif



#ifdef NAN_COMPARISON_WRONG
/**
 *  Check if 'number1' is less than 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is less than 'number2',
 *          FALSE otherwise.
 */
booltype fltLt (floattype number1, floattype number2)

  { /* fltLt */
    if (isnan(number1) || isnan(number2)) {
      return FALSE;
    } else {
      return number1 < number2;
    } /* if */
  } /* fltLt */
#endif



/**
 *  Convert a string to a float number.
 *  @return the float result of the conversion.
 *  @exception RANGE_ERROR When the string contains not a float literal.
 */
floattype fltParse (const const_stritype stri)

  {
    booltype okay;
#ifdef USE_STRTOD
    char buffer[150];
    char *next_ch;
#else
    memsizetype position;
    floattype digitval;
#endif
    floattype result;

  /* fltParse */
    okay = TRUE;
#ifdef USE_STRTOD
    if (stri->size < 150 / MAX_UTF8_EXPANSION_FACTOR) {
      stri_export_utf8((ustritype) buffer, stri);
/*    result = (floattype) atof(buffer); */
      result = (floattype) strtod(buffer, &next_ch);
      if (next_ch == buffer) {
        if (strcmp(buffer, "NaN") == 0) {
          result = NOT_A_NUMBER;
        } else if (strcmp(buffer, "Infinity") == 0) {
          result = POSITIVE_INFINITY;
        } else if (strcmp(buffer, "-Infinity") == 0) {
          result = NEGATIVE_INFINITY;
        } else {
          okay = FALSE;
        } /* if */
      } else if (next_ch != &buffer[stri->size]) {
        okay = FALSE;
      } /* if */
    } else {
      okay = FALSE;
    } /* if */
#else
    position = 0;
    result = 0.0;
    while (position < stri->size &&
        stri->mem[position] >= ((strelemtype) '0') &&
        stri->mem[position] <= ((strelemtype) '9')) {
      digitval = ((inttype) stri->mem[position]) - ((inttype) '0');
      if (result < MAX_DIV_10 ||
          (result == MAX_DIV_10 &&
          digitval <= MAX_REM_10)) {
        result = ((floattype) 10.0) * result + digitval;
      } else {
        okay = FALSE;
      } /* if */
      position++;
    } /* while */
    if (position == 0 || position < stri->size) {
      okay = FALSE;
    } /* if */
#endif
    if (likely(okay)) {
      return result;
    } else {
      raise_error(RANGE_ERROR);
      return 0.0;
    } /* if */
  } /* fltParse */



#ifdef POWER_OF_ZERO_WRONG
/**
 *  Compute the exponentiation of a float 'base' with a float 'exponent'.
 *  @return the result of the exponentation.
 */
floattype fltPow (floattype base, floattype exponent)

  { /* fltPow */
    if (base == 0.0 && exponent < 0.0) {
      if (memcmp(&base, &negativeZero, sizeof(floattype)) == 0) {
        if (floor(exponent) - exponent == 0.0) {
          /* integer exponent */
          if (floor(exponent / 2.0) * 2.0 - exponent < -0.5) {
            /* odd exponent */
            return NEGATIVE_INFINITY;
          } else {
            return POSITIVE_INFINITY;
          } /* if */
        } else {
          return POSITIVE_INFINITY;
        } /* if */
      } else {
        return POSITIVE_INFINITY;
      } /* if */
    } else {
      return pow(base, exponent);
    } /* if */
  } /* fltPow */
#endif



/**
 *  Compute pseudo-random number in the range [low, high].
 *  The random values are uniform distributed.
 *  @return the computed pseudo-random number.
 *  @exception RANGE_ERROR The range is empty (low > high holds).
 */
floattype fltRand (floattype low, floattype high)

  {
    double factor;
    floattype result;

  /* fltRand */
    /* printf("fltRand(%f, %f)\n", low, high); */
    if (unlikely(low > high)) {
      raise_error(RANGE_ERROR);
      return 0.0;
    } else {
      factor = high - low;
      if (factor == POSITIVE_INFINITY) {
        do {
          result = (floattype) uint_rand();
        } while (result < low || result > high);
      } else {
        do {
          result = ((floattype) uint_rand()) / ((floattype) UINTTYPE_MAX);
          result = low + factor * result;
        } while (result < low || result > high);
      } /* if */
      return result;
    } /* if */
  } /* fltRand */



/**
 *  Convert a float to a string in scientific notation.
 *  Scientific notation uses a decimal float with optional sign, which
 *  has only one digit before the decimal point. The float is followed
 *  by the letter e and an exponent, which is always signed.
 *  The 'precision' parameter specifies the number of digits after
 *  the decimal point. When the 'precision' is zero the decimal
 *  point is omitted. When all digits in the result are 0 a negative
 *  sign is omitted.
 *  @return the string result of the conversion.
 *  @exception MEMORY_ERROR Not enough memory to represent the result.
 */
stritype fltSci (floattype number, inttype precision)

  {
    char buffer[2001];
    const_cstritype buffer_ptr;
#ifndef USE_VARIABLE_FORMATS
    char form_buffer[10];
#endif
    memsizetype startPos;
    memsizetype pos;
    memsizetype len;
    memsizetype after_zeros;
    stritype result;

  /* fltSci */
    if (precision < 0) {
      precision = 0;
    } /* if */
    if (precision > 1000) {
      precision = 1000;
    } /* if */
    if (isnan(number)) {
      buffer_ptr = "NaN";
    } else if (number == POSITIVE_INFINITY) {
      buffer_ptr = "Infinity";
    } else if (number == NEGATIVE_INFINITY) {
      buffer_ptr = "-Infinity";
    } else {
#ifdef USE_VARIABLE_FORMATS
      sprintf(buffer, "%1.*e", (int) precision, number);
#else
      if (precision > MAX_FORM) {
        sprintf(form_buffer, "%%1.%lde", precision);
        sprintf(buffer, form_buffer, number);
      } else {
        sprintf(buffer, form[precision], number);
      } /* if */
#endif
      startPos = 0;
      if (buffer[0] == '-' && buffer[1] == '0') {
        /* All forms of -0 are converted to 0 */
        if (buffer[2] == '.') {
          pos = 3;
          while (buffer[pos] == '0') {
            pos++;
          } /* while */
          if (buffer[pos] == 'e' && buffer[pos + 2] == '0') {
            pos += 3;
            while (buffer[pos] == '0') {
              pos++;
            } /* while */
            if (buffer[pos] == '\0') {
              startPos++;
            } /* if */
          } /* if */
        } else if (buffer[2] == 'e' && buffer[4] == '0') {
          pos = 5;
          while (buffer[pos] == '0') {
            pos++;
          } /* while */
          if (buffer[pos] == '\0') {
            startPos++;
          } /* if */
        } /* if */
      } /* if */
      len = strlen(buffer);
      if (len > startPos) {
        pos = len;
        do {
          pos--;
        } while (pos > startPos && buffer[pos] != 'e');
        pos += 2;
        after_zeros = pos;
        while (buffer[after_zeros] == '0') {
          after_zeros++;
        } /* while */
        if (buffer[after_zeros] == '\0') {
          after_zeros--;
        } /* if */
        memmove(&buffer[pos], &buffer[after_zeros],
            sizeof(char) * (len - after_zeros + 1));
      } /* if */
      buffer_ptr = &buffer[startPos];
    } /* if */
    result = cstri_to_stri(buffer_ptr);
    if (unlikely(result == NULL)) {
      raise_error(MEMORY_ERROR);
    } /* if */
    return result;
  } /* fltSci */



/**
 *  Convert a float number to a string.
 *  The number is converted to a string with decimal representation.
 *  The sign of negative zero (-0.0) is ignored.
 *  @return the string result of the conversion.
 *  @exception MEMORY_ERROR Not enough memory to represent the result.
 */
stritype fltStr (floattype number)

  {
    char buffer[1001];
    memsizetype len;
    stritype result;

  /* fltStr */
    if (isnan(number)) {
      strcpy(buffer, "NaN");
    } else if (number == POSITIVE_INFINITY) {
      strcpy(buffer, "Infinity");
    } else if (number == NEGATIVE_INFINITY) {
      strcpy(buffer, "-Infinity");
    } else {
      sprintf(buffer, "%1.50f", number);
    } /* if */
    len = strlen(buffer);
    do {
      len--;
    } while (len >= 1 && buffer[len] == '0');
    if (buffer[len] == '.') {
      len++;
    } /* if */
    len++;
    if (len == 4 && memcmp(buffer, "-0.0", 4) == 0) {
      /* -0.0 is converted to 0.0 */
      memcpy(buffer, "0.0", 3);
      len = 3;
    } /* if */
    if (unlikely(!ALLOC_STRI_SIZE_OK(result, len))) {
      raise_error(MEMORY_ERROR);
      return NULL;
    } else {
      result->size = len;
      cstri_expand(result->mem, buffer, (size_t) len);
      return result;
    } /* if */
  } /* fltStr */
