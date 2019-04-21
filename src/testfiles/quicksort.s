	.text
	.include "printInteger.s"

#####################################################
# split: function(int[10],int,int) -> int
#####################################################
.type split, @function
split:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $152, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### split 0:  TIMES int start int const__1 (= 4) int anon__1 
	# Multiplication - Start: anon__1 = start x $4
	movq 24(%rbp), %rax
	movl $4, %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: anon__1 = start x $4
#### split 1:  ARRAY ACCESS int[10] a int anon__1 int anon__2 
## Array access START - anon__2 = a[anon__1]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -4(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -8(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__2 = a[anon__1]
#### split 2:  ASSIGN int anon__2  int p 
	movl -8(%rbp), %r10d
	movl %r10d, -12(%rbp)     # p = anon__2
#### split 3:  ASSIGN int start  int i 
	movq 24(%rbp), %r10
	movl %r10d, -16(%rbp)     # i = start
#### split 4:  ASSIGN int end  int j 
	movq 16(%rbp), %r10
	movl %r10d, -20(%rbp)     # j = end
split_5:
#### split 5:  IF_SMALLER int i int j 7
	movl -16(%rbp), %r10d
	movl -20(%rbp), %r11d
	cmpl %r11d, %r10d
	jl split_7
#### split 6:  GOTO 33
	jmp split_33
split_7:
#### split 7:  TIMES int i int const__2 (= 4) int anon__3 
	# Multiplication - Start: anon__3 = i x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -24(%rbp)
	# Multiplication - End: anon__3 = i x $4
#### split 8:  ARRAY ACCESS int[10] a int anon__3 int anon__4 
## Array access START - anon__4 = a[anon__3]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -24(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -28(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__4 = a[anon__3]
#### split 9:  IF_SMALLER_OR_EQUAL int anon__4 int p 11
	movl -28(%rbp), %r10d
	movl -12(%rbp), %r11d
	cmpl %r11d, %r10d
	jle split_11
#### split 10:  GOTO 14
	jmp split_14
split_11:
#### split 11:  PLUS int i int const__3 (= 1) int anon__5 
	# Math operation - Start: anon__5 = i addl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -32(%rbp)
	# Math operation - End: anon__5 = i addl $1
#### split 12:  ASSIGN int anon__5  int i 
	movl -32(%rbp), %r10d
	movl %r10d, -16(%rbp)     # i = anon__5
#### split 13:  GOTO 7
	jmp split_7
split_14:
#### split 14:  TIMES int j int const__4 (= 4) int anon__6 
	# Multiplication - Start: anon__6 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -36(%rbp)
	# Multiplication - End: anon__6 = j x $4
#### split 15:  ARRAY ACCESS int[10] a int anon__6 int anon__7 
## Array access START - anon__7 = a[anon__6]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -36(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -40(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__7 = a[anon__6]
#### split 16:  IF_GREATER int anon__7 int p 18
	movl -40(%rbp), %r10d
	movl -12(%rbp), %r11d
	cmpl %r11d, %r10d
	jg split_18
#### split 17:  GOTO 21
	jmp split_21
