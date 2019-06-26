	.text
	.include "printInteger.s"

#####################################################
# dotproduct: function(int[4],int[4]) -> int
#####################################################
.type dotproduct, @function
dotproduct:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $100, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### dotproduct 0:  ASSIGN int const__1 (= 0)  int i 
	movl $0, -4(%rbp)     # i = 0
#### dotproduct 1:  ASSIGN int const__1 (= 0)  int product 
	movl $0, -8(%rbp)     # product = 0
#### dotproduct 2:  ASSIGN int i  int product 
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # product = i
dotproduct_3:
#### dotproduct 3:  IF_GREATER_OR_EQUAL int i int const__3 (= 4) 11
	movl -4(%rbp), %r10d
	movl $4, %r11d
	cmpl %r11d, %r10d
	jge dotproduct_11
#### dotproduct 4:  TIMES int i int const__4 (= 4) int anon__3 
	# Multiplication - Start: anon__3 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -12(%rbp)
	# Multiplication - End: anon__3 = i x $4
#### dotproduct 5:  ARRAY ACCESS int[4] a int anon__3 int anon__2 
## Array access START - anon__2 = a[anon__3]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -12(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -16(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__2 = a[anon__3]
#### dotproduct 6:  ARRAY ACCESS int[4] b int anon__3 int anon__4 
## Array access START - anon__4 = b[anon__3]
	movq 16(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -12(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -20(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__4 = b[anon__3]
#### dotproduct 7:  TIMES int anon__2 int anon__4 int anon__5 
	# Multiplication - Start: anon__5 = anon__2 x anon__4
	movl -16(%rbp), %eax
	movl -20(%rbp), %r10d
	imull %r10d
	movl %eax, -24(%rbp)
	# Multiplication - End: anon__5 = anon__2 x anon__4
#### dotproduct 8:  PLUS int product int anon__5 int product 
	# Math operation - Start: product = product addl anon__5
	movl -8(%rbp), %r10d
	movl -24(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: product = product addl anon__5
#### dotproduct 9:  PLUS int -20(%rbp) int const__6 (= 1) int -20(%rbp) 
	# Math operation - Start: -20(%rbp) = -20(%rbp) addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: -20(%rbp) = -20(%rbp) addl $1
#### dotproduct 10:  GOTO 3
	jmp dotproduct_3
dotproduct_11:
#### dotproduct 11:  RETURN int product   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -8(%rbp), %eax  # return - move 32 bit value to return register
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
	sub $232, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  GET_ADDRESS int[4] a  address anon__9 
	movq %rbp, -24(%rbp)     # Setting up array address
	addq $-24, -24(%rbp)      # Setting up array address
	movq -24(%rbp), %r10
	movq %r10, -32(%rbp)
#### main 1:  TIMES int const__7 (= 0) int const__8 (= 4) int anon__8 
	# Multiplication - Start: anon__8 = $0 x $4
	movl $0, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -36(%rbp)
	# Multiplication - End: anon__8 = $0 x $4
#### main 2:  ARRAY MODIFICATION address anon__9 int anon__8 int const__9 (= 1) 
## Array modification START - anon__9[anon__8] = $1
	movq -32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -36(%rbp), %r11d
	movq  $1, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__9[anon__8] = $1
#### main 3:  GET_ADDRESS int[4] a  address anon__11 
	movq -24(%rbp), %r10
	movq %r10, -44(%rbp)
#### main 4:  TIMES int const__10 (= 1) int const__11 (= 4) int anon__10 
	# Multiplication - Start: anon__10 = $1 x $4
	movl $1, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__10 = $1 x $4
#### main 5:  ARRAY MODIFICATION address anon__11 int anon__10 int const__12 (= 2) 
## Array modification START - anon__11[anon__10] = $2
	movq -44(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	movq  $2, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__11[anon__10] = $2
#### main 6:  GET_ADDRESS int[4] a  address anon__13 
	movq -24(%rbp), %r10
	movq %r10, -56(%rbp)
#### main 7:  TIMES int const__13 (= 2) int const__14 (= 4) int anon__12 
	# Multiplication - Start: anon__12 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -60(%rbp)
	# Multiplication - End: anon__12 = $2 x $4
#### main 8:  ARRAY MODIFICATION address anon__13 int anon__12 int const__15 (= 3) 
## Array modification START - anon__13[anon__12] = $3
	movq -56(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -60(%rbp), %r11d
	movq  $3, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__13[anon__12] = $3
#### main 9:  GET_ADDRESS int[4] a  address anon__15 
	movq -24(%rbp), %r10
	movq %r10, -68(%rbp)
#### main 10:  TIMES int const__16 (= 3) int const__17 (= 4) int anon__14 
	# Multiplication - Start: anon__14 = $3 x $4
	movl $3, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -72(%rbp)
	# Multiplication - End: anon__14 = $3 x $4
#### main 11:  ARRAY MODIFICATION address anon__15 int anon__14 int const__18 (= 4) 
## Array modification START - anon__15[anon__14] = $4
	movq -68(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -72(%rbp), %r11d
	movq  $4, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__15[anon__14] = $4
#### main 12:  GET_ADDRESS int[4] b  address anon__17 
	movq %rbp, -96(%rbp)     # Setting up array address
	addq $-96, -96(%rbp)      # Setting up array address
	movq -96(%rbp), %r10
	movq %r10, -104(%rbp)
#### main 13:  TIMES int const__19 (= 0) int const__20 (= 4) int anon__16 
	# Multiplication - Start: anon__16 = $0 x $4
	movl $0, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -108(%rbp)
	# Multiplication - End: anon__16 = $0 x $4
#### main 14:  ARRAY MODIFICATION address anon__17 int anon__16 int const__21 (= 1) 
## Array modification START - anon__17[anon__16] = $1
	movq -104(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -108(%rbp), %r11d
	movq  $1, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__17[anon__16] = $1
#### main 15:  GET_ADDRESS int[4] b  address anon__19 
	movq -96(%rbp), %r10
	movq %r10, -116(%rbp)
#### main 16:  TIMES int const__22 (= 1) int const__23 (= 4) int anon__18 
	# Multiplication - Start: anon__18 = $1 x $4
	movl $1, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -120(%rbp)
	# Multiplication - End: anon__18 = $1 x $4
#### main 17:  ARRAY MODIFICATION address anon__19 int anon__18 int const__24 (= 2) 
## Array modification START - anon__19[anon__18] = $2
	movq -116(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -120(%rbp), %r11d
	movq  $2, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__19[anon__18] = $2
#### main 18:  GET_ADDRESS int[4] b  address anon__21 
	movq -96(%rbp), %r10
	movq %r10, -128(%rbp)
#### main 19:  TIMES int const__25 (= 2) int const__26 (= 4) int anon__20 
	# Multiplication - Start: anon__20 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -132(%rbp)
	# Multiplication - End: anon__20 = $2 x $4
#### main 20:  ARRAY MODIFICATION address anon__21 int anon__20 int const__27 (= 3) 
## Array modification START - anon__21[anon__20] = $3
	movq -128(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -132(%rbp), %r11d
	movq  $3, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__21[anon__20] = $3
#### main 21:  GET_ADDRESS int[4] b  address anon__23 
	movq -96(%rbp), %r10
	movq %r10, -140(%rbp)
#### main 22:  TIMES int const__28 (= 3) int const__29 (= 4) int anon__22 
	# Multiplication - Start: anon__22 = $3 x $4
	movl $3, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -144(%rbp)
	# Multiplication - End: anon__22 = $3 x $4
#### main 23:  ARRAY MODIFICATION address anon__23 int anon__22 int const__30 (= 4) 
## Array modification START - anon__23[anon__22] = $4
	movq -140(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -144(%rbp), %r11d
	movq  $4, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__23[anon__22] = $4
#### main 24:  GET_ADDRESS int[4] a  address anon__25 
	movq -24(%rbp), %r10
	movq %r10, -152(%rbp)
#### main 25:  PARAM address anon__25   
	movq -152(%rbp), %r10
	pushq %r10
#### main 26:  GET_ADDRESS int[4] b  address anon__26 
	movq -96(%rbp), %r10
	movq %r10, -160(%rbp)
#### main 27:  PARAM address anon__26   
	movq -160(%rbp), %r10
	pushq %r10
#### main 28:  CALL dotproduct: function(int[4],int[4]) -> int   
	call dotproduct
#### main 29:  GETRETURN   int anon__24 
	movl %eax, -164(%rbp)
#### main 30:  WRITE int anon__24   
	movq $0, %rdi
	movl -164(%rbp), %edi
	call printInteger
#### main 31:  WRITE char const__31 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 32:  RETURN int const__32 (= 5)   
	movq $5, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
