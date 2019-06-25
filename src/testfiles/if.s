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
	sub $64, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__1 (= 0)  int zero 
	movl $0, -4(%rbp)     # zero = 0
#### main 1:  ASSIGN int const__2 (= 1254)  int nonzero 
	movl $1254, -8(%rbp)     # nonzero = 1254
#### main 2:  IF_NOT_EQUAL int zero int const__4 (= 10) 5
	movl -4(%rbp), %r10d
	movl $10, %r11d
	cmpl %r11d, %r10d
	jne main_5
#### main 3:  WRITE char const__5 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
#### main 4:  GOTO 6
	jmp main_6
main_5:
#### main 5:  WRITE char const__6 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
main_6:
#### main 6:  IF_EQUAL int const__7 (= 0) int const__8 (= 10) 9
#### main 7:  WRITE char const__9 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
#### main 8:  GOTO 10
	jmp main_10
main_9:
#### main 9:  WRITE char const__10 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
main_10:
#### main 10:  WRITE char const__11 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 11:  IF_SMALLER_OR_EQUAL int const__12 (= 0) int const__13 (= 10) 14
	jmp main_14
#### main 12:  WRITE char const__14 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
#### main 13:  GOTO 15
	jmp main_15
main_14:
#### main 14:  WRITE char const__15 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
main_15:
#### main 15:  IF_SMALLER int const__16 (= 0) int const__17 (= 10) 18
	jmp main_18
#### main 16:  WRITE char const__18 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
#### main 17:  GOTO 19
	jmp main_19
main_18:
#### main 18:  WRITE char const__19 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
main_19:
#### main 19:  WRITE char const__20 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 20:  IF_GREATER_OR_EQUAL int const__21 (= 0) int const__22 (= 10) 23
#### main 21:  WRITE char const__23 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
#### main 22:  GOTO 24
	jmp main_24
main_23:
#### main 23:  WRITE char const__24 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
main_24:
#### main 24:  IF_GREATER int const__25 (= 0) int const__26 (= 10) 27
#### main 25:  WRITE char const__27 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
#### main 26:  GOTO 28
	jmp main_28
main_27:
#### main 27:  WRITE char const__28 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
main_28:
#### main 28:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
