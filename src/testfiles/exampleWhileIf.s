	.text
	.include "printInteger.s"

#####################################################
# main: function() -> int
#####################################################
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $127, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__1 (= 0)  int a 
	movl $0, -4(%rbp)     # a = 0
#### main 1:  ASSIGN int const__1 (= 0)  int c 
	movl $0, -8(%rbp)     # c = 0
#### main 2:  ASSIGN int const__1 (= 0)  int x 
	movl $0, -12(%rbp)     # x = 0
#### main 3:  ASSIGN int a  int c 
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # c = a
#### main 4:  ASSIGN int a  int x 
	movl -4(%rbp), %r10d
	movl %r10d, -12(%rbp)     # x = a
#### main 5:  ASSIGN int const__2 (= 10)  int b 
	movl $10, -16(%rbp)     # b = 10
#### main 6:  ASSIGN int const__2 (= 10)  int d 
	movl $10, -20(%rbp)     # d = 10
#### main 7:  ASSIGN int b  int d 
	movl -16(%rbp), %r10d
	movl %r10d, -20(%rbp)     # d = b
#### main 8:  ASSIGN int const__6 (= 1)  int y 
	movl $1, -24(%rbp)     # y = 1
#### main 9:  ASSIGN int const__6 (= 1)  int z 
	movl $1, -28(%rbp)     # z = 1
#### main 10:  ASSIGN int y  int z 
	movl -24(%rbp), %r10d
	movl %r10d, -28(%rbp)     # z = y
main_11:
#### main 11:  IF_GREATER_OR_EQUAL int 10 int 1 20
	movl -4(%rbp), %r10d
	movl -16(%rbp), %r11d
	cmpl %r11d, %r10d
	jge main_20
main_12:
#### main 12:  IF_GREATER_OR_EQUAL int c int d 17
	movl -8(%rbp), %r10d
	movl -20(%rbp), %r11d
	cmpl %r11d, %r10d
	jge main_17
#### main 13:  PLUS int x int y int anon__1 
	# Math operation - Start: anon__1 = x addl y
	movl -12(%rbp), %r10d
	movl -24(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -32(%rbp)
	# Math operation - End: anon__1 = x addl y
#### main 14:  PLUS int anon__1 int z int x 
	# Math operation - Start: x = anon__1 addl z
	movl -32(%rbp), %r10d
	movl -28(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -12(%rbp)
	# Math operation - End: x = anon__1 addl z
#### main 15:  PLUS int c int const__8 (= 1) int c 
	# Math operation - Start: c = c addl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: c = c addl $1
#### main 16:  GOTO 12
	jmp main_12
main_17:
#### main 17:  ASSIGN int const__9 (= 0)  int c 
	movl $0, -8(%rbp)     # c = 0
#### main 18:  PLUS int 10 int const__10 (= 1) int 10 
	# Math operation - Start: 10 = 10 addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: 10 = 10 addl $1
#### main 19:  GOTO 11
	jmp main_11
main_20:
#### main 20:  WRITE char[35] const__11 (= 'ê')   
	movq $const__11, %rdi
	call printCharArray
#### main 21:  WRITE int x   
	movq $0, %rdi
	movl -12(%rbp), %edi
	call printInteger
#### main 22:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
	const__11: .asciz "The result should be 200 and is "  
