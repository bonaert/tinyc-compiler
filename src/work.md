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
- [ ] Implement the algorithm to find out to which register each symbolic register should be associated
- [ ] Implement the logic to put on the stack and pop back from the stack the symbolic register that couldn't be associated to a real register

### Instructions

- [x] Get register / Setup Symbol
- [x] Push / Pop
- [x] Move
- [x] Jump
- [ ] Function calls: params, call, return DONE; need to save registers
- [x] Math: +, -, times, divide
- [x] Syscalls: write, read 
- [x] LENGTH: Length of an array
- [x] AAC: array access
- [x] AAS: array modification
- [x] ADDR: get address


### Example programs

- [x] Bubble sort

