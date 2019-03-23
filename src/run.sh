# Compile the TinyC compiler
echo -e "Running make\n---------------------"
make

# Run the TinyC on the example file and save the assembly
echo -e "\n\nCompiling example TinyC file (stderr shown)\n---------------------"
./tinyc < testfiles/basic.tc  1>testfiles/basic.s

#echo -e "\n\nCompiling example TinyC file (stderr hidden)\n---------------------"
#./tinyc < testfiles/basic.tc  1>testfiles/basic.s 2>/dev/null

# Go to testfiles directory
cd testfiles


echo -e "\n\nLinking the assembly and generating an executable\n---------------------"
# Link the assembly and create an executable
bash link.sh basic

echo -e "\n\nRunning the executable file\n---------------------"
# Run the executable
./basic

# Go back to previous directory
cd ..