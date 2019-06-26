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
	sub $192, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
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
#### main 28:  WRITE char const__29 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 29:  IF_SMALLER_OR_EQUAL int const__30 (= 10) int const__31 (= 0) 33
#### main 30:  IF_SMALLER_OR_EQUAL int const__32 (= 10) int const__33 (= 0) 33
#### main 31:  WRITE char const__34 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
#### main 32:  GOTO 34
	jmp main_34
main_33:
#### main 33:  WRITE char const__35 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
main_34:
#### main 34:  IF_SMALLER_OR_EQUAL int const__36 (= 10) int const__37 (= 0) 38
#### main 35:  IF_GREATER_OR_EQUAL int const__38 (= 10) int const__39 (= 0) 38
	jmp main_38
#### main 36:  WRITE char const__40 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
#### main 37:  GOTO 39
	jmp main_39
main_38:
#### main 38:  WRITE char const__41 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
main_39:
#### main 39:  IF_GREATER_OR_EQUAL int const__42 (= 10) int const__43 (= 0) 43
	jmp main_43
#### main 40:  IF_SMALLER_OR_EQUAL int const__44 (= 10) int const__45 (= 0) 43
#### main 41:  WRITE char const__46 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
#### main 42:  GOTO 44
	jmp main_44
main_43:
#### main 43:  WRITE char const__47 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
main_44:
#### main 44:  IF_GREATER_OR_EQUAL int const__48 (= 10) int const__49 (= 0) 48
	jmp main_48
#### main 45:  IF_GREATER_OR_EQUAL int const__50 (= 10) int const__51 (= 0) 48
	jmp main_48
#### main 46:  WRITE char const__52 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
#### main 47:  GOTO 49
	jmp main_49
main_48:
#### main 48:  WRITE char const__53 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
main_49:
#### main 49:  WRITE char const__54 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 50:  IF_GREATER int const__55 (= 10) int const__56 (= 0) 53
	jmp main_53
#### main 51:  GOTO 52
	jmp main_52
main_52:
#### main 52:  IF_SMALLER_OR_EQUAL int const__57 (= 10) int const__58 (= 0) 55
main_53:
#### main 53:  WRITE char const__59 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
#### main 54:  GOTO 56
	jmp main_56
main_55:
#### main 55:  WRITE char const__60 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
main_56:
#### main 56:  IF_GREATER int const__61 (= 10) int const__62 (= 0) 59
	jmp main_59
#### main 57:  GOTO 58
	jmp main_58
main_58:
#### main 58:  IF_GREATER_OR_EQUAL int const__63 (= 10) int const__64 (= 0) 61
	jmp main_61
main_59:
#### main 59:  WRITE char const__65 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
#### main 60:  GOTO 62
	jmp main_62
main_61:
#### main 61:  WRITE char const__66 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
main_62:
#### main 62:  IF_SMALLER int const__67 (= 10) int const__68 (= 0) 65
#### main 63:  GOTO 64
	jmp main_64
main_64:
#### main 64:  IF_SMALLER_OR_EQUAL int const__69 (= 10) int const__70 (= 0) 67
main_65:
#### main 65:  WRITE char const__71 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
#### main 66:  GOTO 68
	jmp main_68
main_67:
#### main 67:  WRITE char const__72 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
main_68:
#### main 68:  IF_SMALLER int const__73 (= 10) int const__74 (= 0) 71
#### main 69:  GOTO 70
	jmp main_70
main_70:
#### main 70:  IF_GREATER_OR_EQUAL int const__75 (= 10) int const__76 (= 0) 73
	jmp main_73
main_71:
#### main 71:  WRITE char const__77 (= 'E')   
	movq $0, %r10   # Empty register 
	movb $69, %r10b
	movq %r10, %rdi
	call printChar
#### main 72:  GOTO 74
	jmp main_74
main_73:
#### main 73:  WRITE char const__78 (= 'O')   
	movq $0, %r10   # Empty register 
	movb $79, %r10b
	movq %r10, %rdi
	call printChar
main_74:
#### main 74:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
