	.text
foo.type foo, @function
foo:
main	.globl main
.type main, @function
main:
	call print_int
hello world!