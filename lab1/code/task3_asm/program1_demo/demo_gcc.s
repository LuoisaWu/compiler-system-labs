	.file	"demo.c"
	.option pic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	N
	.section	.rodata
	.align	2
	.type	N, @object
	.size	N, 4
N:
	.word	8
	.globl	calls
	.bss
	.align	2
	.type	calls, @object
	.size	calls, 4
calls:
	.zero	4
	.text
	.align	1
	.globl	fib
	.type	fib, @function
fib:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-48
	.cfi_def_cfa_offset 48
	sd	ra,40(sp)
	sd	s0,32(sp)
	sd	s1,24(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	.cfi_offset 9, -24
	addi	s0,sp,48
	.cfi_def_cfa 8, 0
	mv	a5,a0
	sw	a5,-36(s0)
	lw	a5,-36(s0)
	sext.w	a4,a5
	li	a5,1
	bgt	a4,a5,.L2
	lw	a5,-36(s0)
	j	.L3
.L2:
	lla	a5,calls
	lw	a5,0(a5)
	addiw	a5,a5,1
	sext.w	a4,a5
	lla	a5,calls
	sw	a4,0(a5)
	lw	a5,-36(s0)
	addiw	a5,a5,-1
	sext.w	a5,a5
	mv	a0,a5
	call	fib
	mv	a5,a0
	mv	s1,a5
	lw	a5,-36(s0)
	addiw	a5,a5,-2
	sext.w	a5,a5
	mv	a0,a5
	call	fib
	mv	a5,a0
	addw	a5,s1,a5
	sext.w	a5,a5
.L3:
	mv	a0,a5
	ld	ra,40(sp)
	.cfi_restore 1
	ld	s0,32(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 48
	ld	s1,24(sp)
	.cfi_restore 9
	addi	sp,sp,48
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	fib, .-fib
	.align	1
	.globl	calc
	.type	calc, @function
calc:
.LFB1:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	ra,24(sp)
	sd	s0,16(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	mv	a5,a0
	mv	a4,a1
	sw	a5,-20(s0)
	mv	a5,a4
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	mv	a4,a5
	lw	a5,-24(s0)
	addw	a5,a4,a5
	sext.w	a4,a5
	lw	a5,-20(s0)
	mv	a3,a5
	lw	a5,-24(s0)
	subw	a5,a3,a5
	sext.w	a5,a5
	mulw	a5,a4,a5
	sext.w	a5,a5
	lw	a4,-24(s0)
	divw	a5,a5,a4
	sext.w	a4,a5
	lw	a5,-20(s0)
	mv	a3,a5
	lw	a5,-24(s0)
	remw	a5,a3,a5
	sext.w	a5,a5
	addw	a5,a4,a5
	sext.w	a5,a5
	mv	a0,a5
	ld	ra,24(sp)
	.cfi_restore 1
	ld	s0,16(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 32
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE1:
	.size	calc, .-calc
	.section	.rodata
	.align	3
.LC0:
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	addi	sp,sp,-64
	.cfi_def_cfa_offset 64
	sd	ra,56(sp)
	sd	s0,48(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,64
	.cfi_def_cfa 8, 0
	lla	a5,.LC0
	ld	a4,0(a5)
	sd	a4,-56(s0)
	ld	a4,8(a5)
	sd	a4,-48(s0)
	lw	a5,16(a5)
	sw	a5,-40(s0)
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	li	a5,1
	sw	a5,-28(s0)
	sw	zero,-32(s0)
	j	.L7
.L9:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,4
	bgt	a4,a5,.L8
	lw	a4,-20(s0)
	addi	a5,s0,-56
	slli	a4,a4,2
	add	a5,a4,a5
	lw	a4,-24(s0)
	sw	a4,0(a5)
.L8:
	lw	a5,-24(s0)
	mv	a4,a5
	lw	a5,-28(s0)
	addw	a5,a4,a5
	sw	a5,-36(s0)
	lw	a5,-28(s0)
	sw	a5,-24(s0)
	lw	a5,-36(s0)
	sw	a5,-28(s0)
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L7:
	li	a5,8
	lw	a4,-20(s0)
	sext.w	a4,a4
	blt	a4,a5,.L9
	li	a0,5
	call	fib
	mv	a5,a0
	mv	a0,a5
	call	putint@plt
	li	a0,10
	call	putch@plt
	sw	zero,-20(s0)
	j	.L10
.L13:
	lw	a4,-20(s0)
	addi	a5,s0,-56
	slli	a4,a4,2
	add	a5,a4,a5
	lw	a5,0(a5)
	andi	a5,a5,1
	sext.w	a5,a5
	bne	a5,zero,.L11
	lw	a4,-20(s0)
	addi	a5,s0,-56
	slli	a4,a4,2
	add	a5,a4,a5
	lw	a5,0(a5)
	lw	a4,-32(s0)
	addw	a5,a4,a5
	sw	a5,-32(s0)
	j	.L12
.L11:
	lw	a5,-32(s0)
	addiw	a5,a5,1
	sw	a5,-32(s0)
.L12:
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L10:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,4
	ble	a4,a5,.L13
	addi	a5,s0,-56
	mv	a1,a5
	li	a0,5
	call	putarray@plt
	lw	a5,-32(s0)
	mv	a0,a5
	call	putint@plt
	li	a0,10
	call	putch@plt
	li	a1,3
	li	a0,7
	call	calc
	mv	a5,a0
	mv	a0,a5
	call	putint@plt
	li	a0,10
	call	putch@plt
	lla	a5,calls
	lw	a5,0(a5)
	mv	a0,a5
	call	putint@plt
	li	a0,10
	call	putch@plt
	li	a5,0
	mv	a0,a5
	ld	ra,56(sp)
	.cfi_restore 1
	ld	s0,48(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 64
	addi	sp,sp,64
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
