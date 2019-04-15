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