split_18:
#### split 18:  MINUS int j int const__5 (= 1) int anon__8 
	# Math operation - Start: anon__8 = j subl $1
	movl -20(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -44(%rbp)
	# Math operation - End: anon__8 = j subl $1
#### split 19:  ASSIGN int anon__8  int j 
	movl -44(%rbp), %r10d
	movl %r10d, -20(%rbp)     # j = anon__8
#### split 20:  GOTO 14
	jmp split_14
split_21:
#### split 21:  IF_SMALLER int i int j 23
	movl -16(%rbp), %r10d
	movl -20(%rbp), %r11d
	cmpl %r11d, %r10d
	jl split_23
#### split 22:  GOTO 5
	jmp split_5
split_23:
#### split 23:  TIMES int i int const__6 (= 4) int anon__9 
	# Multiplication - Start: anon__9 = i x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__9 = i x $4
#### split 24:  ARRAY ACCESS int[10] a int anon__9 int anon__10 
## Array access START - anon__10 = a[anon__9]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -52(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__10 = a[anon__9]
#### split 25:  ASSIGN int anon__10  int temp 
	movl -52(%rbp), %r10d
	movl %r10d, -56(%rbp)     # temp = anon__10
#### split 26:  TIMES int i int const__7 (= 4) int anon__11 
	# Multiplication - Start: anon__11 = i x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -60(%rbp)
	# Multiplication - End: anon__11 = i x $4
#### split 27:  TIMES int j int const__8 (= 4) int anon__12 
	# Multiplication - Start: anon__12 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -64(%rbp)
	# Multiplication - End: anon__12 = j x $4
#### split 28:  ARRAY ACCESS int[10] a int anon__12 int anon__13 
## Array access START - anon__13 = a[anon__12]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -64(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -68(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__13 = a[anon__12]
#### split 29:  ARRAY MODIFICATION int[10] a int anon__11 int anon__13 
## Array modification START - a[anon__11] = anon__13
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -60(%rbp), %r11d
	mov  $0, %r12
	movl -68(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__11] = anon__13
#### split 30:  TIMES int j int const__9 (= 4) int anon__14 
	# Multiplication - Start: anon__14 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -72(%rbp)
	# Multiplication - End: anon__14 = j x $4
#### split 31:  ARRAY MODIFICATION int[10] a int anon__14 int temp 
## Array modification START - a[anon__14] = temp
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -72(%rbp), %r11d
	mov  $0, %r12
	movl -56(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__14] = temp
#### split 32:  GOTO 5
	jmp split_5
split_33:
#### split 33:  TIMES int start int const__10 (= 4) int anon__15 
	# Multiplication - Start: anon__15 = start x $4
	movq 24(%rbp), %rax
	movl $4, %r10d
	imull %r10d
	movl %eax, -76(%rbp)
	# Multiplication - End: anon__15 = start x $4
#### split 34:  TIMES int j int const__11 (= 4) int anon__16 
	# Multiplication - Start: anon__16 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -80(%rbp)
	# Multiplication - End: anon__16 = j x $4
#### split 35:  ARRAY ACCESS int[10] a int anon__16 int anon__17 
## Array access START - anon__17 = a[anon__16]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -80(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -84(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__17 = a[anon__16]
#### split 36:  ARRAY MODIFICATION int[10] a int anon__15 int anon__17 
## Array modification START - a[anon__15] = anon__17
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -76(%rbp), %r11d
	mov  $0, %r12
	movl -84(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__15] = anon__17
#### split 37:  TIMES int j int const__12 (= 4) int anon__18 
	# Multiplication - Start: anon__18 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -88(%rbp)
	# Multiplication - End: anon__18 = j x $4
#### split 38:  ARRAY MODIFICATION int[10] a int anon__18 int p 
## Array modification START - a[anon__18] = p
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -88(%rbp), %r11d
	mov  $0, %r12
	movl -12(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__18] = p
#### split 39:  RETURN int j   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -20(%rbp), %eax  # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# qsort: function(int[10],int,int) -> int
#####################################################
.type qsort, @function
qsort:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $116, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### qsort 0:  IF_GREATER_OR_EQUAL int start int end 2
	movq 24(%rbp), %r10
	movq 16(%rbp), %r11
	cmpl %r11d, %r10d
	jge qsort_2
#### qsort 1:  GOTO 3
	jmp qsort_3
qsort_2:
#### qsort 2:  RETURN int const__13 (= 0)   
	movq $0, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
qsort_3:
#### qsort 3:  GET_ADDRESS int[10] a  address anon__20 
	movq 32(%rbp), %r10
	movq %r10, -8(%rbp)
#### qsort 4:  PARAM address anon__20   
	movq -8(%rbp), %r10
	pushq %r10
#### qsort 5:  PARAM int start   
	xor %r10, %r10
	movq 24(%rbp), %r10
	pushq %r10
#### qsort 6:  PARAM int end   
	xor %r10, %r10
	movq 16(%rbp), %r10
	pushq %r10
#### qsort 7:  CALL split: function(int[10],int,int) -> int   
	call split
#### qsort 8:  GETRETURN   int anon__19 
	movl %eax, -12(%rbp)
#### qsort 9:  ASSIGN int anon__19  int s 
	movl -12(%rbp), %r10d
	movl %r10d, -16(%rbp)     # s = anon__19
#### qsort 10:  MINUS int s int const__14 (= 1) int anon__21 
	# Math operation - Start: anon__21 = s subl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -20(%rbp)
	# Math operation - End: anon__21 = s subl $1
#### qsort 11:  GET_ADDRESS int[10] a  address anon__23 
	movq 32(%rbp), %r10
	movq %r10, -28(%rbp)
#### qsort 12:  PARAM address anon__23   
	movq -28(%rbp), %r10
	pushq %r10
#### qsort 13:  PARAM int start   
	xor %r10, %r10
	movq 24(%rbp), %r10
	pushq %r10
#### qsort 14:  PARAM int anon__21   
	xor %r10, %r10
	movl -20(%rbp), %r10d
	pushq %r10
#### qsort 15:  CALL qsort: function(int[10],int,int) -> int   
	call qsort
#### qsort 16:  GETRETURN   int anon__22 
	movl %eax, -32(%rbp)
#### qsort 17:  PLUS int s int const__15 (= 1) int anon__24 
	# Math operation - Start: anon__24 = s addl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -36(%rbp)
	# Math operation - End: anon__24 = s addl $1
#### qsort 18:  GET_ADDRESS int[10] a  address anon__26 
	movq 32(%rbp), %r10
	movq %r10, -44(%rbp)
#### qsort 19:  PARAM address anon__26   
	movq -44(%rbp), %r10
	pushq %r10
#### qsort 20:  PARAM int anon__24   
	xor %r10, %r10
	movl -36(%rbp), %r10d
	pushq %r10
#### qsort 21:  PARAM int end   
	xor %r10, %r10
	movq 16(%rbp), %r10
	pushq %r10
#### qsort 22:  CALL qsort: function(int[10],int,int) -> int   
	call qsort
#### qsort 23:  GETRETURN   int anon__25 
	movl %eax, -48(%rbp)
#### qsort 24:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# printArray: function(int[10],int,int) -> int
#####################################################
.type printArray, @function
printArray:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $84, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### printArray 0:  ASSIGN int const__16 (= 0)  int a 
	movl $0, -4(%rbp)     # a = 0
printArray_1:
#### printArray 1:  IF_SMALLER int a int count 3
	movl -4(%rbp), %r10d
	movq 24(%rbp), %r11
	cmpl %r11d, %r10d
	jl printArray_3
#### printArray 2:  GOTO 14
	jmp printArray_14
printArray_3:
#### printArray 3:  IF_NOT_EQUAL int withIndex int const__17 (= 0) 5
	movq 16(%rbp), %r10
	movl $0, %r11d
	cmpl %r11d, %r10d
	jne printArray_5
#### printArray 4:  GOTO 7
	jmp printArray_7
printArray_5:
#### printArray 5:  WRITE int a   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### printArray 6:  WRITE char const__18 (= ':')   
	movq $0, %rdi
	movl $58, %edi
	call printChar
printArray_7:
#### printArray 7:  TIMES int a int const__19 (= 4) int anon__27 
	# Multiplication - Start: anon__27 = a x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__27 = a x $4
#### printArray 8:  ARRAY ACCESS int[10] n int anon__27 int anon__28 
## Array access START - anon__28 = n[anon__27]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -8(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -12(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__28 = n[anon__27]
#### printArray 9:  WRITE int anon__28   
	movq $0, %rdi
	movl -12(%rbp), %edi
	call printInteger
#### printArray 10:  WRITE char const__20 (= 'newline')   
	movq $0, %rdi
	movl $10, %edi
	call printChar
#### printArray 11:  PLUS int a int const__21 (= 1) int anon__29 
	# Math operation - Start: anon__29 = a addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__29 = a addl $1
#### printArray 12:  ASSIGN int anon__29  int a 
	movl -16(%rbp), %r10d
	movl %r10d, -4(%rbp)     # a = anon__29
#### printArray 13:  GOTO 1
	jmp printArray_1
printArray_14:
#### printArray 14:  RETURN    
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
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $108, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### main 0:  ASSIGN int const__22 (= 0)  int i 
	movl $0, -4(%rbp)     # i = 0
main_1:
#### main 1:  IF_SMALLER int i int const__23 (= 5) 3
	movl -4(%rbp), %r10d
	movl $5, %r11d
	cmpl %r11d, %r10d
	jl main_3
#### main 2:  GOTO 10
	jmp main_10
main_3:
#### main 3:  READ int j   
	call readInt
	movl %eax, -8(%rbp)
#### main 4:  GET_ADDRESS int[5] numbers  address anon__31 
	movq %rbp, -36(%rbp)     # Setting up array address
	addq $-36, -36(%rbp)      # Setting up array address
	movq -36(%rbp), %r10
	movq %r10, -44(%rbp)
#### main 5:  TIMES int i int const__24 (= 4) int anon__30 
	# Multiplication - Start: anon__30 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__30 = i x $4
#### main 6:  ARRAY MODIFICATION address anon__31 int anon__30 int j 
## Array modification START - anon__31[anon__30] = j
	movq -44(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	mov  $0, %r12
	movl -8(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__31[anon__30] = j
#### main 7:  PLUS int i int const__25 (= 1) int anon__32 
	# Math operation - Start: anon__32 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -52(%rbp)
	# Math operation - End: anon__32 = i addl $1
#### main 8:  ASSIGN int anon__32  int i 
	movl -52(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__32
#### main 9:  GOTO 1
	jmp main_1
main_10:
#### main 10:  GET_ADDRESS int[5] numbers  address anon__34 
	movq -36(%rbp), %r10
	movq %r10, -60(%rbp)
#### main 11:  PARAM address anon__34   
	movq -60(%rbp), %r10
	pushq %r10
#### main 12:  PARAM int const__26 (= 0)   
	pushq $0
#### main 13:  PARAM int const__27 (= 4)   
	pushq $4
#### main 14:  CALL qsort: function(int[10],int,int) -> int   
	call qsort
#### main 15:  GETRETURN   int anon__33 
	movl %eax, -64(%rbp)
#### main 16:  WRITE char const__28 (= 'newline')   
	movq $0, %rdi
	movl $10, %edi
	call printChar
#### main 17:  GET_ADDRESS int[5] numbers  address anon__36 
	movq -36(%rbp), %r10
	movq %r10, -72(%rbp)
#### main 18:  PARAM address anon__36   
	movq -72(%rbp), %r10
	pushq %r10
#### main 19:  PARAM int const__29 (= 5)   
	pushq $5
#### main 20:  PARAM int const__30 (= 1)   
	pushq $1
#### main 21:  CALL printArray: function(int[10],int,int) -> int   
	call printArray
#### main 22:  GETRETURN   int anon__35 
	movl %eax, -76(%rbp)
#### main 23:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
