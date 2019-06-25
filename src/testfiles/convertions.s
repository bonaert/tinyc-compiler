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
	sub $30, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__1 (= 65)  int c 
	movl $65, -4(%rbp)     # c = 65
#### main 1:  WRITE int c   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 2:  WRITE char const__2 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 3:  ASSIGN int c  char d 
	movb -4(%rbp), %r10b
	movb %r10b, -5(%rbp)     # d = c
#### main 4:  WRITE char d   
	movq $0, %r10   # Empty register 
	movb -5(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 5:  WRITE char const__3 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 6:  ASSIGN char d  int e 
	movq $0, %r10     # Empty register
	movb -5(%rbp), %r10b
	movl %r10d, -9(%rbp)     # e = d
#### main 7:  WRITE int e   
	movq $0, %rdi
	movl -9(%rbp), %edi
	call printInteger
#### main 8:  WRITE char const__4 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 9:  ASSIGN int const__7 (= 321)  int x 
	movl $321, -13(%rbp)     # x = 321
#### main 10:  WRITE int x   
	movq $0, %rdi
	movl -13(%rbp), %edi
	call printInteger
#### main 11:  WRITE char const__8 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 12:  ASSIGN int x  char y 
	movb -13(%rbp), %r10b
	movb %r10b, -14(%rbp)     # y = x
#### main 13:  WRITE char y   
	movq $0, %r10   # Empty register 
	movb -14(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 14:  WRITE char const__9 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 15:  ASSIGN char y  int z 
	movq $0, %r10     # Empty register
	movb -14(%rbp), %r10b
	movl %r10d, -18(%rbp)     # z = y
#### main 16:  WRITE int z   
	movq $0, %rdi
	movl -18(%rbp), %edi
	call printInteger
#### main 17:  WRITE char const__10 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 18:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
