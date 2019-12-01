# TinyC compiler

Implementation of a compiler for a subset of C called Tiny C. The TinyC compiler was built entirely from scratch in pure C, with use of Lex for lexing and Bison for parsing. 

# Demo 
Example program:

`int fibonacci(int n) {
    if (n < 2) {
        return 1;
    } else {
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

int main() {
    int i = 0;
    while (i < 10) {
        write "fibonacci(";
        write i;
        write ") = ";
        write fibonacci(i);
        write "\n";
        i = i + 1;
    }

    return 1;
}`

Output of `tinyc < fibonacciRecursive.tc && ./fibonacciRecursive`:
`factorial(0) = 1
factorial(1) = 1
factorial(2) = 2
factorial(3) = 6
factorial(4) = 24
factorial(5) = 120
factorial(6) = 720
factorial(7) = 5040
factorial(8) = 40320
factorial(9) = 362880
`
# Features

The TinyC supports the following **features**:
- Basic types: int, char, strings, array, multidimensional array (example: int[10][20])
- Control flow structures: if, while
- Boolean logic: and, or
- Automatic convertion between types
- Type checking (errors if types incompatible and warnings if potentially dangerous convertion between types)
- Functions
- Recursion (self recursion and mutual recursion)
- Simple IO: READ and WRITE primitives
- Program optimization: compile time computation, avoiding duplicate computation, expression simplification, graph analysis

# Structure of the compiler

The compiler translates the TinyC file into assembly by doing the following steps:

1) Lexing
2) Parsing
3) Conversion into an Intermediate Representation (IR) language
4) Program optimization:
  - Mathematical simplification
  - Graph analysis
  - Duplicate expression removal & expression simplification
5) Conversion of the IR code into x86 64 assembly





TinyC compiler (lexer + parser + IR + optimization + x86 assembly generation)


