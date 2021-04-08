## 数据表示实验
* 主要是应用计算机底层的指令(与或非 移位 异或)对整形、浮点型的补码进行操作，进而实现一些算术上的功能。

  ```C++
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
  ```

  