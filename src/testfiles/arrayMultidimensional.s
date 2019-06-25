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
	sub $389, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  LENGTH int[7][5] a  int anon__1 
	movl $35, -4(%rbp)
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
#### main 4:  TIMES int const__2 (= 2) int const__4 (= 7) int anon__2 
	# Multiplication - Start: anon__2 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -9(%rbp)
	# Multiplication - End: anon__2 = $2 x $7
#### main 5:  PLUS int anon__2 int const__3 (= 3) int anon__2 
	# Math operation - Start: anon__2 = anon__2 addl $3
	movl -9(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -9(%rbp)
	# Math operation - End: anon__2 = anon__2 addl $3
#### main 6:  GET_ADDRESS int[7][5] a  address anon__4 
	movq %rbp, -157(%rbp)     # Setting up array address
	addq $-157, -157(%rbp)      # Setting up array address
	movq -157(%rbp), %r10
	movq %r10, -165(%rbp)
#### main 7:  TIMES int anon__2 int const__5 (= 4) int anon__3 
	# Multiplication - Start: anon__3 = anon__2 x $4
	movl -9(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -169(%rbp)
	# Multiplication - End: anon__3 = anon__2 x $4
#### main 8:  ARRAY MODIFICATION address anon__4 int anon__3 int const__6 (= 7) 
## Array modification START - anon__4[anon__3] = $7
	movq -165(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -169(%rbp), %r11d
	movq  $7, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__4[anon__3] = $7
#### main 9:  TIMES int const__7 (= 5) int const__9 (= 7) int anon__5 
	# Multiplication - Start: anon__5 = $5 x $7
	movl $5, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -173(%rbp)
	# Multiplication - End: anon__5 = $5 x $7
#### main 10:  PLUS int anon__5 int const__8 (= 7) int anon__5 
	# Math operation - Start: anon__5 = anon__5 addl $7
	movl -173(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -173(%rbp)
	# Math operation - End: anon__5 = anon__5 addl $7
#### main 11:  GET_ADDRESS int[7][5] a  address anon__7 
	movq -157(%rbp), %r10
	movq %r10, -181(%rbp)
#### main 12:  TIMES int anon__5 int const__10 (= 4) int anon__6 
	# Multiplication - Start: anon__6 = anon__5 x $4
	movl -173(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -185(%rbp)
	# Multiplication - End: anon__6 = anon__5 x $4
#### main 13:  ARRAY MODIFICATION address anon__7 int anon__6 int const__11 (= 10) 
## Array modification START - anon__7[anon__6] = $10
	movq -181(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -185(%rbp), %r11d
	movq  $10, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__7[anon__6] = $10
#### main 14:  TIMES int const__12 (= 2) int const__14 (= 7) int anon__8 
	# Multiplication - Start: anon__8 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -189(%rbp)
	# Multiplication - End: anon__8 = $2 x $7
#### main 15:  PLUS int anon__8 int const__13 (= 3) int anon__8 
	# Math operation - Start: anon__8 = anon__8 addl $3
	movl -189(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -189(%rbp)
	# Math operation - End: anon__8 = anon__8 addl $3
#### main 16:  GET_ADDRESS int[7][5] a  address anon__10 
	movq -157(%rbp), %r10
	movq %r10, -197(%rbp)
#### main 17:  TIMES int anon__8 int const__15 (= 4) int anon__9 
	# Multiplication - Start: anon__9 = anon__8 x $4
	movl -189(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -201(%rbp)
	# Multiplication - End: anon__9 = anon__8 x $4
#### main 18:  ARRAY ACCESS address anon__10 int anon__9 int anon__11 
## Array access START - anon__11 = anon__10[anon__9]
	movq -197(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -201(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -205(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__11 = anon__10[anon__9]
#### main 19:  TIMES int const__16 (= 5) int const__18 (= 7) int anon__12 
	# Multiplication - Start: anon__12 = $5 x $7
	movl $5, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -209(%rbp)
	# Multiplication - End: anon__12 = $5 x $7
#### main 20:  PLUS int anon__12 int const__17 (= 7) int anon__12 
	# Math operation - Start: anon__12 = anon__12 addl $7
	movl -209(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -209(%rbp)
	# Math operation - End: anon__12 = anon__12 addl $7
#### main 21:  GET_ADDRESS int[7][5] a  address anon__14 
	movq -157(%rbp), %r10
	movq %r10, -217(%rbp)
#### main 22:  TIMES int anon__12 int const__19 (= 4) int anon__13 
	# Multiplication - Start: anon__13 = anon__12 x $4
	movl -209(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -221(%rbp)
	# Multiplication - End: anon__13 = anon__12 x $4
#### main 23:  ARRAY ACCESS address anon__14 int anon__13 int anon__15 
## Array access START - anon__15 = anon__14[anon__13]
	movq -217(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -221(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -225(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__15 = anon__14[anon__13]
#### main 24:  PLUS int anon__11 int anon__15 int anon__16 
	# Math operation - Start: anon__16 = anon__11 addl anon__15
	movl -205(%rbp), %r10d
	movl -225(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -229(%rbp)
	# Math operation - End: anon__16 = anon__11 addl anon__15
#### main 25:  ASSIGN int anon__16  int b 
	movl -229(%rbp), %r10d
	movl %r10d, -233(%rbp)     # b = anon__16
#### main 26:  WRITE int b   
	movq $0, %rdi
	movl -233(%rbp), %edi
	call printInteger
#### main 27:  TIMES int const__20 (= 2) int const__22 (= 7) int anon__17 
	# Multiplication - Start: anon__17 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -237(%rbp)
	# Multiplication - End: anon__17 = $2 x $7
#### main 28:  PLUS int anon__17 int const__21 (= 0) int anon__17 
	# Math operation - Start: anon__17 = anon__17 addl $0
	movl -237(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -237(%rbp)
	# Math operation - End: anon__17 = anon__17 addl $0
#### main 29:  GET_ADDRESS int[7][5] a  address anon__19 
	movq -157(%rbp), %r10
	movq %r10, -245(%rbp)
#### main 30:  TIMES int anon__17 int const__23 (= 4) int anon__18 
	# Multiplication - Start: anon__18 = anon__17 x $4
	movl -237(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -249(%rbp)
	# Multiplication - End: anon__18 = anon__17 x $4
#### main 31:  ARRAY MODIFICATION address anon__19 int anon__18 int const__24 (= 10) 
## Array modification START - anon__19[anon__18] = $10
	movq -245(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -249(%rbp), %r11d
	movq  $10, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__19[anon__18] = $10
#### main 32:  WRITE char const__25 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 33:  TIMES int const__26 (= 2) int const__28 (= 7) int anon__20 
	# Multiplication - Start: anon__20 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -253(%rbp)
	# Multiplication - End: anon__20 = $2 x $7
#### main 34:  PLUS int anon__20 int const__27 (= 0) int anon__20 
	# Math operation - Start: anon__20 = anon__20 addl $0
	movl -253(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -253(%rbp)
	# Math operation - End: anon__20 = anon__20 addl $0
#### main 35:  GET_ADDRESS int[7][5] a  address anon__22 
	movq -157(%rbp), %r10
	movq %r10, -261(%rbp)
#### main 36:  TIMES int anon__20 int const__29 (= 4) int anon__21 
	# Multiplication - Start: anon__21 = anon__20 x $4
	movl -253(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -265(%rbp)
	# Multiplication - End: anon__21 = anon__20 x $4
#### main 37:  ARRAY ACCESS address anon__22 int anon__21 int anon__23 
## Array access START - anon__23 = anon__22[anon__21]
	movq -261(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -265(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -269(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__23 = anon__22[anon__21]
#### main 38:  WRITE int anon__23   
	movq $0, %rdi
	movl -269(%rbp), %edi
	call printInteger
#### main 39:  TIMES int const__30 (= 2) int const__32 (= 7) int anon__24 
	# Multiplication - Start: anon__24 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -273(%rbp)
	# Multiplication - End: anon__24 = $2 x $7
#### main 40:  PLUS int anon__24 int const__31 (= 0) int anon__24 
	# Math operation - Start: anon__24 = anon__24 addl $0
	movl -273(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -273(%rbp)
	# Math operation - End: anon__24 = anon__24 addl $0
#### main 41:  GET_ADDRESS int[7][5] a  address anon__26 
	movq -157(%rbp), %r10
	movq %r10, -281(%rbp)
#### main 42:  TIMES int anon__24 int const__33 (= 4) int anon__25 
	# Multiplication - Start: anon__25 = anon__24 x $4
	movl -273(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -285(%rbp)
	# Multiplication - End: anon__25 = anon__24 x $4
#### main 43:  ARRAY MODIFICATION address anon__26 int anon__25 int const__34 (= 50) 
## Array modification START - anon__26[anon__25] = $50
	movq -281(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -285(%rbp), %r11d
	movq  $50, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__26[anon__25] = $50
#### main 44:  WRITE char const__35 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 45:  TIMES int const__36 (= 2) int const__38 (= 7) int anon__27 
	# Multiplication - Start: anon__27 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -289(%rbp)
	# Multiplication - End: anon__27 = $2 x $7
#### main 46:  PLUS int anon__27 int const__37 (= 0) int anon__27 
	# Math operation - Start: anon__27 = anon__27 addl $0
	movl -289(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -289(%rbp)
	# Math operation - End: anon__27 = anon__27 addl $0
#### main 47:  GET_ADDRESS int[7][5] a  address anon__29 
	movq -157(%rbp), %r10
	movq %r10, -297(%rbp)
#### main 48:  TIMES int anon__27 int const__39 (= 4) int anon__28 
	# Multiplication - Start: anon__28 = anon__27 x $4
	movl -289(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -301(%rbp)
	# Multiplication - End: anon__28 = anon__27 x $4
#### main 49:  ARRAY ACCESS address anon__29 int anon__28 int anon__30 
## Array access START - anon__30 = anon__29[anon__28]
	movq -297(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -301(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -305(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__30 = anon__29[anon__28]
#### main 50:  WRITE int anon__30   
	movq $0, %rdi
	movl -305(%rbp), %edi
	call printInteger
#### main 51:  RETURN int const__40 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
