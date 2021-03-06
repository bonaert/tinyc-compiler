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
	sub $124, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__1 (= 0)  int a 
	movl $0, -4(%rbp)     # a = 0
#### main 1:  ASSIGN char const__2 (= '0')  char c 
	movb $48, -5(%rbp)     # c = 48
#### main 2:  WRITE char[24] const__3 (= '�')   
	movq $const__3, %rdi
	call printCharArray
#### main 3:  READ char c   
	call readChar
	movb %al, -5(%rbp)
#### main 4:  WRITE char[9] const__4 (= ' ')   
	movq $const__4, %rdi
	call printCharArray
#### main 5:  WRITE char c   
	movq $0, %r10   # Empty register 
	movb -5(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 6:  WRITE char[5] const__5 (= '�')   
	movq $const__5, %rdi
	call printCharArray
#### main 7:  WRITE char[28] const__6 (= '�')   
	movq $const__6, %rdi
	call printCharArray
#### main 8:  READ int a   
	call readInt
	movl %eax, -4(%rbp)
#### main 9:  WRITE char[9] const__7 (= 'P')   
	movq $const__7, %rdi
	call printCharArray
#### main 10:  WRITE int a   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 11:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
	const__3: .asciz "Please write a char: "  
	const__4: .asciz "Read: "  
	const__5: .asciz "\n"  
	const__6: .asciz "Please write an integer: "  
	const__7: .asciz "Read: "  
