	.text
	.include "printInteger.s"

#####################################################
# foo: function(int,int) -> int
#####################################################
.type foo, @function
foo:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $12, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### foo 0:  RETURN int const__1 (= 5)   
	movq $5, %rax
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
	sub $393, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__2 (= 5)  int i 
	movl $5, -4(%rbp)     # i = 5
#### main 1:  IF_NOT_EQUAL int i int i 3
	movl -4(%rbp), %r10d
	movl -4(%rbp), %r11d
	cmpl %r11d, %r10d
	jne main_3
#### main 2:  PLUS int i int const__4 (= 1) int i 
	# Math operation - Start: i = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: i = i addl $1
main_3:
#### main 3:  ASSIGN int const__5 (= 7)  int i 
	movl $7, -4(%rbp)     # i = 7
#### main 4:  PARAM int const__6 (= 5)   
	pushq $5
#### main 5:  PARAM int const__7 (= 7)   
	pushq $7
#### main 6:  CALL foo: function(int,int) -> int   
	call foo
#### main 7:  GETRETURN   int anon__2 
	movl %eax, -8(%rbp)
#### main 8:  ASSIGN int anon__2  int c 
	movl -8(%rbp), %r10d
	movl %r10d, -12(%rbp)     # c = anon__2
#### main 9:  WRITE int c   
	movq $0, %rdi
	movl -12(%rbp), %edi
	call printInteger
#### main 10:  TIMES int const__8 (= 0) int const__10 (= 5) int anon__3 
	# Multiplication - Start: anon__3 = $0 x $5
	movl $0, %eax
	movl $5, %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__3 = $0 x $5
#### main 11:  PLUS int anon__3 int const__9 (= 1) int anon__3 
	# Math operation - Start: anon__3 = anon__3 addl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__3 = anon__3 addl $1
#### main 12:  TIMES int anon__3 int const__12 (= 7) int anon__4 
	# Multiplication - Start: anon__4 = anon__3 x $7
	movl -16(%rbp), %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -20(%rbp)
	# Multiplication - End: anon__4 = anon__3 x $7
#### main 13:  PLUS int anon__4 int const__11 (= 2) int anon__4 
	# Math operation - Start: anon__4 = anon__4 addl $2
	movl -20(%rbp), %r10d
	movl $2, %r11d
	addl %r11d, %r10d
	movl %r10d, -20(%rbp)
	# Math operation - End: anon__4 = anon__4 addl $2
#### main 14:  GET_ADDRESS char[5][7][8] array  address anon__6 
	movq %rbp, -308(%rbp)     # Setting up array address
	addq $-308, -308(%rbp)      # Setting up array address
	movq -308(%rbp), %r10
	movq %r10, -316(%rbp)
#### main 15:  TIMES int anon__4 int const__13 (= 1) int anon__5 
	# Multiplication - Start: anon__5 = anon__4 x $1
	movl -20(%rbp), %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -320(%rbp)
	# Multiplication - End: anon__5 = anon__4 x $1
#### main 16:  ARRAY MODIFICATION address anon__6 int anon__5 char const__14 (= 'b') 
## Array modification START - anon__6[anon__5] = $98
	movq -316(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -320(%rbp), %r11d
	movq  $98, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__6[anon__5] = $98
#### main 17:  TIMES int const__15 (= 0) int const__17 (= 5) int anon__7 
	# Multiplication - Start: anon__7 = $0 x $5
	movl $0, %eax
	movl $5, %r10d
	imull %r10d
	movl %eax, -324(%rbp)
	# Multiplication - End: anon__7 = $0 x $5
#### main 18:  PLUS int anon__7 int const__16 (= 1) int anon__7 
	# Math operation - Start: anon__7 = anon__7 addl $1
	movl -324(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -324(%rbp)
	# Math operation - End: anon__7 = anon__7 addl $1
#### main 19:  TIMES int anon__7 int const__19 (= 7) int anon__8 
	# Multiplication - Start: anon__8 = anon__7 x $7
	movl -324(%rbp), %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -328(%rbp)
	# Multiplication - End: anon__8 = anon__7 x $7
#### main 20:  PLUS int anon__8 int const__18 (= 2) int anon__8 
	# Math operation - Start: anon__8 = anon__8 addl $2
	movl -328(%rbp), %r10d
	movl $2, %r11d
	addl %r11d, %r10d
	movl %r10d, -328(%rbp)
	# Math operation - End: anon__8 = anon__8 addl $2
#### main 21:  GET_ADDRESS char[5][7][8] array  address anon__10 
	movq -308(%rbp), %r10
	movq %r10, -336(%rbp)
#### main 22:  TIMES int anon__8 int const__20 (= 1) int anon__9 
	# Multiplication - Start: anon__9 = anon__8 x $1
	movl -328(%rbp), %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -340(%rbp)
	# Multiplication - End: anon__9 = anon__8 x $1
#### main 23:  ARRAY ACCESS address anon__10 int anon__9 char anon__11 
## Array access START - anon__11 = anon__10[anon__9]
	movq -336(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -340(%rbp), %r11d
	mov  $0, %r12
	movb 8(%r10, %r11, 1), %r12b        # array access 
	movb %r12b, -341(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__11 = anon__10[anon__9]
#### main 24:  WRITE char anon__11   
	movq $0, %r10   # Empty register 
	movb -341(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 25:  RETURN int c   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -12(%rbp), %eax  # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
