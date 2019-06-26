# Tokenization (Flex)

- [x] Choose tokens
- [x] Implement Lex file

# Parsing (Bison)

- [x] Write down grammar
- [x] Improve grammar so that it's more programmer friendly: variable declarations can happen after statements, if/if-else/while allows multiple statements in their blocks, no semicolon needed after a block, ...
- [x] Declarations: Create symbols with name and type information
- [x] Parse boolean operators
- [x] Parse if, if-else and while statements
- [x] Parse function calls
- [x] Parse array declarations
- [x] Parse array accesses
- [x] Symbol use: check that the symbol exists in the relevant scopes
- [x] Do type checking: assignments, comparisons, function calls, array accesses, ...


# Intermediate Representation (IR)

- [x] Decide on representation for the IR: 3 Access Code (3AC)
- [x] Generate the appropriate 3AC codes
- [x] Handle function calls
- [x] Handle backpatching for if/if-else/while statements
- [x] Handle array accesses even for high-dimensional arrays

# Code generation

- [x] Create a function that converts each IR instruction into the appropriate assembler instructions 
- [x] Implement the algorithm to find out to which register each symbolic register should be associated
- [x] Implement the logic to put on the stack and pop back from the stack the symbolic register that couldn't be associated to a real register

# Optimisation

- [x] Peephole optimisations
- [x] Constant folding
- [x] Basic block optimisation using graphs

### Instructions

- [x] Get register / Setup Symbol
- [x] Push / Pop
- [x] Move
- [x] Jump
- [x] Function calls: params, call, return DONE
- [x] Math: +, -, times, divide
- [x] Syscalls: write, read 
- [x] LENGTH: Length of an array
- [x] AAC: array access
- [x] AAS: array modification
- [x] ADDR: get address


### Example programs

- [x] Bubble sort
- [x] (Recursive) quick sort
- [x] Iterative fibonnaci
- [x] Recursive fibonnaci

### Todo

- [ ] Add ability to fetch subarray of matrix (e.g. char[5][5] c; char[5] d = c = [1]);
- [ ] Add strings
- [ ] Add writing char arrays


### Bugs

None known

### Questions

**Should I create a new scope for every while / if statement?**

If I don't do this, I may accept the following code.

int a;
read a;
if (a > 2) {
    int b;
    read b;
}
write b;

In this scenario, *b* is only created if we go inside the if-statement and so may be undefined 
when we try to write it. As such, it's better if this code is illegal, as it may lead to unsafe code.
