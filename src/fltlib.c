/********************************************************************/
/*                                                                  */
/*  s7   Seed7 interpreter                                          */
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
/*  Module: Library                                                 */
/*  File: seed7/src/fltlib.c                                        */
/*  Changes: 1993, 1994  Thomas Mertes                              */
/*  Content: All primitive actions for the float type.              */
/*                                                                  */
/********************************************************************/

#include "version.h"

#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "time.h"
#include "math.h"
#include "float.h"

#include "common.h"
#include "data.h"
#include "data_rtl.h"
#include "heaputl.h"
#include "flistutl.h"
#include "syvarutl.h"
#include "objutl.h"
#include "runerr.h"
#include "flt_rtl.h"

#undef EXTERN
#define EXTERN
#include "fltlib.h"



/**
 *  Compute the arc tangent of y/x.
 *  The signs of x and y are used to determine the quadrant of the result.
 *  It determines the angle theta from the conversion of rectangular
 *  coordinates (x, y) to polar coordinates (r, theta).
 *  @return the arc tangent of y/x in radians. The returned angle is in
 *          the range [-PI, PI].
 */
objecttype flt_a2tan (listtype arguments)

  { /* flt_a2tan */
    isit_float(arg_1(arguments));
    isit_float(arg_2(arguments));
    return bld_float_temp(
        atan2(take_float(arg_1(arguments)), take_float(arg_2(arguments))));
  } /* flt_a2tan */



/**
 *  Compute the absolute value of a float number.
 *  @return the absolute value.
 */
objecttype flt_abs (listtype arguments)

  {
    double number;

  /* flt_abs */
    isit_float(arg_1(arguments));
    number = take_float(arg_1(arguments));
    if (number < (double) 0.0) {
      number = -number;
    } /* if */
    return bld_float_temp(number);
  } /* flt_abs */



/**
 *  Compute the arc cosine of x; that is the value whose cosine is x.
 *  @return the arc cosine of x in radians. The returned angle is in
 *          the range [0.0, PI].
 */
objecttype flt_acos (listtype arguments)

  { /* flt_acos */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        acos(take_float(arg_1(arguments))));
  } /* flt_acos */



/**
 *  Add two float numbers.
 *  @return the sum of the two numbers.
 */
objecttype flt_add (listtype arguments)

  { /* flt_add */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
    return bld_float_temp(
        (double) take_float(arg_1(arguments)) +
        (double) take_float(arg_3(arguments)));
  } /* flt_add */



/**
 *  Compute the arc sine of x; that is the value whose sine is x.
 *  @return the arc sine of x in radians. The return angle is in the
 *          range [-PI/2, PI/2].
 */
objecttype flt_asin (listtype arguments)

  { /* flt_asin */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        asin(take_float(arg_1(arguments))));
  } /* flt_asin */



/**
 *  Compute the arc tangent of x; that is the value whose tangent is x.
 *  @return the arc tangent of x in radians. The returned angle is in
 *          the range [-PI/2, PI/2].
 */
objecttype flt_atan (listtype arguments)

  { /* flt_atan */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        atan(take_float(arg_1(arguments))));
  } /* flt_atan */



objecttype flt_cast (listtype arguments)

  { /* flt_cast */
    isit_float(arg_3(arguments));
    /* The float value is taken as int on purpose */
    return bld_int_temp(take_int(arg_3(arguments)));
  } /* flt_cast */



/**
 *  Round up towards positive infinity.
 *  Determine the smallest value that is greater than or equal
 *  to the argument and is equal to a mathematical integer.
 *  @return the rounded value.
 */
objecttype flt_ceil (listtype arguments)

  { /* flt_ceil */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        ceil(take_float(arg_1(arguments))));
  } /* flt_ceil */



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
objecttype flt_cmp (listtype arguments)

  { /* flt_cmp */
    isit_float(arg_1(arguments));
    isit_float(arg_2(arguments));
    return bld_int_temp(
        fltCmp(take_float(arg_1(arguments)), take_float(arg_2(arguments))));
  } /* flt_cmp */



