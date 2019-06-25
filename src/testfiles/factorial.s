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
	sub $12, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  PARAM int const__4 (= 10)   
	pushq $10
#### main 1:  CALL factorial: function(int) -> int   
	call factorial
#### main 2:  GETRETURN   int anon__3 
	movl %eax, -4(%rbp)
#### main 3:  ASSIGN int anon__3  int b 
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # b = anon__3
#### main 4:  WRITE int b   
	movq $0, %rdi
	movl -8(%rbp), %edi
	call printInteger
#### main 5:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
