/* 
 * CS:APP Data Lab 
 *
 * 何荣金 2019151059
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */

#endif
//1
/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y)
{
  // a⊕b = (¬a ∧ b) ∨ (a ∧¬b)
  return ~(~(x & ~y) & ~(~x & y));
}
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void)
{
  // int四个字节 最小的补码是 1000 0000 0000 0000 0000 0000 0000 0000
  return 1 << 31;
}
//2
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 2
 */
int isTmax(int x)
{
  // 最大数补码 0111 1111 1111 1111 1111 1111 1111 1111
  // 利用+1产生溢出 再加本身变为0  排除-1情况 同时用!转化为逻辑
  return !(x + 1 + x + 1) & !!(x + 1);
}
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x)
{
  // 利用移位操作构造0xAAAAAAAA (屏蔽码)
  // x & 0xAAAAAAAA = 0xAAAAAAAA
  int t = 0xAA;
  t = (t << 8) | t;
  t = (t << 16) | t;
  return !((x & t) ^ t);
}
/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x)
{
  // 补码 按位取反加一
  return ~x + 1;
}
//3
/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x)
{
  // x < 0 等价于 !!(x&(1<<31))
  // x >= 0 等价于 !!(～x & (1<<31))
  // 0x30 <= x <= 0x39 转化为 x - 0x30 >= 0 && x - 0x3A < 0
  int m1 = ~0x30 + 1 + x;
  int m2 = ~0x3A + 1 + x;
  return !!((~m1 & (1 << 31)) & (m2 & (1 << 31)));
}
/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z)
{
  // 将x化为全0或全1  以x判断即可
  x = ((!!x) << 31) >> 31;
  return (x & y) | (~x & z);
}
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y)
{
  // 转化为!(x > y)
  // 符号位相同 做减法； 符号位不同 直接判断
  int flag1 = (~x & y) & (1 << 31);                // x > 0, y < 0
  int flag2 = ~(x ^ y) & (y + 1 + ~x) & (1 << 31); // x - y > 0
  return !(flag1 | flag2);
}
//4
/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int logicalNeg(int x)
{
  // x = 0时 符号位为零 且 -x = x(不改变符号位)
  int flag1 = ~((x >> 31) & 0x1);
  int flag2 = ~(((~x + 1) >> 31) & 0x1);
  return flag1 & flag2 & 0x1;
}
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x)
{
  // 最小有效位 = 符号位 + 有效位
  // 正数检测高位的1
  // 对于负数 取反后可以归到正数的情况
  int anti = (x >> 31) ^ x; // 对负数取反， 正数保持
  int re = 0;               //有效位
  int tmp;

  // 二分查找高位的1
  tmp = !!(anti >> 16) << 4;
  re += tmp;
  anti >>= tmp;

  tmp = !!(anti >> 8) << 3;
  re += tmp;
  anti >>= tmp;

  tmp = !!(anti >> 4) << 2;
  re += tmp;
  anti >>= tmp;

  tmp = !!(anti >> 2) << 1;
  re += tmp;
  anti >>= tmp;

  tmp = !!(anti >> 1);
  re += tmp;
  anti >>= tmp;

  re += anti;
  return re + 1;
}
//float
/* 
 * float_twice - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_twice(unsigned uf)
{
  //+-0 无穷大 NaN 直接返回本身
  int case1 = !!(uf == 0 || uf == 0x80000000);
  int case2 = !!(((uf >> 23) & 0xff) == 0xff);
  if (case1 || case2)
    return uf;

  // 非规格化下 要将其尾数翻倍
  if (((uf >> 23) & 0xff) == 0)
    return (uf & (1 << 31)) | (uf << 1);

  // 规格化表示下 在指数域不发生溢出情况下 直接加1
  uf += 1 << 23;
  // 如果溢出(全一) 则需要将尾数清零
  if (((uf >> 23) & 0xff) == 0xff)
    uf &= 0xff800000;
  return uf;
}
/* 
 * float_i2f - Return bit-level equivalent of expression (float) x
 *   Result is returned as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point values.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_i2f(int x)
{
  return 2;
}
/* 
 * float_f2i - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int float_f2i(unsigned uf)
{
  // +-0
  if (uf == 0 || uf == (1 << 31))
    return 0;
  // 无穷大 NaN
  if (((uf >> 23) & 0xff) == 0xff)
    return 1 << 31;

  int sign = (1 << 31) & uf;
  int exp = ((uf >> 23) & 0xff) - 127;
  int frac = (uf & 0x7fffff) + (1 << 23); // 构造尾数
  int re;

  // int 最多32位 分情况判断即可
  if (exp < 0)
    return 0;
  else if (exp <= 23)
    re = frac >> (23 - exp);
  else if (exp < 31)
    re = frac << (exp - 23);
  else
    re = 1 << 31;

  if (sign)
    re = -re;
  return re;
}