/**
 *  Compute the cosine of x, where x is given in radians.
 *  @return the trigonometric cosine of an angle.
 */
objecttype flt_cos (listtype arguments)

  { /* flt_cos */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        cos(take_float(arg_1(arguments))));
  } /* flt_cos */



/**
 *  Compute the hyperbolic cosine of x.
 *  cosh(x) is mathematically defined as: (exp(x) + exp(-x)) / 2.0
 *  @return the hyperbolic cosine.
 */
objecttype flt_cosh (listtype arguments)

  { /* flt_cosh */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        cosh(take_float(arg_1(arguments))));
  } /* flt_cosh */



objecttype flt_cpy (listtype arguments)

  {
    objecttype flt_variable;

  /* flt_cpy */
    flt_variable = arg_1(arguments);
    isit_float(flt_variable);
    is_variable(flt_variable);
    isit_float(arg_3(arguments));
    flt_variable->value.floatvalue = take_float(arg_3(arguments));
    return SYS_EMPTY_OBJECT;
  } /* flt_cpy */



objecttype flt_create (listtype arguments)

  { /* flt_create */
    isit_float(arg_3(arguments));
    SET_CATEGORY_OF_OBJ(arg_1(arguments), FLOATOBJECT);
    arg_1(arguments)->value.floatvalue = take_float(arg_3(arguments));
    return SYS_EMPTY_OBJECT;
  } /* flt_create */



/**
 *  Convert a float to a string in decimal fixed point notation.
 *  The 'precision' parameter specifies the number of digits after
 *  the decimal point. When the 'precision' is zero the decimal
 *  point is omitted. When all digits in the result are 0 a negative
 *  sign is omitted.
 *  @return the string result of the conversion.
 *  @exception MEMORY_ERROR Not enough memory to represent the result.
 */
objecttype flt_dgts (listtype arguments)

  { /* flt_dgts */
    isit_float(arg_1(arguments));
    isit_int(arg_3(arguments));
    return bld_stri_temp(
        fltDgts(take_float(arg_1(arguments)), take_int(arg_3(arguments))));
  } /* flt_dgts */



/**
 *  Compute the division of two float numbers.
 *  @return the quotient of the division.
 */
objecttype flt_div (listtype arguments)

  {
    floattype dividend;
    floattype divisor;

  /* flt_div */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
    dividend = take_float(arg_1(arguments));
    divisor = take_float(arg_3(arguments));
#ifdef CHECK_FLOAT_DIV_BY_ZERO
    if (divisor == 0.0) {
      if (dividend == 0.0 || isnan(dividend)) {
        return bld_float_temp(NOT_A_NUMBER);
      } else if ((dividend < 0.0) == fltIsNegativeZero(divisor)) {
        return bld_float_temp(POSITIVE_INFINITY);
      } else {
        return bld_float_temp(NEGATIVE_INFINITY);
      } /* if */
    } /* if */
#endif
    return bld_float_temp(((double) dividend) / ((double) divisor));
  } /* flt_div */



/**
 *  Divide a float 'number' by a 'divisor' and assign the result back to 'number'.
 */
objecttype flt_div_assign (listtype arguments)

  {
    objecttype flt_variable;
#ifdef CHECK_FLOAT_DIV_BY_ZERO
    floattype dividend;
#endif
    floattype divisor;

  /* flt_div_assign */
    flt_variable = arg_1(arguments);
    isit_float(flt_variable);
    is_variable(flt_variable);
    isit_float(arg_3(arguments));
    divisor = take_float(arg_3(arguments));
#ifdef CHECK_FLOAT_DIV_BY_ZERO
    if (divisor == 0.0) {
      dividend = take_float(flt_variable);
      if (dividend == 0.0 || isnan(dividend)) {
        flt_variable->value.floatvalue = NOT_A_NUMBER;
      } else if ((dividend < 0.0) == fltIsNegativeZero(divisor)) {
        flt_variable->value.floatvalue = POSITIVE_INFINITY;
      } else {
        flt_variable->value.floatvalue = NEGATIVE_INFINITY;
      } /* if */
    } else {
      flt_variable->value.floatvalue /= divisor;
    } /* if */
#else
    flt_variable->value.floatvalue /= divisor;
#endif
    return SYS_EMPTY_OBJECT;
  } /* flt_div_assign */



