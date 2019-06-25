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
	sub $32, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
main_0:
#### main 0:  IF_GREATER_OR_EQUAL int a int b 4
	movl -4(%rbp), %r10d
	movl -8(%rbp), %r11d
	cmpl %r11d, %r10d
	jge main_4
#### main 1:  IF_GREATER_OR_EQUAL int c int d 0
	movl -12(%rbp), %r10d
	movl -16(%rbp), %r11d
	cmpl %r11d, %r10d
	jge main_0
#### main 2:  PLUS int y int z int x 
	# Math operation - Start: x = y addl z
	movl -20(%rbp), %r10d
	movl -24(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -28(%rbp)
	# Math operation - End: x = y addl z
#### main 3:  GOTO 0
	jmp main_0
main_4:
#### main 4:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
