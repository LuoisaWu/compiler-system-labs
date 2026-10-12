#==============================================================================
# demo.s —— 与 demo.c 等价的 RISC-V (RV64GC) 汇编程序
#
# 源程序：
#   const int N = 8;
#   int calls = 0;
#   int fib(int n)               —— 递归求斐波那契
#   int calc(int a, int b)       —— 整数四则与取余
#   int main()                   —— 数组、双循环、函数调用与输出
#
# 汇编/链接/运行：
#   riscv64-linux-gnu-gcc -march=rv64gc -mabi=lp64d -static demo.s sysy_runtime.c -o demo_riscv
#   /usr/bin/qemu-riscv64 ./demo_riscv
#
#==============================================================================

    .file   "demo.s"
    .option nopic
    .attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0"
    .attribute unaligned_access, 0
    .attribute stack_align, 16


#------------------------------------------------------------------------------
# 全局数据段
#   N      —— const int，内容不可变，放入只读数据段 .rodata
#   calls  —— int，初值为 0，放入 .bss
#------------------------------------------------------------------------------
    .section .rodata
    .align  2                       # 4 字节对齐，与 int 的自然对齐一致
    .globl  N
    .type   N, @object
    .size   N, 4
N:
    .word   8

    .section .bss
    .align  2
    .globl  calls
    .type   calls, @object
    .size   calls, 4
calls:
    .zero   4


#------------------------------------------------------------------------------
# int fib(int n)
#
# 栈帧布局（sp 为基准，共 32 字节）：
#       24(sp)  ra
#       16(sp)  s1      —— 保存 fib(n-1) 的结果，跨越第二次递归调用
#        8(sp)  n       —— 形参备份
#
# 传参/返回：n 由 a0 传入，返回值由 a0 传出
#------------------------------------------------------------------------------
    .text
    .align  2
    .globl  fib
    .type   fib, @function
fib:
    addi    sp, sp, -32             # 开辟栈帧
    sd      ra, 24(sp)              # 保护返回地址
    sd      s1, 16(sp)              # 保护被调用者保存寄存器 s1
    sw      a0, 8(sp)               # 形参 n 落栈

    # ---- if (n <= 1) return n; ----
    lw      t0, 8(sp)               # t0 = n
    li      t1, 1
    bgt     t0, t1, .Lfib_recur     # n > 1 时转入递归分支
    lw      a0, 8(sp)               # 否则返回值即为 n
    j       .Lfib_ret

.Lfib_recur:
    # ---- calls = calls + 1; ----
    lla     t0, calls               # t0 = &calls
    lw      t1, 0(t0)               # t1 = calls
    addiw   t1, t1, 1               # t1 = calls + 1
    sw      t1, 0(t0)               # calls = t1

    # ---- s1 = fib(n - 1) ----
    lw      a0, 8(sp)
    addiw   a0, a0, -1              # a0 = n - 1
    call    fib
    mv      s1, a0                  # 结果暂存到 s1

    # ---- a0 = fib(n - 2) ----
    lw      a0, 8(sp)
    addiw   a0, a0, -2              # a0 = n - 2
    call    fib

    # ---- return s1 + a0; ----
    addw    a0, s1, a0              # addw 自带符号扩展，无需再 sext.w

.Lfib_ret:
    ld      ra, 24(sp)              # 恢复返回地址
    ld      s1, 16(sp)              # 恢复 s1
    addi    sp, sp, 32              # 回收栈帧
    jr      ra
    .size   fib, .-fib


#------------------------------------------------------------------------------
# int calc(int a, int b)
#   return (a + b) * (a - b) / b + a % b;
#
# 只用 16 字节栈帧安放 a、b传参：a 由 a0 传入，b 由 a1 传入；返回值由 a0 传出
#------------------------------------------------------------------------------
    .text
    .align  2
    .globl  calc
    .type   calc, @function
calc:
    addi    sp, sp, -16
    sw      a0, 0(sp)               # 备份 a
    sw      a1, 4(sp)               # 备份 b

    lw      t0, 0(sp)               # t0 = a
    lw      t1, 4(sp)               # t1 = b

    addw    t2, t0, t1              # t2 = a + b
    subw    t3, t0, t1              # t3 = a - b
    mulw    t2, t2, t3              # t2 = (a + b) * (a - b)
    divw    t3, t2, t1              # t3 = (a + b) * (a - b) / b
    remw    t4, t0, t1              # t4 = a % b

    addw    a0, t3, t4              # 结果放入返回寄存器 a0

    addi    sp, sp, 16
    jr      ra
    .size   calc, .-calc


