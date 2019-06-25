compare() {
    #echo "Running unoptimised version of $1"
    outputOfNonOptimised=$(./runUnoptimised.sh "$1" | sed -n -e '/Running the executable file/,$p')
    #echo "$outputOfNonOptimised"

    #echo "Running optimised version of $1"
    outputOfOptimised=$(./run.sh "$1" | sed -n -e '/Running the executable file/, $p')
    #echo "$outputOfOptimised"
    
    


    optimisedOutputHashed=$(echo -e "$outputOfOptimised" | md5sum)
    nonOptimisedOutputHashed=$(echo -e "$outputOfNonOptimised" | md5sum)

    if [[ $optimisedOutputHashed == $nonOptimisedOutputHashed ]]; then 
        echo "Success: $1"; 
    else 
        echo "Failure - Outputs are different: $1";
        echo "Output of non optimised version";
        echo -e "$outputOfNonOptimised"
        echo "";
        echo "";
        echo "Output of optimised version";
        echo -e "$outputOfOptimised"
        echo ""; 
    fi
}



compare "array"
compare "arrayMultidimensional"
compare "basic"
compare "convertions"
compare "exampleWhileIf"
compare "factorial"
compare "factorialRecursive"
compare "functions"
compare "if"
#compare "jump"  <- infinite loop in here
compare "mathsimplify"
compare "parameters"
compare "simple"
compare "simpler"

