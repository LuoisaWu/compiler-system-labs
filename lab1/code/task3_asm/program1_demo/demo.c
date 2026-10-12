#include "sysy.h"

const int N = 8;
int calls = 0;

int fib(int n) {
    if (n <= 1)
        return n;
    calls = calls + 1;
    return fib(n - 1) + fib(n - 2);
}

int calc(int a, int b) {
    return (a + b) * (a - b) / b + a % b;
}

int main() {
    int a[5] = {1, 2, 3, 4, 5};
    int i = 0, x = 0, y = 1, t, sum = 0;

    while (i < N) {
        if (i < 5)
            a[i] = x;
        t = x + y;
        x = y;
        y = t;
        i = i + 1;
    }

    putint(fib(5));
    putch(10);

    i = 0;
    while (i < 5) {
        if (a[i] % 2 == 0)
            sum = sum + a[i];
        else
            sum = sum + 1;
        i = i + 1;
    }

    putarray(5, a);
    putint(sum);
    putch(10);
    putint(calc(7, 3));
    putch(10);
    putint(calls);
    putch(10);

    return 0;
}