#------------------------------------------------------------------------------
# int main()
#
# 栈帧布局（sp 为基准，共 80 字节）：
#        0..19(sp)  int a[5]
#       32(sp)      s5  —— sum
#       40(sp)      s4  —— t
#       48(sp)      s3  —— y
#       56(sp)      s2  —— x
#       64(sp)      s1  —— i
#       72(sp)      ra
#
# 局部变量 i、x、y、t、sum 全部驻留在 s1~s5 中；由于 main 要调用 fib / calc / putint 等函数，这些寄存器必须先保存，否则会被被调函数改写。
#------------------------------------------------------------------------------
    .text
    .align  2
    .globl  main
    .type   main, @function
main:
    addi    sp, sp, -80             # 开辟 80 字节栈帧
    sd      ra, 72(sp)
    sd      s1, 64(sp)
    sd      s2, 56(sp)
    sd      s3, 48(sp)
    sd      s4, 40(sp)
    sd      s5, 32(sp)

    # ---- int a[5] = {1, 2, 3, 4, 5}; ----
    # 逐个元素用立即数写入，省去从 .rodata 拷贝常量的间接步骤
    li      t0, 1
    sw      t0, 0(sp)
    li      t0, 2
    sw      t0, 4(sp)
    li      t0, 3
    sw      t0, 8(sp)
    li      t0, 4
    sw      t0, 12(sp)
    li      t0, 5
    sw      t0, 16(sp)

    # ---- int i = 0, x = 0, y = 1, sum = 0; ----
    li      s1, 0                   # i   = 0
    li      s2, 0                   # x   = 0
    li      s3, 1                   # y   = 1
    li      s5, 0                   # sum = 0

    #=====================================================================
    # 第一个 while：生成数组 a 并推进斐波那契数列
    #   while (i < N) { if (i < 5) a[i] = x; t = x+y; x = y; y = t; i++; }
    #=====================================================================
    li      t6, 8                   # N = 8，循环上界

.Lmain_loop1:
    bge     s1, t6, .Lmain_after1   # i >= 8，退出循环

    # ---- if (i < 5) a[i] = x; ----
    li      t1, 5
    bge     s1, t1, .Lmain_push     # i >= 5，跳过数组赋值
    slli    t2, s1, 2               # t2 = i * 4（int 占 4 字节）
    add     t2, sp, t2              # t2 = &a[i]
    sw      s2, 0(t2)               # a[i] = x

.Lmain_push:
    # ---- t = x + y; x = y; y = t; ----
    addw    s4, s2, s3              # t = x + y
    mv      s2, s3                  # x = y
    mv      s3, s4                  # y = t

    addiw   s1, s1, 1               # i = i + 1
    j       .Lmain_loop1

.Lmain_after1:
    # ---- putint(fib(5)); putch(10); ----
    li      a0, 5
    call    fib
    call    putint                  # fib 的结果已在 a0 中，直接传出
    li      a0, 10                  # 10 是换行符 '\n' 的 ASCII 码
    call    putch

    # ---- i = 0; ----
    li      s1, 0

    #=====================================================================
    # 第二个 while：统计数组中偶数之和（奇数按 1 计）
    #   while (i < 5) { if (a[i] % 2 == 0) sum += a[i]; else sum += 1; i++; }
    #=====================================================================
    li      t6, 5                   # 循环上界

.Lmain_loop2:
    bge     s1, t6, .Lmain_after2   # i >= 5，退出循环

    slli    t2, s1, 2
    add     t2, sp, t2              # t2 = &a[i]
    lw      t3, 0(t2)               # t3 = a[i]
    andi    t4, t3, 1               # t4 = a[i] & 1（最低位即奇偶标志）
    bnez    t4, .Lmain_odd          # 最低位非 0，是奇数

    addw    s5, s5, t3              # 偶数：sum = sum + a[i]
    j       .Lmain_next2

.Lmain_odd:
    addiw   s5, s5, 1               # 奇数：sum = sum + 1

.Lmain_next2:
    addiw   s1, s1, 1               # i = i + 1
    j       .Lmain_loop2

.Lmain_after2:
    # ---- putarray(5, a); putint(sum); putch(10); ----
    mv      a1, sp                  # 第二个参数：数组首地址
    li      a0, 5                   # 第一个参数：数组长度
    call    putarray
    mv      a0, s5
    call    putint
    li      a0, 10
    call    putch

    # ---- putint(calc(7, 3)); putch(10); ----
    li      a0, 7                   # 第一个参数
    li      a1, 3                   # 第二个参数
    call    calc
    call    putint
    li      a0, 10
    call    putch

    # ---- putint(calls); putch(10); ----
    lla     t0, calls
    lw      a0, 0(t0)               # 读取递归过程中累加的调用次数
    call    putint
    li      a0, 10
    call    putch

    # ---- return 0; ----
    li      a0, 0
    ld      ra, 72(sp)
    ld      s1, 64(sp)
    ld      s2, 56(sp)
    ld      s3, 48(sp)
    ld      s4, 40(sp)
    ld      s5, 32(sp)
    addi    sp, sp, 80
    jr      ra
    .size   main, .-main

    .ident  "RISC-V RV64GC assembly, handwritten"
    .section .note.GNU-stack,"",@progbits
