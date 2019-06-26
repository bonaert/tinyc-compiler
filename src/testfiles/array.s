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
	sub $133, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  LENGTH int[7] a  int anon__1 
	movl $7, -4(%rbp)
#### main 1:  WRITE int anon__1   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 2:  ASSIGN char const__1 (= ' ')  char space 
	movb $32, -5(%rbp)     # space = 32
#### main 3:  WRITE char space   
	movq $0, %r10   # Empty register 
	movb -5(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 4:  GET_ADDRESS int[7] a  address anon__3 
	movq %rbp, -41(%rbp)     # Setting up array address
	addq $-41, -41(%rbp)      # Setting up array address
	movq -41(%rbp), %r10
	movq %r10, -49(%rbp)
#### main 5:  TIMES int const__2 (= 2) int const__3 (= 4) int anon__2 
	# Multiplication - Start: anon__2 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -53(%rbp)
	# Multiplication - End: anon__2 = $2 x $4
#### main 6:  ARRAY MODIFICATION address anon__3 int anon__2 int const__4 (= 7) 
## Array modification START - anon__3[anon__2] = $7
	movq -49(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -53(%rbp), %r11d
	movq  $7, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__3[anon__2] = $7
#### main 7:  GET_ADDRESS int[7] a  address anon__5 
	movq -41(%rbp), %r10
	movq %r10, -61(%rbp)
#### main 8:  TIMES int const__5 (= 5) int const__6 (= 4) int anon__4 
	# Multiplication - Start: anon__4 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -65(%rbp)
	# Multiplication - End: anon__4 = $5 x $4
#### main 9:  ARRAY MODIFICATION address anon__5 int anon__4 int const__7 (= 10) 
## Array modification START - anon__5[anon__4] = $10
	movq -61(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -65(%rbp), %r11d
	movq  $10, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__5[anon__4] = $10
#### main 10:  GET_ADDRESS int[7] a  address anon__7 
	movq -41(%rbp), %r10
	movq %r10, -73(%rbp)
#### main 11:  TIMES int const__8 (= 2) int const__9 (= 4) int anon__6 
	# Multiplication - Start: anon__6 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -77(%rbp)
	# Multiplication - End: anon__6 = $2 x $4
#### main 12:  ARRAY ACCESS address anon__7 int anon__6 int anon__8 
## Array access START - anon__8 = anon__7[anon__6]
	movq -73(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -77(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -81(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__8 = anon__7[anon__6]
#### main 13:  GET_ADDRESS int[7] a  address anon__10 
	movq -41(%rbp), %r10
	movq %r10, -89(%rbp)
#### main 14:  TIMES int const__10 (= 5) int const__11 (= 4) int anon__9 
	# Multiplication - Start: anon__9 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -93(%rbp)
	# Multiplication - End: anon__9 = $5 x $4
#### main 15:  ARRAY ACCESS address anon__10 int anon__9 int anon__11 
## Array access START - anon__11 = anon__10[anon__9]
	movq -89(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -93(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -97(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__11 = anon__10[anon__9]
#### main 16:  PLUS int anon__8 int anon__11 int anon__12 
	# Math operation - Start: anon__12 = anon__8 addl anon__11
	movl -81(%rbp), %r10d
	movl -97(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -101(%rbp)
	# Math operation - End: anon__12 = anon__8 addl anon__11
#### main 17:  ASSIGN int anon__12  int b 
	movl -101(%rbp), %r10d
	movl %r10d, -105(%rbp)     # b = anon__12
#### main 18:  WRITE int b   
	movq $0, %rdi
	movl -105(%rbp), %edi
	call printInteger
#### main 19:  RETURN int const__12 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
