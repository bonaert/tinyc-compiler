
# Transform C code in assembly code
if [ -f "$1.c" ]; then
	gcc "$1.c" -S -o "$1.s" 
fi

# Transform assembly code into an object file
echo "$1.s"
as "$1.s" -o "$1.o"

# Create an executable by link the object file with:
# /lib64/ld-linux-x86-64.so.2: the binary will use the dynamic linker, /lib/ld-linux.so
# /usr/lib/x86_64-linux-gnu/crt1.o: contains _start, which will be the entry point for the ELF binary
# /usr/lib/x86_64-linux-gnu/crti.o: before libc, initialization code
# /usr/lib/x86_64-linux-gnu/crtn.o: after libc, finalisation code

ld -o "$1" -dynamic-linker /lib64/ld-linux-x86-64.so.2 \
  /usr/lib/x86_64-linux-gnu/crt1.o \
  /usr/lib/x86_64-linux-gnu/crti.o \
  -lc "$1.o" \
  /usr/lib/x86_64-linux-gnu/crtn.o