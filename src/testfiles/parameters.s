	.text
	.include "printInteger.s"

#####################################################
# modifyCharArray: function(char[5]) -> char[5]
#####################################################
.type modifyCharArray, @function
modifyCharArray:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $21, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### modifyCharArray 0:  TIMES int const__1 (= 2) int const__2 (= 1) int anon__1 
	# Multiplication - Start: anon__1 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: anon__1 = $2 x $1
#### modifyCharArray 1:  ARRAY MODIFICATION char[5] a int anon__1 char const__3 (= 'b') 
## Array modification START - a[anon__1] = $98
	movq 16(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -4(%rbp), %r11d
	movq  $98, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__1] = $98
#### modifyCharArray 2:  RETURN char[5] a   
	movq 16(%rbp), %rax   # return - move 64 bit address of array parameter in return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# modifyIntArray: function(int[5]) -> int[5]
#####################################################
.type modifyIntArray, @function
modifyIntArray:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $40, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### modifyIntArray 0:  TIMES int const__4 (= 2) int const__5 (= 4) int anon__2 
	# Multiplication - Start: anon__2 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: anon__2 = $2 x $4
#### modifyIntArray 1:  ARRAY MODIFICATION int[5] a int anon__2 int const__6 (= 123) 
## Array modification START - a[anon__2] = $123
	movq 16(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -4(%rbp), %r11d
	movq  $123, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__2] = $123
#### modifyIntArray 2:  RETURN int[5] a   
	movq 16(%rbp), %rax   # return - move 64 bit address of array parameter in return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# modifyMultidimensionalIntArray: function(int[10][10],int) -> int[5][5]
#####################################################
.type modifyMultidimensionalIntArray, @function
modifyMultidimensionalIntArray:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $428, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### modifyMultidimensionalIntArray 0:  TIMES int const__7 (= 1) int const__8 (= 10) int anon__3 
	# Multiplication - Start: anon__3 = $1 x $10
	movl $1, %eax
	movl $10, %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: anon__3 = $1 x $10
#### modifyMultidimensionalIntArray 1:  PLUS int anon__3 int n int anon__3 
	# Math operation - Start: anon__3 = anon__3 addl n
	movl -4(%rbp), %r10d
	movq 16(%rbp), %r11
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: anon__3 = anon__3 addl n
#### modifyMultidimensionalIntArray 2:  TIMES int anon__3 int const__9 (= 4) int anon__4 
	# Multiplication - Start: anon__4 = anon__3 x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__4 = anon__3 x $4
#### modifyMultidimensionalIntArray 3:  ARRAY MODIFICATION int[10][10] b int anon__4 int const__10 (= 123) 
## Array modification START - b[anon__4] = $123
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -8(%rbp), %r11d
	movq  $123, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - b[anon__4] = $123
#### modifyMultidimensionalIntArray 4:  RETURN int[10][10] b   
	movq 24(%rbp), %rax   # return - move 64 bit address of array parameter in return register
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
	sub $824, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  GET_ADDRESS int[5] ints  address anon__6 
	movq %rbp, -28(%rbp)     # Setting up array address
	addq $-28, -28(%rbp)      # Setting up array address
	movq -28(%rbp), %r10
	movq %r10, -36(%rbp)
#### main 1:  TIMES int const__11 (= 2) int const__12 (= 4) int anon__5 
	# Multiplication - Start: anon__5 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -40(%rbp)
	# Multiplication - End: anon__5 = $2 x $4
