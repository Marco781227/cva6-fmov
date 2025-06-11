	.file	"fmov.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	write_reg_u8
	.type	write_reg_u8, @function
write_reg_u8:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	mv	a5,a1
	sb	a5,-37(s0)
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	lbu	a4,-37(s0)
	sb	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	write_reg_u8, .-write_reg_u8
	.align	1
	.globl	read_reg_u8
	.type	read_reg_u8, @function
read_reg_u8:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	andi	a5,a5,0xff
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	read_reg_u8, .-read_reg_u8
	.align	1
	.globl	is_transmit_empty
	.type	is_transmit_empty, @function
is_transmit_empty:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a5,268435456
	addi	a0,a5,20
	call	read_reg_u8
	mv	a5,a0
	andi	a5,a5,32
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	is_transmit_empty, .-is_transmit_empty
	.align	1
	.globl	write_serial
	.type	write_serial, @function
write_serial:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sb	a5,-17(s0)
	nop
.L7:
	call	is_transmit_empty
	mv	a5,a0
	beq	a5,zero,.L7
	lbu	a5,-17(s0)
	mv	a1,a5
	li	a0,268435456
	call	write_reg_u8
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	write_serial, .-write_serial
	.align	1
	.globl	init_uart
	.type	init_uart, @function
init_uart:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-40(s0)
	slli	a5,a5,4
	lw	a4,-36(s0)
	divu	a5,a4,a5
	sw	a5,-20(s0)
	li	a1,0
	li	a5,268435456
	addi	a0,a5,4
	call	write_reg_u8
	li	a1,128
	li	a5,268435456
	addi	a0,a5,12
	call	write_reg_u8
	lw	a5,-20(s0)
	andi	a5,a5,0xff
	mv	a1,a5
	li	a0,268435456
	call	write_reg_u8
	lw	a5,-20(s0)
	srli	a5,a5,8
	andi	a5,a5,0xff
	mv	a1,a5
	li	a5,268435456
	addi	a0,a5,4
	call	write_reg_u8
	li	a1,3
	li	a5,268435456
	addi	a0,a5,12
	call	write_reg_u8
	li	a1,199
	li	a5,268435456
	addi	a0,a5,8
	call	write_reg_u8
	li	a1,32
	li	a5,268435456
	addi	a0,a5,16
	call	write_reg_u8
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	init_uart, .-init_uart
	.align	1
	.globl	print_uart
	.type	print_uart, @function
print_uart:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L10
.L11:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	mv	a0,a5
	call	write_serial
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L10:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	bne	a5,zero,.L11
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	print_uart, .-print_uart
	.globl	bin_to_hex_table
	.data
	.align	2
	.type	bin_to_hex_table, @object
	.size	bin_to_hex_table, 16
bin_to_hex_table:
	.ascii	"0123456789ABCDEF"
	.text
	.align	1
	.globl	bin_to_hex
	.type	bin_to_hex, @function
bin_to_hex:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	mv	a5,a0
	sw	a1,-24(s0)
	sb	a5,-17(s0)
	lbu	a5,-17(s0)
	andi	a4,a5,15
	lw	a5,-24(s0)
	addi	a5,a5,1
	lui	a3,%hi(bin_to_hex_table)
	addi	a3,a3,%lo(bin_to_hex_table)
	add	a4,a3,a4
	lbu	a4,0(a4)
	sb	a4,0(a5)
	lbu	a5,-17(s0)
	srli	a5,a5,4
	andi	a5,a5,0xff
	andi	a5,a5,15
	lui	a4,%hi(bin_to_hex_table)
	addi	a4,a4,%lo(bin_to_hex_table)
	add	a5,a4,a5
	lbu	a4,0(a5)
	lw	a5,-24(s0)
	sb	a4,0(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	bin_to_hex, .-bin_to_hex
	.align	1
	.globl	print_uart_int
	.type	print_uart_int, @function
print_uart_int:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	li	a5,3
	sw	a5,-20(s0)
	j	.L15
.L16:
	lw	a5,-20(s0)
	slli	a5,a5,3
	lw	a4,-36(s0)
	srl	a5,a4,a5
	sb	a5,-21(s0)
	addi	a4,s0,-24
	lbu	a5,-21(s0)
	mv	a1,a4
	mv	a0,a5
	call	bin_to_hex
	lbu	a5,-24(s0)
	mv	a0,a5
	call	write_serial
	lbu	a5,-23(s0)
	mv	a0,a5
	call	write_serial
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-20(s0)
.L15:
	lw	a5,-20(s0)
	bge	a5,zero,.L16
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	print_uart_int, .-print_uart_int
	.align	1
	.globl	print_uart_addr
	.type	print_uart_addr, @function
print_uart_addr:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s2,36(sp)
	sw	s3,32(sp)
	addi	s0,sp,48
	sw	a0,-40(s0)
	sw	a1,-36(s0)
	li	a5,7
	sw	a5,-20(s0)
	j	.L18
.L21:
	lw	a5,-20(s0)
	slli	a5,a5,3
	addi	a4,a5,-32
	blt	a4,zero,.L19
	lw	a5,-36(s0)
	srl	s2,a5,a4
	li	s3,0
	j	.L20
.L19:
	lw	a4,-36(s0)
	slli	a3,a4,1
	li	a4,31
	sub	a4,a4,a5
	sll	a4,a3,a4
	lw	a3,-40(s0)
	srl	s2,a3,a5
	or	s2,a4,s2
	lw	a4,-36(s0)
	srl	s3,a4,a5
.L20:
	sb	s2,-21(s0)
	addi	a4,s0,-24
	lbu	a5,-21(s0)
	mv	a1,a4
	mv	a0,a5
	call	bin_to_hex
	lbu	a5,-24(s0)
	mv	a0,a5
	call	write_serial
	lbu	a5,-23(s0)
	mv	a0,a5
	call	write_serial
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-20(s0)
.L18:
	lw	a5,-20(s0)
	bge	a5,zero,.L21
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s2,36(sp)
	lw	s3,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	print_uart_addr, .-print_uart_addr
	.align	1
	.globl	print_uart_byte
	.type	print_uart_byte, @function
print_uart_byte:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sb	a5,-33(s0)
	addi	a4,s0,-20
	lbu	a5,-33(s0)
	mv	a1,a4
	mv	a0,a5
	call	bin_to_hex
	lbu	a5,-20(s0)
	mv	a0,a5
	call	write_serial
	lbu	a5,-19(s0)
	mv	a0,a5
	call	write_serial
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	print_uart_byte, .-print_uart_byte
	.section	.rodata
	.align	2
.LC0:
	.string	"R\303\251sultat FMOV : 0x"
	.align	2
.LC1:
	.string	"\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
 #APP
# 112 "fmov.c" 1
	lui t0, 6
lui t1, 8
sub t2, t1, t0
fmv.w.x f1, t0
.word 0xE3D3F10B
fmv.x.w a5, f2

# 0 "" 2
 #NO_APP
	sw	a5,-20(s0)
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	print_uart
	lw	a0,-20(s0)
	call	print_uart_int
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	print_uart
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 13.1.0"
