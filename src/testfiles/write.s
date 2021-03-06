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
	sub $126, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  WRITE char const__1 (= 'a')   
	movq $0, %r10   # Empty register 
	movb $97, %r10b
	movq %r10, %rdi
	call printChar
#### main 1:  WRITE char const__2 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 2:  WRITE char const__3 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 3:  GET_ADDRESS char[6] letters  address anon__2 
	movq %rbp, -14(%rbp)     # Setting up array address
	addq $-14, -14(%rbp)      # Setting up array address
	movq -14(%rbp), %r10
	movq %r10, -22(%rbp)
#### main 4:  TIMES int const__4 (= 0) int const__5 (= 1) int anon__1 
	# Multiplication - Start: anon__1 = $0 x $1
	movl $0, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -26(%rbp)
	# Multiplication - End: anon__1 = $0 x $1
#### main 5:  ARRAY MODIFICATION address anon__2 int anon__1 char const__6 (= 'h') 
## Array modification START - anon__2[anon__1] = $104
	movq -22(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -26(%rbp), %r11d
	movq  $104, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__2[anon__1] = $104
#### main 6:  GET_ADDRESS char[6] letters  address anon__4 
	movq -14(%rbp), %r10
	movq %r10, -34(%rbp)
#### main 7:  TIMES int const__7 (= 1) int const__8 (= 1) int anon__3 
	# Multiplication - Start: anon__3 = $1 x $1
	movl $1, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -38(%rbp)
	# Multiplication - End: anon__3 = $1 x $1
#### main 8:  ARRAY MODIFICATION address anon__4 int anon__3 char const__9 (= 'e') 
## Array modification START - anon__4[anon__3] = $101
	movq -34(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -38(%rbp), %r11d
	movq  $101, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__4[anon__3] = $101
#### main 9:  GET_ADDRESS char[6] letters  address anon__6 
	movq -14(%rbp), %r10
	movq %r10, -46(%rbp)
#### main 10:  TIMES int const__10 (= 2) int const__11 (= 1) int anon__5 
	# Multiplication - Start: anon__5 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -50(%rbp)
	# Multiplication - End: anon__5 = $2 x $1
#### main 11:  ARRAY MODIFICATION address anon__6 int anon__5 char const__12 (= 'l') 
## Array modification START - anon__6[anon__5] = $108
	movq -46(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -50(%rbp), %r11d
	movq  $108, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__6[anon__5] = $108
#### main 12:  GET_ADDRESS char[6] letters  address anon__8 
	movq -14(%rbp), %r10
	movq %r10, -58(%rbp)
#### main 13:  TIMES int const__13 (= 3) int const__14 (= 1) int anon__7 
	# Multiplication - Start: anon__7 = $3 x $1
	movl $3, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -62(%rbp)
	# Multiplication - End: anon__7 = $3 x $1
#### main 14:  ARRAY MODIFICATION address anon__8 int anon__7 char const__15 (= 'l') 
## Array modification START - anon__8[anon__7] = $108
	movq -58(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -62(%rbp), %r11d
	movq  $108, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__8[anon__7] = $108
#### main 15:  GET_ADDRESS char[6] letters  address anon__10 
	movq -14(%rbp), %r10
	movq %r10, -70(%rbp)
#### main 16:  TIMES int const__16 (= 4) int const__17 (= 1) int anon__9 
	# Multiplication - Start: anon__9 = $4 x $1
	movl $4, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -74(%rbp)
	# Multiplication - End: anon__9 = $4 x $1
#### main 17:  ARRAY MODIFICATION address anon__10 int anon__9 char const__18 (= 'o') 
## Array modification START - anon__10[anon__9] = $111
	movq -70(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -74(%rbp), %r11d
	movq  $111, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__10[anon__9] = $111
#### main 18:  GET_ADDRESS char[6] letters  address anon__12 
	movq -14(%rbp), %r10
	movq %r10, -82(%rbp)
#### main 19:  TIMES int const__19 (= 5) int const__20 (= 1) int anon__11 
	# Multiplication - Start: anon__11 = $5 x $1
	movl $5, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -86(%rbp)
	# Multiplication - End: anon__11 = $5 x $1
#### main 20:  ARRAY MODIFICATION address anon__12 int anon__11 char const__21 (= ' ') 
## Array modification START - anon__12[anon__11] = $0
	movq -82(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -86(%rbp), %r11d
	movq  $0, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__12[anon__11] = $0
#### main 21:  WRITE char[6] letters   
	movq -14(%rbp), %rdi
	add $8, %rdi
	call printCharArray
#### main 22:  WRITE char const__22 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 23:  WRITE int const__23 (= 10)   
	movq $0, %rdi
	movl $10, %edi
	call printInteger
#### main 24:  WRITE char const__24 (= '*')   
	movq $0, %r10   # Empty register 
	movb $42, %r10b
	movq %r10, %rdi
	call printChar
#### main 25:  WRITE int const__25 (= 10)   
	movq $0, %rdi
	movl $10, %edi
	call printInteger
#### main 26:  WRITE char const__26 (= '=')   
	movq $0, %r10   # Empty register 
	movb $61, %r10b
	movq %r10, %rdi
	call printChar
#### main 27:  WRITE int const__29 (= 100)   
	movq $0, %rdi
	movl $100, %edi
	call printInteger
#### main 28:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
