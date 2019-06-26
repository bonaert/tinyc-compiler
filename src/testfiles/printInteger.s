	.file	"printInteger.c"
	.section	.rodata
.LC0:
	.string	"%d"
	.text
	.globl	printInteger
	.type	printInteger, @function
printInteger:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	nop
	leave
	ret
	.size	printInteger, .-printInteger
	.globl	printChar
	.type	printChar, @function
printChar:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	movsbl	-4(%rbp), %eax
	movl	%eax, %edi
	call	putchar
	nop
	leave
	ret
	.size	printChar, .-printChar
	.section	.rodata
.LC1:
	.string	"%s"
	.text
	.globl	printCharArray
	.type	printCharArray, @function
printCharArray:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	nop
	leave
	ret
	.size	printCharArray, .-printCharArray
	.section	.rodata
.LC2:
	.string	" %d"
	.text
	.globl	readInt
	.type	readInt, @function
readInt:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movl	%eax, -12(%rbp)
	cmpl	$0, -12(%rbp)
	jne	.L5
	nop
.L6:
	movq	stdin(%rip), %rax
	movq	%rax, %rdi
	call	fgetc
	cmpl	$10, %eax
	jne	.L6
.L5:
	movl	-16(%rbp), %eax
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L8
	call	__stack_chk_fail
.L8:
	leave
	ret
	.size	readInt, .-readInt
	.section	.rodata
.LC3:
	.string	" %c"
	.text
	.globl	readChar
	.type	readChar, @function
readChar:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-9(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movzbl	-9(%rbp), %eax
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L11
	call	__stack_chk_fail
.L11:
	leave
	ret
	.size	readChar, .-readChar
	