/**
 *  Check if two float numbers are equal.
 *  According to IEEE 754 a NaN is not equal to any float value.
 *  Therefore 'NaN = any_value' and 'any_value = NaN'
 *  always return FALSE. Even 'NaN = NaN' returns FALSE.
 *  @return TRUE if both numbers are equal, FALSE otherwise.
 */
objecttype flt_eq (listtype arguments)

  { /* flt_eq */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
#ifdef NAN_COMPARISON_WRONG
    if (fltEq(take_float(arg_1(arguments)),
              take_float(arg_3(arguments)))) {
#else
    if (take_float(arg_1(arguments)) ==
        take_float(arg_3(arguments))) {
#endif
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_eq */



/**
 *  Compute Euler's number e raised to the power of x.
 *  @return e raised to the power of x.
 */
objecttype flt_exp (listtype arguments)

  { /* flt_exp */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        exp(take_float(arg_1(arguments))));
  } /* flt_exp */



/**
 *  Round down towards negative infinity.
 *  Returns the largest value that is less than or equal to the
 *  argument and is equal to a mathematical integer.
 *  @return the rounded value.
 */
objecttype flt_floor (listtype arguments)

  { /* flt_floor */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        floor(take_float(arg_1(arguments))));
  } /* flt_floor */



/**
 *  Check if 'number1' is greater than or equal to 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is greater than or equal to 'number2',
 *          FALSE otherwise.
 */
objecttype flt_ge (listtype arguments)

  { /* flt_ge */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
#ifdef NAN_COMPARISON_WRONG
    if (fltGe(take_float(arg_1(arguments)),
              take_float(arg_3(arguments)))) {
#else
    if (take_float(arg_1(arguments)) >=
        take_float(arg_3(arguments))) {
#endif
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_ge */



/**
 *  Increment a float 'number' by a 'delta'.
 */
objecttype flt_grow (listtype arguments)

  {
    objecttype flt_variable;

  /* flt_grow */
    flt_variable = arg_1(arguments);
    isit_float(flt_variable);
    is_variable(flt_variable);
    isit_float(arg_3(arguments));
    flt_variable->value.floatvalue += take_float(arg_3(arguments));
    return SYS_EMPTY_OBJECT;
  } /* flt_grow */



/**
 *  Check if 'number1' is greater than 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is greater than 'number2',
 *          FALSE otherwise.
 */
objecttype flt_gt (listtype arguments)

  { /* flt_gt */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
#ifdef NAN_COMPARISON_WRONG
    if (fltGt(take_float(arg_1(arguments)),
              take_float(arg_3(arguments)))) {
#else
    if (take_float(arg_1(arguments)) >
        take_float(arg_3(arguments))) {
#endif
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_gt */



/**
 *  Compute the hash value of a float number.
 *  @return the hash value.
 */
objecttype flt_hashcode (listtype arguments)

  { /* flt_hashcode */
    isit_float(arg_1(arguments));
    /* The float value is taken as int on purpose */
    return bld_int_temp(take_int(arg_1(arguments)));
  } /* flt_hashcode */



objecttype flt_icast (listtype arguments)

  { /* flt_icast */
    isit_int(arg_3(arguments));
    /* The int value is taken as float on purpose */
    return bld_float_temp(take_float(arg_3(arguments)));
  } /* flt_icast */



/**
 *  Convert an integer to a float.
 *  @return the float result of the conversion.
 */
objecttype flt_iconv (listtype arguments)

  { /* flt_iconv */
    isit_int(arg_3(arguments));
    return bld_float_temp((double) take_int(arg_3(arguments)));
  } /* flt_iconv */



/**
 *  Convert an integer to a float.
 *  @return the float result of the conversion.
 */
objecttype flt_iflt (listtype arguments)

  { /* flt_iflt */
    isit_int(arg_1(arguments));
    return bld_float_temp((double) take_int(arg_1(arguments)));
  } /* flt_iflt */



/**
 *  Compute the exponentiation of a float 'base' with an integer 'exponent'.
 *  @return the result of the exponentation.
 */
objecttype flt_ipow (listtype arguments)

  { /* flt_ipow */
    isit_float(arg_1(arguments));
    isit_int(arg_3(arguments));
    return bld_float_temp(
        fltIPow(take_float(arg_1(arguments)), take_int(arg_3(arguments))));
  } /* flt_ipow */



/**
 *  Determine if a number has a Not-a-Number (NaN) value.
 *  NaN represents an undefined or unrepresentable value.
 *  @return TRUE if the number has a Not-a-Number (NaN) value,
 *          FALSE otherwise.
 */
objecttype flt_isnan (listtype arguments)

  { /* flt_isnan */
    isit_float(arg_1(arguments));
    if (isnan(take_float(arg_1(arguments)))) {
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_isnan */



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
objecttype flt_isnegativezero (listtype arguments)

  { /* flt_isnegativezero */
    isit_float(arg_1(arguments));
    if (fltIsNegativeZero(take_float(arg_1(arguments)))) {
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_isnegativezero */



/**
 *  Check if 'number1' is less than or equal to 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is less than or equal to 'number2',
 *          FALSE otherwise.
 */
objecttype flt_le (listtype arguments)

  { /* flt_le */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
#ifdef NAN_COMPARISON_WRONG
    if (fltLe(take_float(arg_1(arguments)),
              take_float(arg_3(arguments)))) {
#else
    if (take_float(arg_1(arguments)) <=
        take_float(arg_3(arguments))) {
#endif
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_le */



/**
 *  Return the natural logarithm (base e) of x.
 *  @return the natural logarithm of x.
 */
objecttype flt_log (listtype arguments)

  { /* flt_log */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        log(take_float(arg_1(arguments))));
  } /* flt_log */



/**
 *  Returns the base 10 logarithm of x.
 *  @return the base 10 logarithm of x.
 */
objecttype flt_log10 (listtype arguments)

  { /* flt_log10 */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        log10(take_float(arg_1(arguments))));
  } /* flt_log10 */



/**
 *  Check if 'number1' is less than 'number2'.
 *  According to IEEE 754 a NaN is neither less than,
 *  equal to, nor greater than any value, including itself.
 *  When 'number1' or 'number2' is NaN, the result
 *  is FALSE;
 *  @return TRUE if 'number1' is less than 'number2',
 *          FALSE otherwise.
 */
objecttype flt_lt (listtype arguments)

  { /* flt_lt */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
#ifdef NAN_COMPARISON_WRONG
    if (fltLt(take_float(arg_1(arguments)),
              take_float(arg_3(arguments)))) {
#else
    if (take_float(arg_1(arguments)) <
        take_float(arg_3(arguments))) {
#endif
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_lt */



/**
 *  Minus sign, negate a float 'number'.
 *  @return the negated value of the number.
 */
objecttype flt_minus (listtype arguments)

  { /* flt_minus */
    isit_float(arg_2(arguments));
    return bld_float_temp(
        -(double) take_float(arg_2(arguments)));
  } /* flt_minus */



/**
 *  Multiply two float numbers.
 *  @return the product of the two numbers.
 */
objecttype flt_mult (listtype arguments)

  { /* flt_mult */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
    return bld_float_temp(
        (double) take_float(arg_1(arguments)) *
        (double) take_float(arg_3(arguments)));
  } /* flt_mult */



/**
 *  Multiply a float 'number' by a 'factor' and assign the result back to 'number'.
 */
objecttype flt_mult_assign (listtype arguments)

  {
    objecttype flt_variable;

  /* flt_mult_assign */
    flt_variable = arg_1(arguments);
    isit_float(flt_variable);
    is_variable(flt_variable);
    isit_float(arg_3(arguments));
    flt_variable->value.floatvalue *= take_float(arg_3(arguments));
    return SYS_EMPTY_OBJECT;
  } /* flt_mult_assign */



/**
 *  Check if two float numbers are not equal.
 *  According to IEEE 754 a NaN is not equal to any float value.
 *  Therefore 'NaN <> any_value' and 'any_value <> NaN'
 *  always return TRUE. Even 'NaN <> NaN' returns TRUE.
 *  @return FALSE if both numbers are equal, TRUE otherwise.
 */
objecttype flt_ne (listtype arguments)

  { /* flt_ne */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
#ifdef NAN_COMPARISON_WRONG
    if (!fltEq(take_float(arg_1(arguments)),
               take_float(arg_3(arguments)))) {
#else
    if (take_float(arg_1(arguments)) !=
        take_float(arg_3(arguments))) {
#endif
      return SYS_TRUE_OBJECT;
    } else {
      return SYS_FALSE_OBJECT;
    } /* if */
  } /* flt_ne */



/**
 *  Convert a string to a float number.
 *  @return the float result of the conversion.
 *  @exception RANGE_ERROR When the string contains not a float literal.
 */
objecttype flt_parse (listtype arguments)

  { /* flt_parse */
    isit_stri(arg_3(arguments));
    return bld_float_temp(
        fltParse(take_stri(arg_3(arguments))));
  } /* flt_parse */



/**
 *  Plus sign for float numbers.
 *  @return its operand unchanged.
 */
objecttype flt_plus (listtype arguments)

  { /* flt_plus */
    isit_float(arg_2(arguments));
    return bld_float_temp((double) take_float(arg_2(arguments)));
  } /* flt_plus */



/**
 *  Compute the exponentiation of a float 'base' with a float 'exponent'.
 *  @return the result of the exponentation.
 */
objecttype flt_pow (listtype arguments)

  { /* flt_pow */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
#ifdef POWER_OF_ZERO_WRONG
    return bld_float_temp(
        fltPow(take_float(arg_1(arguments)), take_float(arg_3(arguments))));
#else
    return bld_float_temp(
        pow(take_float(arg_1(arguments)), take_float(arg_3(arguments))));
#endif
  } /* flt_pow */



/**
 *  Compute pseudo-random number in the range [low, high].
 *  The random values are uniform distributed.
 *  @return the computed pseudo-random number.
 *  @exception RANGE_ERROR The range is empty (low > high holds).
 */
objecttype flt_rand (listtype arguments)

  { /* flt_rand */
    isit_float(arg_1(arguments));
    isit_float(arg_2(arguments));
    return bld_float_temp(
        fltRand(take_float(arg_1(arguments)), take_float(arg_2(arguments))));
  } /* flt_rand */



/**
 *  Round towards the nearest integer.
 *  Halfway cases are rounded away from zero.
 *  @return the rounded value.
 */
objecttype flt_round (listtype arguments)

  {
    floattype number;

  /* flt_round */
    isit_float(arg_1(arguments));
    number = take_float(arg_1(arguments));
    if (number < (floattype) 0.0) {
      return bld_int_temp(-((inttype) (0.5 - number)));
    } else {
      return bld_int_temp((inttype) (0.5 + number));
    } /* if */
  } /* flt_round */



/**
 *  Compute the subtraction of two float numbers.
 *  @return the difference of the two numbers.
 */
objecttype flt_sbtr (listtype arguments)

  { /* flt_sbtr */
    isit_float(arg_1(arguments));
    isit_float(arg_3(arguments));
    return bld_float_temp(
        (double) take_float(arg_1(arguments)) -
        (double) take_float(arg_3(arguments)));
  } /* flt_sbtr */



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
objecttype flt_sci (listtype arguments)

  { /* flt_sci */
    isit_float(arg_1(arguments));
    isit_int(arg_3(arguments));
    return bld_stri_temp(
        fltSci(take_float(arg_1(arguments)),
               take_int(arg_3(arguments))));
  } /* flt_sci */



/**
 *  Decrement a float 'number' by a 'delta'.
 */
objecttype flt_shrink (listtype arguments)

  {
    objecttype flt_variable;

  /* flt_shrink */
    flt_variable = arg_1(arguments);
    isit_float(flt_variable);
    is_variable(flt_variable);
    isit_float(arg_3(arguments));
    flt_variable->value.floatvalue -= take_float(arg_3(arguments));
    return SYS_EMPTY_OBJECT;
  } /* flt_shrink */



/**
 *  Compute the sine of x, where x is given in radians.
 *  @return the trigonometric sine of an angle.
 */
objecttype flt_sin (listtype arguments)

  { /* flt_sin */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        sin(take_float(arg_1(arguments))));
  } /* flt_sin */



/**
 *  Compute the hyperbolic sine of x.
 *  sinh(x) is mathematically defined as: (exp(x) - exp(-x)) / 2.0
 *  @return the hyperbolic sine.
 */
objecttype flt_sinh (listtype arguments)

  { /* flt_sinh */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        sinh(take_float(arg_1(arguments))));
  } /* flt_sinh */



/**
 *  Returns the non-negative square root of x.
 *  @return the square root of x.
 */
objecttype flt_sqrt (listtype arguments)

  { /* flt_sqrt */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        sqrt(take_float(arg_1(arguments))));
  } /* flt_sqrt */



/**
 *  Convert a float number to a string.
 *  The number is converted to a string with decimal representation.
 *  The sign of negative zero (-0.0) is ignored.
 *  @return the string result of the conversion.
 *  @exception MEMORY_ERROR Not enough memory to represent the result.
 */
objecttype flt_str (listtype arguments)

  { /* flt_str */
    isit_float(arg_1(arguments));
    return bld_stri_temp(
        fltStr(take_float(arg_1(arguments))));
  } /* flt_str */



/**
 *  Compute the tangent of x, where x is given in radians.
 *  @return the trigonometric tangent of an angle.
 */
objecttype flt_tan (listtype arguments)

  { /* flt_tan */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        tan(take_float(arg_1(arguments))));
  } /* flt_tan */



/**
 *  Compute the hyperbolic tangent of x.
 *  tanh(x) is mathematically defined as: sinh(x) / cosh(x)
 *  @return the hyperbolic tangent.
 */
objecttype flt_tanh (listtype arguments)

  { /* flt_tanh */
    isit_float(arg_1(arguments));
    return bld_float_temp(
        tanh(take_float(arg_1(arguments))));
  } /* flt_tanh */



/**
 *  Truncate towards zero.
 *  The fractional part of a number is discarded.
 *  @return the nearest integer not larger in absolute value
 *          than the argument.
 */
objecttype flt_trunc (listtype arguments)

  { /* flt_trunc */
    isit_float(arg_1(arguments));
    return bld_int_temp((inttype) take_float(arg_1(arguments)));
  } /* flt_trunc */



objecttype flt_value (listtype arguments)

  {
    objecttype obj_arg;

  /* flt_value */
    isit_reference(arg_1(arguments));
    obj_arg = take_reference(arg_1(arguments));
    if (obj_arg == NULL || CATEGORY_OF_OBJ(obj_arg) != FLOATOBJECT) {
      return raise_exception(SYS_RNG_EXCEPTION);
    } else {
      return bld_float_temp(take_float(obj_arg));
    } /* if */
  } /* flt_value */
