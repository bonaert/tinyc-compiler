	.file	"basic.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$5, -4(%rbp)    # i = 5
	cmpl	$5, -4(%rbp)    # if (i == 5)
	jne	.L2
	movl	-4(%rbp), %eax  # i = i + i
	addl	%eax, %eax      # i = i + i
	movl	%eax, -4(%rbp)  # i = i + i
.L2:
	movl	$7, -4(%rbp)    # i = 7
	movl	-4(%rbp), %eax  
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.11) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
