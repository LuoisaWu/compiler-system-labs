	.file	"manyargs.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	mix
	.type	mix, @function
mix:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-48
	.cfi_def_cfa_offset 48
	sd	ra,40(sp)
	sd	s0,32(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,48
	.cfi_def_cfa 8, 0
	mv	t4,a0
	mv	t3,a1
	mv	t1,a2
	mv	a0,a3
	mv	a1,a4
	mv	a2,a5
	mv	a3,a6
	mv	a4,a7
	mv	a5,t4
	sw	a5,-20(s0)
	mv	a5,t3
	sw	a5,-24(s0)
	mv	a5,t1
	sw	a5,-28(s0)
	mv	a5,a0
	sw	a5,-32(s0)
	mv	a5,a1
	sw	a5,-36(s0)
	mv	a5,a2
	sw	a5,-40(s0)
	mv	a5,a3
	sw	a5,-44(s0)
	mv	a5,a4
	sw	a5,-48(s0)
	lw	a5,-20(s0)
	mv	a4,a5
	lw	a5,8(s0)
	subw	a5,a4,a5
	sext.w	a4,a5
	lw	a5,-24(s0)
	mv	a3,a5
	lw	a5,0(s0)
	subw	a5,a3,a5
	sext.w	a5,a5
	mulw	a5,a4,a5
	sext.w	a4,a5
	lw	a5,-28(s0)
	mv	a3,a5
	lw	a5,-48(s0)
	subw	a5,a3,a5
	sext.w	a3,a5
	lw	a5,-32(s0)
	mv	a2,a5
	lw	a5,-44(s0)
	subw	a5,a2,a5
	sext.w	a5,a5
	mulw	a5,a3,a5
	sext.w	a5,a5
	addw	a5,a4,a5
	sext.w	a4,a5
	lw	a5,-36(s0)
	mv	a3,a5
	lw	a5,-40(s0)
	mulw	a5,a3,a5
	sext.w	a5,a5
	addw	a5,a4,a5
	sext.w	a5,a5
	mv	a0,a5
	ld	ra,40(sp)
	.cfi_restore 1
	ld	s0,32(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 48
	addi	sp,sp,48
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	mix, .-mix
	.align	1
	.globl	chain
	.type	chain, @function
chain:
.LFB1:
	.cfi_startproc
	addi	sp,sp,-64
	.cfi_def_cfa_offset 64
	sd	ra,56(sp)
	sd	s0,48(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,64
	.cfi_def_cfa 8, 0
	mv	t4,a0
	mv	t3,a1
	mv	t1,a2
	mv	a0,a3
	mv	a1,a4
	mv	a2,a5
	mv	a3,a6
	mv	a4,a7
	mv	a5,t4
	sw	a5,-20(s0)
	mv	a5,t3
	sw	a5,-24(s0)
	mv	a5,t1
	sw	a5,-28(s0)
	mv	a5,a0
	sw	a5,-32(s0)
	mv	a5,a1
	sw	a5,-36(s0)
	mv	a5,a2
	sw	a5,-40(s0)
	mv	a5,a3
	sw	a5,-44(s0)
	mv	a5,a4
	sw	a5,-48(s0)
	lw	a7,-28(s0)
	lw	a6,-32(s0)
	lw	t1,-36(s0)
	lw	a4,-40(s0)
	lw	a3,-44(s0)
	lw	a2,-48(s0)
	lw	a1,0(s0)
	lw	a0,8(s0)
	lw	a5,-20(s0)
	sd	a5,8(sp)
	lw	a5,-24(s0)
	sd	a5,0(sp)
	mv	a5,t1
	call	mix
	mv	a5,a0
	mv	a4,a5
	lw	a5,-20(s0)
	mv	a3,a5
	lw	a5,-24(s0)
	mulw	a5,a3,a5
	sext.w	a5,a5
	addw	a5,a4,a5
	sext.w	a4,a5
	lw	a5,0(s0)
	mv	a3,a5
	lw	a5,8(s0)
	mulw	a5,a3,a5
	sext.w	a5,a5
	addw	a5,a4,a5
	sext.w	a5,a5
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
.LFE1:
	.size	chain, .-chain
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	addi	sp,sp,-48
	.cfi_def_cfa_offset 48
	sd	ra,40(sp)
	sd	s0,32(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,48
	.cfi_def_cfa 8, 0
	li	a5,10
	sd	a5,8(sp)
	li	a5,9
	sd	a5,0(sp)
	li	a7,8
	li	a6,7
	li	a5,6
	li	a4,5
	li	a3,4
	li	a2,3
	li	a1,2
	li	a0,1
	call	mix
	mv	a5,a0
	mv	a0,a5
	call	putint
	li	a0,10
	call	putch
	li	a5,10
	sd	a5,8(sp)
	li	a5,9
	sd	a5,0(sp)
	li	a7,8
	li	a6,7
	li	a5,6
	li	a4,5
	li	a3,4
	li	a2,3
	li	a1,2
	li	a0,1
	call	chain
	mv	a5,a0
	mv	a0,a5
	call	putint
	li	a0,10
	call	putch
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	j	.L6
.L7:
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sext.w	a1,a5
	lw	a5,-20(s0)
	addiw	a5,a5,2
	sext.w	a2,a5
	lw	a5,-20(s0)
	addiw	a5,a5,3
	sext.w	a3,a5
	lw	a5,-20(s0)
	addiw	a5,a5,4
	sext.w	t1,a5
	lw	a5,-20(s0)
	addiw	a5,a5,5
	sext.w	t3,a5
	lw	a5,-20(s0)
	addiw	a5,a5,6
	sext.w	a6,a5
	lw	a5,-20(s0)
	addiw	a5,a5,7
	sext.w	a7,a5
	lw	a5,-20(s0)
	addiw	a5,a5,8
	sext.w	a5,a5
	lw	a4,-20(s0)
	addiw	a4,a4,9
	sext.w	a4,a4
	lw	a0,-20(s0)
	sd	a4,8(sp)
	sd	a5,0(sp)
	mv	a5,t3
	mv	a4,t1
	call	mix
	mv	a5,a0
	lw	a4,-24(s0)
	addw	a5,a4,a5
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L6:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,4
	ble	a4,a5,.L7
	lw	a5,-24(s0)
	mv	a0,a5
	call	putint
	li	a0,10
	call	putch
	li	a5,0
	mv	a0,a5
	ld	ra,40(sp)
	.cfi_restore 1
	ld	s0,32(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 48
	addi	sp,sp,48
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
