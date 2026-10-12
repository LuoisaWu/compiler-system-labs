#include "sysy.h"

/* 程序二：参数超过 8 个的 SysY 函数
 *
 * RISC-V 只有 a0~a7 八个参数寄存器。凡是参数多于 8 个的函数，第 9 个及其后的参数都必须由调用者放在自己栈帧的最低端，被调函数再按约定取回。
 */

/* 10 个参数：a~h 走寄存器，i、j 走栈。纯计算，不再调用其它函数。 */
int mix(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j) {
    return (a - j) * (b - i) + (c - h) * (d - g) + e * f;
}

int chain(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j) {
    return mix(j, i, h, g, f, e, d, c, b, a) + a * b + i * j;
}

int main() {
    putint(mix(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));     
    putch(10);
    putint(chain(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));   
    putch(10);

    int k = 0;
    int s = 0;
    while (k < 5) {
        s = s + mix(k, k + 1, k + 2, k + 3, k + 4, k + 5, k + 6, k + 7, k + 8, k + 9);
        k = k + 1;
    }
    putint(s);                                      
    putch(10);

    return 0;
}
