	.text
	.include "printInteger.s"
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $0, -4(%rbp)     # a = $0
	movb $48, -5(%rbp)     # c = $48
	mov %rbp, %rsp
	sub $5, %rsp
	call readChar
	movb %al, -5(%rbp)
	mov %rbp, %rsp
	sub $5, %rsp
	movq $0, %rdi
	movl -5(%rbp), %edi
	call printChar
	mov %rbp, %rsp
	sub $5, %rsp
	call readInt
	movl %eax, -4(%rbp)
	mov %rbp, %rsp
	sub $5, %rsp
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
