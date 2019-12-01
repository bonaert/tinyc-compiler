<img src="https://github.com/bonaert/tinyc-compiler/raw/master/logo.png" height="100" alt="Logo"> **compiler**

Implementation of a compiler for a subset of C called Tiny C. The TinyC compiler was built entirely from scratch in pure C, with use of Lex for lexing and Bison for parsing. The compiler does **lexing**, **parsing**, **syntactic checking**, **type checking**, **semantic checking**, **conversion into an intermediate representation (IR)**, **optimization and simplification** and finally outputs a valid **x86 64 assembly file**. A linker script allow you to easily turn the assembly file into an executable file.

To run the compiler, with full debug output, link the assembly and run the executable, you can do:

`bash ./run.sh factorialRecursive`

*Note: no connection to Fabrice Bellard's amazing [TinyC compiler](https://bellard.org/tcc/).*

# Demos

## Recursive fibonacci

```c
int fibonacci(int n) {
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
}
```

Output of `tinyc < fibonacciRecursive.tc && ./fibonacciRecursive`:
```
factorial(0) = 1
factorial(1) = 1
factorial(2) = 2
factorial(3) = 6
factorial(4) = 24
factorial(5) = 120
factorial(6) = 720
factorial(7) = 5040
factorial(8) = 40320
factorial(9) = 362880
```

## Quicksort + IO

```c
int split(int[10] a, int start, int end) {
    int p = a[start];
    int i = start;
    int j = end;
    int temp;

    while(i < j) {
        while(a[i] <= p) {
            i = i + 1;
        }

        while(a[j] > p) {
            j = j - 1;
        }

        if (i < j) {
            temp = a[i];
            a[i] = a[j];
            a[j] = temp;
        }
    }

    a[start] = a[j];
    a[j] = p;
    return j;
}

int qsort(int[10] a, int start, int end) {
    if(start >= end) {
        return 0;
    }
    int s = split(a, start, end);
    qsort(a, start, s - 1);
    qsort(a, s + 1, end);
}

int printArray(int[10] n, int count, int withIndex) {
    int a = 0;
    while (a < count) {
        if (withIndex != 0) {
            write a;
            write ':';
        }  
        write n[a];
        write '\n';
        a = a + 1;
    }
}


int main(){
    int i;
    int j;
    int[5] numbers;
    write "Please enter the 5 numbers you want to sort (on different lines)\n";

    int receive;
    i = 0;
    while (i < 5) {
        read j;
        numbers[i] = j;
        i = i + 1;
    };

    qsort(numbers, 0, 4);

    write "\nThe sorted numbers are\n";
    printArray(numbers, 5, 0);
}
```

```bash
$ tinyc < quicksort.tc && quicksort 
Please enter the 5 numbers you want to sort (on different lines)
5
-7
8
99
-4

The sorted numbers are
-7
-4
5
8
99
```


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

# Limitations / Simplifications

Some features are not implemented to leave the implementation simple and due to a lack of time:

- Sophisticated register allocation algorithms
- Library support
- Advanced IO
- Preprocessing
- For loops - a good first improvement if you're interested
- Inter basic block optimisation
- Dead variable elimination

# Structure of the compiler

The compiler translates the TinyC file into assembly by doing the following steps (a good starting point to explore the code is mentionned for each step):

1. Lexing: we use GNU Lex to lex tokens (basic elements of the language) - [lex.l](https://github.com/bonaert/tinyc-compiler/blob/master/src/lex.l)
2. Parsing and creation of the IR code: we parse the tokens to understand the more meaninful constructs (functions, if, while) ([tinyc.y](https://github.com/bonaert/tinyc-compiler/blob/master/src/tinyc.y)), create the IR representation of the code ([intermediate.c](https://github.com/bonaert/tinyc-compiler/blob/master/src/intermediate.c)) and to syntactic/semantic/type checking ([check.c](https://github.com/bonaert/tinyc-compiler/blob/master/src/check.c)). 
3. Program optimization - [optimise.c](https://github.com/bonaert/tinyc-compiler/blob/master/src/optimise.c), [basicBlock.c](https://github.com/bonaert/tinyc-compiler/blob/master/src/basicBlock.c), [analysis.c](https://github.com/bonaert/tinyc-compiler/blob/master/src/analysis.c):
    - Mathematical simplification
    - Graph analysis
    - Duplicate expression removal & expression simplification
4. Conversion of the IR code into x86 64 assembly - [assembly.c](https://github.com/bonaert/tinyc-compiler/blob/master/src/assembly.c)

# Testing

The program has test files which evaluate the majority of the language features, error checking, conversions and type checking. They are present in the `src/testfiles` directory. The compiler currently outputs debug information to stdout and error information to stderr to ensure the user can examine the compiler's inner workings.

Bash files are provided to make testing easier. The `run.sh` and `runUnoptimised.sh` compiles the program, showing the unoptimized IR code and the optimized IR code at different stages for `run.sh`, links the assembly to create an executable, and the runs the executable. Example: `bash ./run.sh fibonacciRecursive`.

## Feature testing

- Basic tests: [simpler.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/simpler.tc), [simpler.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/simpler.tc)
- String: [string.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/string.tc)
- Arrays: [array.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/array.tc), [arrayAssignment.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/arrayAssignment.tc), [arrayMultidimensional.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/arrayMultidimensional.tc)
- Type convertion: [convertions.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/convertions.tc)
- If statements and boolean logic: [if.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/if.tc)
- Function calling and parameter passing: [functions.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/functions.tc), [parameters.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/parameters.tc)
- While statements: [factorial.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/factorial.tc)
- Recursion: [factorialRecursive.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/factorialRecursive.tc)
- Test programs: [bubblesort.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/bubblesort.tc), [quicksort.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/quicksort.tc), [dotProduct.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/dotProduct.tc)
- Compile time optimisation: [mathsimplify.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/mathsimplify.tc)
- IO: [readWrite.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/readWrite.tc), [write.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/write.tc)


## Error checking

- Undefind variables: [error-undefined-var.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/error-undefined-var.tc)
- Basic lexical errors: [error-lexical.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/error-lexical.tc)
- Invalid types for function parameters: [error-funcall-type.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/error-funcall-type.tc)
- Variable redeclaration: [error-double-decl-stmt.tc](https://github.com/bonaert/tinyc-compiler/blob/master/src/testfiles/error-double-decl-stmt.tc)

