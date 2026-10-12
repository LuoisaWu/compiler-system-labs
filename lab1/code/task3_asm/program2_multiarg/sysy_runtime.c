#include <stdio.h>

/* SysY 运行时库的简易实现，仅用于本地验证汇编程序 */

int getint() { int x; scanf("%d", &x); return x; }
int getch() { return getchar(); }
int getarray(int a[]) {
    int n;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) scanf("%d", &a[i]);
    return n;
}

void putint(int a) { printf("%d", a); }
void putch(int a) { putchar(a); }
void putarray(int n, int a[]) {
    printf("%d:", n);
    for (int i = 0; i < n; i++) printf(" %d", a[i]);
    printf("\n");
}
