	.text
	.include "printInteger.s"

#####################################################
# fibonacci: function(int) -> int
#####################################################
.type fibonacci, @function
fibonacci:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $40, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### fibonacci 0:  IF_GREATER_OR_EQUAL int n int const__1 (= 2) 3
	movq 16(%rbp), %r10
	movl $2, %r11d
	cmpl %r11d, %r10d
	jge fibonacci_3
#### fibonacci 1:  RETURN int const__2 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
#### fibonacci 2:  GOTO 13
	jmp fibonacci_13
fibonacci_3:
#### fibonacci 3:  MINUS int n int const__3 (= 1) int anon__1 
	# Math operation - Start: anon__1 = n subl $1
	movq 16(%rbp), %r10
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: anon__1 = n subl $1
#### fibonacci 4:  PARAM int anon__1   
	xor %r10, %r10
	movl -4(%rbp), %r10d
	pushq %r10
#### fibonacci 5:  CALL fibonacci: function(int) -> int   
	call fibonacci
#### fibonacci 6:  GETRETURN   int anon__2 
	movl %eax, -8(%rbp)
#### fibonacci 7:  MINUS int n int const__4 (= 2) int anon__3 
	# Math operation - Start: anon__3 = n subl $2
	movq 16(%rbp), %r10
	movl $2, %r11d
	subl %r11d, %r10d
	movl %r10d, -12(%rbp)
	# Math operation - End: anon__3 = n subl $2
#### fibonacci 8:  PARAM int anon__3   
	xor %r10, %r10
	movl -12(%rbp), %r10d
	pushq %r10
#### fibonacci 9:  CALL fibonacci: function(int) -> int   
	call fibonacci
#### fibonacci 10:  GETRETURN   int anon__4 
	movl %eax, -16(%rbp)
#### fibonacci 11:  PLUS int anon__2 int anon__4 int anon__5 
	# Math operation - Start: anon__5 = anon__2 addl anon__4
	movl -8(%rbp), %r10d
	movl -16(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -20(%rbp)
	# Math operation - End: anon__5 = anon__2 addl anon__4
#### fibonacci 12:  RETURN int anon__5   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -20(%rbp), %eax  # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
fibonacci_13:
#### fibonacci 13:  RETURN    
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
#### main 0:  ASSIGN int const__5 (= 0)  int i 
	movl $0, -4(%rbp)     # i = 0
main_1:
#### main 1:  IF_GREATER_OR_EQUAL int i int const__6 (= 10) 13
	movl -4(%rbp), %r10d
	movl $10, %r11d
	cmpl %r11d, %r10d
	jge main_13
#### main 2:  WRITE char[13] const__7 (= ' ')   
	movq $const__7, %rdi
	call printCharArray
#### main 3:  WRITE int i   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 4:  WRITE char[7] const__8 (= ' ')   
	movq $const__8, %rdi
	call printCharArray
#### main 5:  PARAM int i   
	xor %r10, %r10
	movl -4(%rbp), %r10d
	pushq %r10
#### main 6:  CALL fibonacci: function(int) -> int   
	call fibonacci
#### main 7:  GETRETURN   int anon__6 
	movl %eax, -8(%rbp)
#### main 8:  WRITE int anon__6   
	movq $0, %rdi
	movl -8(%rbp), %edi
	call printInteger
#### main 9:  WRITE char[5] const__9 (= 'p')   
	movq $const__9, %rdi
	call printCharArray
#### main 10:  PLUS int i int const__10 (= 1) int anon__7 
	# Math operation - Start: anon__7 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -12(%rbp)
	# Math operation - End: anon__7 = i addl $1
#### main 11:  ASSIGN int anon__7  int i 
	movl -12(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__7
#### main 12:  GOTO 1
	jmp main_1
main_13:
#### main 13:  RETURN int const__11 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
	const__7: .asciz "fibonacci("  
	const__8: .asciz ") = "  
	const__9: .asciz "\n"  
