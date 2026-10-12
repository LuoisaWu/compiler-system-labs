#==============================================================================
# manyargs.s —— 参数超过 8 个的 SysY 函数在 RV64 上的手工汇编实现
#
# 源程序：
#   int mix(int a, ..., int j)    —— 10 个参数，纯计算（叶子函数）
#   int chain(int a, ..., int j)  —— 10 个参数，且自己再调用 mix
#   int main()                    —— 调用上面两个函数并输出
#
# 核心约定：RISC-V 只有 a0~a7 八个参数寄存器。第 9 个及其后的参数，由调用者在调用点写到 0(sp)、8(sp)；被调函数开辟自己的栈帧后，在 frame_size(sp)、frame_size+8(sp) 处取回。
#
# 汇编/链接/运行：
#   riscv64-linux-gnu-gcc -march=rv64gc -mabi=lp64d -static manyargs.s sysy_runtime.c -o manyargs
#   /usr/bin/qemu-riscv64 ./manyargs
#
#==============================================================================

    .file   "manyargs.s"
    .option nopic
    .attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0"
    .attribute unaligned_access, 0
    .attribute stack_align, 16


#------------------------------------------------------------------------------
# int mix(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j)
#   return (a - j) * (b - i) + (c - h) * (d - g) + e * f;
#
# 参数分配：
#   a b c d e f g h      ->  a0 a1 a2 a3 a4 a5 a6 a7
#   i（第 9 个参数）      ->  调用者栈上 0(sp)
#   j（第 10 个参数）     ->  调用者栈上 8(sp)
#
# 栈帧布局（16 字节，没有局部变量；这 16 字节只是为了让帧内偏移统一）：
#       16(sp)  第 9 个参数 i
#       24(sp)  第 10 个参数 j
#
#------------------------------------------------------------------------------
    .text
    .align  2
    .globl  mix
    .type   mix, @function
mix:
    addi    sp, sp, -16

    lw      t0, 16(sp)              # t0 = i（第 9 个参数）
    lw      t1, 24(sp)              # t1 = j（第 10 个参数）

    subw    t2, a0, t1              # t2 = a - j
    subw    t3, a1, t0              # t3 = b - i
    mulw    t2, t2, t3              # t2 = (a - j) * (b - i)

    subw    t3, a2, a7              # t3 = c - h
    subw    t4, a3, a6              # t4 = d - g
    mulw    t3, t3, t4              # t3 = (c - h) * (d - g)

    addw    t2, t2, t3              # t2 = 前两项之和
    mulw    t4, a4, a5              # t4 = e * f
    addw    a0, t2, t4              # 返回值 = 三项之和

    addi    sp, sp, 16
    jr      ra
    .size   mix, .-mix


#------------------------------------------------------------------------------
# int chain(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j)
#   return mix(j, i, h, g, f, e, d, c, b, a) + a * b + i * j;
#
# 参数分配（本函数栈帧 64 字节）：
#   a b c d e f g h      ->  a0 a1 a2 a3 a4 a5 a6 a7
#   i（第 9 个参数）      ->  64(sp)
#   j（第 10 个参数）     ->  72(sp)
#
# 栈帧布局（64 字节）：
#        0(sp)  调用 mix 时的第 9 个实参
#        8(sp)  调用 mix 时的第 10 个实参
#       16(sp)  ra           —— chain 要调用 mix，必须保护返回地址
#       24(sp)  s1  —— i
#       32(sp)  s2  —— j
#       40(sp)  s3  —— a
#       48(sp)  s4  —— b
#       56(sp)  s5  —— mix 的返回值
#       64(sp)  自己的第 9 个参数 i
#       72(sp)  自己的第 10 个参数 j
#------------------------------------------------------------------------------
    .text
    .align  2
    .globl  chain
    .type   chain, @function
