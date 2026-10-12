#ifndef SYSY_H
#define SYSY_H

/* SysY 运行时库函数声明 */

/* 输入 */
int getint();
int getch();
int getarray(int a[]);
float getfloat();
int getfarray(float a[]);

/* 输出 */
void putint(int a);
void putch(int a);
void putarray(int n, int a[]);
void putfloat(float a);
void putfarray(int n, float a[]);

/* 计时 */
void starttime();
void stoptime();

#endif
