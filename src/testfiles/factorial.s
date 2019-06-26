	.text
	.include "printInteger.s"

#####################################################
# factorial: function(int) -> int
#####################################################
.type factorial, @function
factorial:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $32, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### factorial 0:  ASSIGN int const__1 (= 1)  int res 
	movl $1, -4(%rbp)     # res = 1
#### factorial 1:  ASSIGN int n  int factor 
	movq 16(%rbp), %r10
	movl %r10d, -8(%rbp)     # factor = n
factorial_2:
#### factorial 2:  IF_SMALLER_OR_EQUAL int factor int const__2 (= 1) 6
	movl -8(%rbp), %r10d
	movl $1, %r11d
	cmpl %r11d, %r10d
	jle factorial_6
#### factorial 3:  TIMES int res int factor int res 
	# Multiplication - Start: res = res x factor
	movl -4(%rbp), %eax
	movl -8(%rbp), %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: res = res x factor
#### factorial 4:  MINUS int factor int const__3 (= 1) int factor 
	# Math operation - Start: factor = factor subl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: factor = factor subl $1
#### factorial 5:  GOTO 2
	jmp factorial_2
factorial_6:
#### factorial 6:  RETURN int res   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -4(%rbp), %eax  # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# main: function() -> int
#####################################################
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $77, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__4 (= 0)  int i 
	movl $0, -4(%rbp)     # i = 0
main_1:
#### main 1:  IF_GREATER_OR_EQUAL int i int const__5 (= 10) 13
	movl -4(%rbp), %r10d
	movl $10, %r11d
	cmpl %r11d, %r10d
	jge main_13
#### main 2:  WRITE char[13] const__6 (= '0')   
	movq $const__6, %rdi
	call printCharArray
#### main 3:  WRITE int i   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 4:  WRITE char[7] const__7 (= 'Ð')   
	movq $const__7, %rdi
	call printCharArray
#### main 5:  PARAM int i   
	xor %r10, %r10
	movl -4(%rbp), %r10d
	pushq %r10
#### main 6:  CALL factorial: function(int) -> int   
	call factorial
#### main 7:  GETRETURN   int anon__3 
	movl %eax, -8(%rbp)
#### main 8:  WRITE int anon__3   
	movq $0, %rdi
	movl -8(%rbp), %edi
	call printInteger
#### main 9:  WRITE char[5] const__8 (= ' ')   
	movq $const__8, %rdi
	call printCharArray
#### main 10:  PLUS int i int const__9 (= 1) int anon__4 
	# Math operation - Start: anon__4 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -12(%rbp)
	# Math operation - End: anon__4 = i addl $1
#### main 11:  ASSIGN int anon__4  int i 
	movl -12(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__4
#### main 12:  GOTO 1
	jmp main_1
main_13:
#### main 13:  RETURN int const__10 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
	const__6: .asciz "factorial("  
	const__7: .asciz ") = "  
	const__8: .asciz "\n"  