chain:
    addi    sp, sp, -64
    sd      ra, 16(sp)
    sd      s1, 24(sp)
    sd      s2, 32(sp)
    sd      s3, 40(sp)
    sd      s4, 48(sp)
    sd      s5, 56(sp)

    lw      s1, 64(sp)              # s1 = i（自己的第 9 个参数）
    lw      s2, 72(sp)              # s2 = j（自己的第 10 个参数）
    mv      s3, a0                  # s3 = a
    mv      s4, a1                  # s4 = b

    #=====================================================================
    # 准备 mix 的 10 个实参：mix(j, i, h, g, f, e, d, c, b, a)
    #   a2~a7 里现在是 (c, d, e, f, g, h)，要倒过来装成 (h, g, f, e, d, c)。
    #=====================================================================
    mv      t0, a7                  # t0 = h
    mv      t1, a6                  # t1 = g
    mv      t2, a5                  # t2 = f
    mv      t3, a4                  # t3 = e
    mv      t4, a3                  # t4 = d
    mv      t5, a2                  # t5 = c

    mv      a2, t0                  # 第 3 个实参 = h
    mv      a3, t1                  # 第 4 个实参 = g
    mv      a4, t2                  # 第 5 个实参 = f
    mv      a5, t3                  # 第 6 个实参 = e
    mv      a6, t4                  # 第 7 个实参 = d
    mv      a7, t5                  # 第 8 个实参 = c
    mv      a0, s2                  # 第 1 个实参 = j
    mv      a1, s1                  # 第 2 个实参 = i

    sd      s4, 0(sp)               # 第 9 个实参 = b，写到出参区最低两个槽
    sd      s3, 8(sp)               # 第 10 个实参 = a
    call    mix

    #=====================================================================
    # 返回值 = mix(...) + a * b + i * j
    #=====================================================================
    mv      s5, a0                  # s5 = mix 的返回值
    mulw    t0, s3, s4              # t0 = a * b
    addw    s5, s5, t0
    mulw    t1, s1, s2              # t1 = i * j
    addw    a0, s5, t1              # a0 = 三项之和

    ld      ra, 16(sp)
    ld      s1, 24(sp)
    ld      s2, 32(sp)
    ld      s3, 40(sp)
    ld      s4, 48(sp)
    ld      s5, 56(sp)
    addi    sp, sp, 64
    jr      ra
    .size   chain, .-chain


#------------------------------------------------------------------------------
# int main()
#
# 栈帧布局（48 字节）：
#        0(sp)  调用 mix / chain 时的第 9 个实参
#        8(sp)  调用 mix / chain 时的第 10 个实参
#       16(sp)  ra
#       24(sp)  s1  —— k
#       32(sp)  s2  —— s
#       40(sp)  s3  —— 循环上界
#
#------------------------------------------------------------------------------
    .text
    .align  2
    .globl  main
    .type   main, @function
main:
    addi    sp, sp, -48
    sd      ra, 16(sp)
    sd      s1, 24(sp)
    sd      s2, 32(sp)
    sd      s3, 40(sp)

    # ---- putint(mix(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)); putch(10); ----
    li      a0, 1                   # 第 1~8 个实参依次装入 a0~a7
    li      a1, 2
    li      a2, 3
    li      a3, 4
    li      a4, 5
    li      a5, 6
    li      a6, 7
    li      a7, 8
    li      t0, 9
    sd      t0, 0(sp)               # 第 9 个实参
    li      t0, 10
    sd      t0, 8(sp)               # 第 10 个实参
    call    mix
    call    putint                  # 返回值已在 a0，直接传给 putint
    li      a0, 10
    call    putch

    # ---- putint(chain(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)); putch(10); ----
    li      a0, 1
    li      a1, 2
    li      a2, 3
    li      a3, 4
    li      a4, 5
    li      a5, 6
    li      a6, 7
    li      a7, 8
    li      t0, 9
    sd      t0, 0(sp)
    li      t0, 10
    sd      t0, 8(sp)
    call    chain
    call    putint
    li      a0, 10
    call    putch

    #=====================================================================
    # 循环里连续调用 mix，实参随 k 变化，栈上的两个槽每次都要重填
    #   while (k < 5) { s += mix(k, k+1, ..., k+9); k++; }
    #=====================================================================
    li      s1, 0                   # k = 0
    li      s2, 0                   # s = 0
    li      s3, 5                   # 循环上界

.Lmain_loop:
    bge     s1, s3, .Lmain_out      # k >= 5，退出循环

    addiw   a0, s1, 0               # 第 1 个实参 = k（addiw 顺带做符号扩展）
    addiw   a1, s1, 1               # 第 2 个实参 = k + 1
    addiw   a2, s1, 2
    addiw   a3, s1, 3
    addiw   a4, s1, 4
    addiw   a5, s1, 5
    addiw   a6, s1, 6
    addiw   a7, s1, 7               # 第 8 个实参 = k + 7
    addiw   t0, s1, 8
    sd      t0, 0(sp)               # 第 9 个实参 = k + 8
    addiw   t0, s1, 9
    sd      t0, 8(sp)               # 第 10 个实参 = k + 9
    call    mix

    addw    s2, s2, a0              # s = s + mix(...)
    addiw   s1, s1, 1               # k = k + 1
    j       .Lmain_loop

.Lmain_out:
    mv      a0, s2
    call    putint
    li      a0, 10
    call    putch

    # ---- return 0; ----
    li      a0, 0
    ld      ra, 16(sp)
    ld      s1, 24(sp)
    ld      s2, 32(sp)
    ld      s3, 40(sp)
    addi    sp, sp, 48
    jr      ra
    .size   main, .-main

    .ident  "RISC-V RV64GC assembly, handwritten"
    .section .note.GNU-stack,"",@progbits