#### main 2:  ARRAY MODIFICATION address anon__6 int anon__5 int const__13 (= 999) 
## Array modification START - anon__6[anon__5] = $999
	movq -36(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -40(%rbp), %r11d
	movq  $999, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__6[anon__5] = $999
#### main 3:  WRITE char const__14 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 4:  GET_ADDRESS int[5] ints  address anon__8 
	movq -28(%rbp), %r10
	movq %r10, -48(%rbp)
#### main 5:  TIMES int const__15 (= 2) int const__16 (= 4) int anon__7 
	# Multiplication - Start: anon__7 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -52(%rbp)
	# Multiplication - End: anon__7 = $2 x $4
#### main 6:  ARRAY ACCESS address anon__8 int anon__7 int anon__9 
## Array access START - anon__9 = anon__8[anon__7]
	movq -48(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -52(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -56(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__9 = anon__8[anon__7]
#### main 7:  WRITE int anon__9   
	movq $0, %rdi
	movl -56(%rbp), %edi
	call printInteger
#### main 8:  GET_ADDRESS int[5] ints  address anon__11 
	movq -28(%rbp), %r10
	movq %r10, -64(%rbp)
#### main 9:  PARAM address anon__11   
	movq -64(%rbp), %r10
	pushq %r10
#### main 10:  CALL modifyIntArray: function(int[5]) -> int[5]   
	call modifyIntArray
#### main 11:  GETRETURN   int[5] anon__10 
	movq %rbp, -92(%rbp)     # Setting up array address
	addq $-92, -92(%rbp)      # Setting up array address
	movq %rax, -92(%rbp)
#### main 12:  ASSIGN int[5] anon__10  int[5] ints 
	movq -92(%rbp), %r10
	movq %r10, -28(%rbp)     # ints = anon__10
#### main 13:  WRITE char const__17 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 14:  GET_ADDRESS int[5] ints  address anon__13 
	movq -28(%rbp), %r10
	movq %r10, -100(%rbp)
#### main 15:  TIMES int const__18 (= 2) int const__19 (= 4) int anon__12 
	# Multiplication - Start: anon__12 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -104(%rbp)
	# Multiplication - End: anon__12 = $2 x $4
#### main 16:  ARRAY ACCESS address anon__13 int anon__12 int anon__14 
## Array access START - anon__14 = anon__13[anon__12]
	movq -100(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -104(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -108(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__14 = anon__13[anon__12]
#### main 17:  WRITE int anon__14   
	movq $0, %rdi
	movl -108(%rbp), %edi
	call printInteger
#### main 18:  GET_ADDRESS char[5] chars  address anon__16 
	movq %rbp, -121(%rbp)     # Setting up array address
	addq $-121, -121(%rbp)      # Setting up array address
	movq -121(%rbp), %r10
	movq %r10, -129(%rbp)
#### main 19:  TIMES int const__20 (= 2) int const__21 (= 1) int anon__15 
	# Multiplication - Start: anon__15 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -133(%rbp)
	# Multiplication - End: anon__15 = $2 x $1
#### main 20:  ARRAY MODIFICATION address anon__16 int anon__15 char const__22 (= 'z') 
## Array modification START - anon__16[anon__15] = $122
	movq -129(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -133(%rbp), %r11d
	movq  $122, %r12
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__16[anon__15] = $122
#### main 21:  WRITE char const__23 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 22:  GET_ADDRESS char[5] chars  address anon__18 
	movq -121(%rbp), %r10
	movq %r10, -141(%rbp)
#### main 23:  TIMES int const__24 (= 2) int const__25 (= 1) int anon__17 
	# Multiplication - Start: anon__17 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -145(%rbp)
	# Multiplication - End: anon__17 = $2 x $1
#### main 24:  ARRAY ACCESS address anon__18 int anon__17 char anon__19 
## Array access START - anon__19 = anon__18[anon__17]
	movq -141(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -145(%rbp), %r11d
	mov  $0, %r12
	movb 8(%r10, %r11, 1), %r12b        # array access 
	movb %r12b, -146(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__19 = anon__18[anon__17]
#### main 25:  WRITE char anon__19   
	movq $0, %r10   # Empty register 
	movb -146(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 26:  GET_ADDRESS char[5] chars  address anon__21 
	movq -121(%rbp), %r10
	movq %r10, -154(%rbp)
#### main 27:  PARAM address anon__21   
	movq -154(%rbp), %r10
	pushq %r10
#### main 28:  CALL modifyCharArray: function(char[5]) -> char[5]   
	call modifyCharArray
#### main 29:  GETRETURN   char[5] anon__20 
	movq %rbp, -167(%rbp)     # Setting up array address
	addq $-167, -167(%rbp)      # Setting up array address
	movq %rax, -167(%rbp)
#### main 30:  ASSIGN char[5] anon__20  char[5] chars 
	movq -167(%rbp), %r10
	movq %r10, -121(%rbp)     # chars = anon__20
#### main 31:  WRITE char const__26 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 32:  GET_ADDRESS char[5] chars  address anon__23 
	movq -121(%rbp), %r10
	movq %r10, -175(%rbp)
#### main 33:  TIMES int const__27 (= 2) int const__28 (= 1) int anon__22 
	# Multiplication - Start: anon__22 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -179(%rbp)
	# Multiplication - End: anon__22 = $2 x $1
#### main 34:  ARRAY ACCESS address anon__23 int anon__22 char anon__24 
## Array access START - anon__24 = anon__23[anon__22]
	movq -175(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -179(%rbp), %r11d
	mov  $0, %r12
	movb 8(%r10, %r11, 1), %r12b        # array access 
	movb %r12b, -180(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__24 = anon__23[anon__22]
#### main 35:  WRITE char anon__24   
	movq $0, %r10   # Empty register 
	movb -180(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 36:  TIMES int const__29 (= 1) int const__31 (= 10) int anon__25 
	# Multiplication - Start: anon__25 = $1 x $10
	movl $1, %eax
	movl $10, %r10d
	imull %r10d
	movl %eax, -184(%rbp)
	# Multiplication - End: anon__25 = $1 x $10
#### main 37:  PLUS int anon__25 int const__30 (= 1) int anon__25 
	# Math operation - Start: anon__25 = anon__25 addl $1
	movl -184(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -184(%rbp)
	# Math operation - End: anon__25 = anon__25 addl $1
#### main 38:  GET_ADDRESS int[10][10] xxx  address anon__27 
	movq %rbp, -592(%rbp)     # Setting up array address
	addq $-592, -592(%rbp)      # Setting up array address
	movq -592(%rbp), %r10
	movq %r10, -600(%rbp)
#### main 39:  TIMES int anon__25 int const__32 (= 4) int anon__26 
	# Multiplication - Start: anon__26 = anon__25 x $4
	movl -184(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -604(%rbp)
	# Multiplication - End: anon__26 = anon__25 x $4
#### main 40:  ARRAY MODIFICATION address anon__27 int anon__26 int const__33 (= 456) 
## Array modification START - anon__27[anon__26] = $456
	movq -600(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -604(%rbp), %r11d
	movq  $456, %r12
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__27[anon__26] = $456
#### main 41:  WRITE char const__34 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 42:  TIMES int const__35 (= 1) int const__37 (= 10) int anon__28 
	# Multiplication - Start: anon__28 = $1 x $10
	movl $1, %eax
	movl $10, %r10d
	imull %r10d
	movl %eax, -608(%rbp)
	# Multiplication - End: anon__28 = $1 x $10
#### main 43:  PLUS int anon__28 int const__36 (= 1) int anon__28 
	# Math operation - Start: anon__28 = anon__28 addl $1
	movl -608(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -608(%rbp)
	# Math operation - End: anon__28 = anon__28 addl $1
#### main 44:  GET_ADDRESS int[10][10] xxx  address anon__30 
	movq -592(%rbp), %r10
	movq %r10, -616(%rbp)
#### main 45:  TIMES int anon__28 int const__38 (= 4) int anon__29 
	# Multiplication - Start: anon__29 = anon__28 x $4
	movl -608(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -620(%rbp)
	# Multiplication - End: anon__29 = anon__28 x $4
#### main 46:  ARRAY ACCESS address anon__30 int anon__29 int anon__31 
## Array access START - anon__31 = anon__30[anon__29]
	movq -616(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -620(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -624(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__31 = anon__30[anon__29]
#### main 47:  WRITE int anon__31   
	movq $0, %rdi
	movl -624(%rbp), %edi
	call printInteger
#### main 48:  GET_ADDRESS int[10][10] xxx  address anon__33 
	movq -592(%rbp), %r10
	movq %r10, -632(%rbp)
#### main 49:  PARAM address anon__33   
	movq -632(%rbp), %r10
	pushq %r10
#### main 50:  PARAM int const__39 (= 1)   
	pushq $1
#### main 51:  CALL modifyMultidimensionalIntArray: function(int[10][10],int) -> int[5][5]   
	call modifyMultidimensionalIntArray
#### main 52:  GETRETURN   int[5][5] anon__32 
	movq %rbp, -740(%rbp)     # Setting up array address
	addq $-740, -740(%rbp)      # Setting up array address
	movq %rax, -740(%rbp)
#### main 53:  ASSIGN int[5][5] anon__32  int[10][10] xxx 
	movq -740(%rbp), %r10
	movq %r10, -592(%rbp)     # xxx = anon__32
#### main 54:  WRITE char const__40 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 55:  TIMES int const__41 (= 1) int const__43 (= 10) int anon__34 
	# Multiplication - Start: anon__34 = $1 x $10
	movl $1, %eax
	movl $10, %r10d
	imull %r10d
	movl %eax, -744(%rbp)
	# Multiplication - End: anon__34 = $1 x $10
#### main 56:  PLUS int anon__34 int const__42 (= 1) int anon__34 
	# Math operation - Start: anon__34 = anon__34 addl $1
	movl -744(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -744(%rbp)
	# Math operation - End: anon__34 = anon__34 addl $1
#### main 57:  GET_ADDRESS int[10][10] xxx  address anon__36 
	movq -592(%rbp), %r10
	movq %r10, -752(%rbp)
#### main 58:  TIMES int anon__34 int const__44 (= 4) int anon__35 
	# Multiplication - Start: anon__35 = anon__34 x $4
	movl -744(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -756(%rbp)
	# Multiplication - End: anon__35 = anon__34 x $4
#### main 59:  ARRAY ACCESS address anon__36 int anon__35 int anon__37 
## Array access START - anon__37 = anon__36[anon__35]
	movq -752(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -756(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -760(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__37 = anon__36[anon__35]
#### main 60:  WRITE int anon__37   
	movq $0, %rdi
	movl -760(%rbp), %edi
	call printInteger
#### main 61:  RETURN int const__45 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
