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
	sub $517, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  WRITE char[40] const__1 (= '¿')   
	movq $const__1, %rdi
	call printCharArray
#### main 1:  LENGTH int[7][5] a  int anon__1 
	movl $35, -4(%rbp)
#### main 2:  WRITE int anon__1   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 3:  TIMES int const__2 (= 2) int const__4 (= 7) int anon__2 
	# Multiplication - Start: anon__2 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__2 = $2 x $7
#### main 4:  PLUS int anon__2 int const__3 (= 3) int anon__2 
	# Math operation - Start: anon__2 = anon__2 addl $3
	movl -8(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__2 = anon__2 addl $3
#### main 5:  GET_ADDRESS int[7][5] a  address anon__4 
	movq %rbp, -156(%rbp)     # Setting up array address
	addq $-156, -156(%rbp)      # Setting up array address
	movq -156(%rbp), %r10
	movq %r10, -164(%rbp)
#### main 6:  TIMES int anon__2 int const__5 (= 4) int anon__3 
	# Multiplication - Start: anon__3 = anon__2 x $4
	movl -8(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -168(%rbp)
	# Multiplication - End: anon__3 = anon__2 x $4
#### main 7:  ARRAY MODIFICATION address anon__4 int anon__3 int const__6 (= 7) 
## Array modification START - anon__4[anon__3] = $7
	movq -164(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -168(%rbp), %r11d
	movq  $7, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__4[anon__3] = $7
#### main 8:  TIMES int const__7 (= 5) int const__9 (= 7) int anon__5 
	# Multiplication - Start: anon__5 = $5 x $7
	movl $5, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -172(%rbp)
	# Multiplication - End: anon__5 = $5 x $7
#### main 9:  PLUS int anon__5 int const__8 (= 7) int anon__5 
	# Math operation - Start: anon__5 = anon__5 addl $7
	movl -172(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -172(%rbp)
	# Math operation - End: anon__5 = anon__5 addl $7
#### main 10:  GET_ADDRESS int[7][5] a  address anon__7 
	movq -156(%rbp), %r10
	movq %r10, -180(%rbp)
#### main 11:  TIMES int anon__5 int const__10 (= 4) int anon__6 
	# Multiplication - Start: anon__6 = anon__5 x $4
	movl -172(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -184(%rbp)
	# Multiplication - End: anon__6 = anon__5 x $4
#### main 12:  ARRAY MODIFICATION address anon__7 int anon__6 int const__11 (= 10) 
## Array modification START - anon__7[anon__6] = $10
	movq -180(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -184(%rbp), %r11d
	movq  $10, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__7[anon__6] = $10
#### main 13:  TIMES int const__12 (= 2) int const__14 (= 7) int anon__8 
	# Multiplication - Start: anon__8 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -188(%rbp)
	# Multiplication - End: anon__8 = $2 x $7
#### main 14:  PLUS int anon__8 int const__13 (= 3) int anon__8 
	# Math operation - Start: anon__8 = anon__8 addl $3
	movl -188(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -188(%rbp)
	# Math operation - End: anon__8 = anon__8 addl $3
#### main 15:  GET_ADDRESS int[7][5] a  address anon__10 
	movq -156(%rbp), %r10
	movq %r10, -196(%rbp)
#### main 16:  TIMES int anon__8 int const__15 (= 4) int anon__9 
	# Multiplication - Start: anon__9 = anon__8 x $4
	movl -188(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -200(%rbp)
	# Multiplication - End: anon__9 = anon__8 x $4
#### main 17:  ARRAY ACCESS address anon__10 int anon__9 int anon__11 
## Array access START - anon__11 = anon__10[anon__9]
	movq -196(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -200(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -204(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__11 = anon__10[anon__9]
#### main 18:  TIMES int const__16 (= 5) int const__18 (= 7) int anon__12 
	# Multiplication - Start: anon__12 = $5 x $7
	movl $5, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -208(%rbp)
	# Multiplication - End: anon__12 = $5 x $7
#### main 19:  PLUS int anon__12 int const__17 (= 7) int anon__12 
	# Math operation - Start: anon__12 = anon__12 addl $7
	movl -208(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -208(%rbp)
	# Math operation - End: anon__12 = anon__12 addl $7
#### main 20:  GET_ADDRESS int[7][5] a  address anon__14 
	movq -156(%rbp), %r10
	movq %r10, -216(%rbp)
#### main 21:  TIMES int anon__12 int const__19 (= 4) int anon__13 
	# Multiplication - Start: anon__13 = anon__12 x $4
	movl -208(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -220(%rbp)
	# Multiplication - End: anon__13 = anon__12 x $4
#### main 22:  ARRAY ACCESS address anon__14 int anon__13 int anon__15 
## Array access START - anon__15 = anon__14[anon__13]
	movq -216(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -220(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -224(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__15 = anon__14[anon__13]
#### main 23:  PLUS int anon__11 int anon__15 int anon__16 
	# Math operation - Start: anon__16 = anon__11 addl anon__15
	movl -204(%rbp), %r10d
	movl -224(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -228(%rbp)
	# Math operation - End: anon__16 = anon__11 addl anon__15
#### main 24:  ASSIGN int anon__16  int b 
	movl -228(%rbp), %r10d
	movl %r10d, -232(%rbp)     # b = anon__16
#### main 25:  WRITE char[19] const__20 (= '')   
	movq $const__20, %rdi
	call printCharArray
#### main 26:  WRITE int b   
	movq $0, %rdi
	movl -232(%rbp), %edi
	call printInteger
#### main 27:  TIMES int const__21 (= 2) int const__23 (= 7) int anon__17 
	# Multiplication - Start: anon__17 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -236(%rbp)
	# Multiplication - End: anon__17 = $2 x $7
#### main 28:  PLUS int anon__17 int const__22 (= 0) int anon__17 
	# Math operation - Start: anon__17 = anon__17 addl $0
	movl -236(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -236(%rbp)
	# Math operation - End: anon__17 = anon__17 addl $0
#### main 29:  GET_ADDRESS int[7][5] a  address anon__19 
	movq -156(%rbp), %r10
	movq %r10, -244(%rbp)
#### main 30:  TIMES int anon__17 int const__24 (= 4) int anon__18 
	# Multiplication - Start: anon__18 = anon__17 x $4
	movl -236(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -248(%rbp)
	# Multiplication - End: anon__18 = anon__17 x $4
#### main 31:  ARRAY MODIFICATION address anon__19 int anon__18 int const__25 (= 10) 
## Array modification START - anon__19[anon__18] = $10
	movq -244(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -248(%rbp), %r11d
	movq  $10, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__19[anon__18] = $10
#### main 32:  WRITE char[19] const__26 (= 'ê')   
	movq $const__26, %rdi
	call printCharArray
#### main 33:  TIMES int const__27 (= 2) int const__29 (= 7) int anon__20 
	# Multiplication - Start: anon__20 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -252(%rbp)
	# Multiplication - End: anon__20 = $2 x $7
#### main 34:  PLUS int anon__20 int const__28 (= 0) int anon__20 
	# Math operation - Start: anon__20 = anon__20 addl $0
	movl -252(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -252(%rbp)
	# Math operation - End: anon__20 = anon__20 addl $0
#### main 35:  GET_ADDRESS int[7][5] a  address anon__22 
	movq -156(%rbp), %r10
	movq %r10, -260(%rbp)
#### main 36:  TIMES int anon__20 int const__30 (= 4) int anon__21 
	# Multiplication - Start: anon__21 = anon__20 x $4
	movl -252(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -264(%rbp)
	# Multiplication - End: anon__21 = anon__20 x $4
#### main 37:  ARRAY ACCESS address anon__22 int anon__21 int anon__23 
## Array access START - anon__23 = anon__22[anon__21]
	movq -260(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -264(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -268(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__23 = anon__22[anon__21]
#### main 38:  WRITE int anon__23   
	movq $0, %rdi
	movl -268(%rbp), %edi
	call printInteger
#### main 39:  TIMES int const__31 (= 2) int const__33 (= 7) int anon__24 
	# Multiplication - Start: anon__24 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -272(%rbp)
	# Multiplication - End: anon__24 = $2 x $7
#### main 40:  PLUS int anon__24 int const__32 (= 0) int anon__24 
	# Math operation - Start: anon__24 = anon__24 addl $0
	movl -272(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -272(%rbp)
	# Math operation - End: anon__24 = anon__24 addl $0
#### main 41:  GET_ADDRESS int[7][5] a  address anon__26 
	movq -156(%rbp), %r10
	movq %r10, -280(%rbp)
#### main 42:  TIMES int anon__24 int const__34 (= 4) int anon__25 
	# Multiplication - Start: anon__25 = anon__24 x $4
	movl -272(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -284(%rbp)
	# Multiplication - End: anon__25 = anon__24 x $4
#### main 43:  ARRAY MODIFICATION address anon__26 int anon__25 int const__35 (= 50) 
## Array modification START - anon__26[anon__25] = $50
	movq -280(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -284(%rbp), %r11d
	movq  $50, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__26[anon__25] = $50
#### main 44:  WRITE char[19] const__36 (= '¿')   
	movq $const__36, %rdi
	call printCharArray
#### main 45:  TIMES int const__37 (= 2) int const__39 (= 7) int anon__27 
	# Multiplication - Start: anon__27 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -288(%rbp)
	# Multiplication - End: anon__27 = $2 x $7
#### main 46:  PLUS int anon__27 int const__38 (= 0) int anon__27 
	# Math operation - Start: anon__27 = anon__27 addl $0
	movl -288(%rbp), %r10d
	movl $0, %r11d
	addl %r11d, %r10d
	movl %r10d, -288(%rbp)
	# Math operation - End: anon__27 = anon__27 addl $0
#### main 47:  GET_ADDRESS int[7][5] a  address anon__29 
	movq -156(%rbp), %r10
	movq %r10, -296(%rbp)
#### main 48:  TIMES int anon__27 int const__40 (= 4) int anon__28 
	# Multiplication - Start: anon__28 = anon__27 x $4
	movl -288(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -300(%rbp)
	# Multiplication - End: anon__28 = anon__27 x $4
#### main 49:  ARRAY ACCESS address anon__29 int anon__28 int anon__30 
## Array access START - anon__30 = anon__29[anon__28]
	movq -296(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -300(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -304(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__30 = anon__29[anon__28]
#### main 50:  WRITE int anon__30   
	movq $0, %rdi
	movl -304(%rbp), %edi
	call printInteger
#### main 51:  RETURN int const__41 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
	const__1: .asciz "The length of A is 35 and length a = "  
	const__20: .asciz "\nshould be 17: "  
	const__26: .asciz "\nshould be 10: "  
	const__36: .asciz "\nshould be 50: "  
