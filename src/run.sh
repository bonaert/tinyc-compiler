#!/bin/bash
filename=${1:?missing filename}

# Compile the TinyC compiler
echo -e "Running make\n--------------------- "
make

# Run the TinyC on the example file and save the assembly
echo -e "\n\nCompiling example TinyC file (stderr shown) with argument ${@:2}\n---------------------"
./tinyc ${@:2} < "testfiles/$filename.tc"  1>"testfiles/$filename.s" 2>"testfiles/$filename.log" || { echo "Errors in compilation of $filename"; exit 1; }
cat "./testfiles/$filename.log"

#echo -e "\n\nCompiling example TinyC file (stderr hidden)\n---------------------"
#./tinyc < testfiles/basic.tc  1>testfiles/basic.s 2>/dev/null

# Go to testfiles directory
cd testfiles


echo -e "\n\nLinking the assembly and generating an executable\n---------------------"
# Link the assembly and create an executable
bash link.sh "$filename" || { echo "Errors assembling or linking $filename.s"; exit 1; }

echo -e "\n\nRunning the executable file\n---------------------"
# Run the executable
"./$filename"

# Add a newline
echo ""

# Go back to previous directory
cd ..