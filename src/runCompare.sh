#!/bin/bash

compare() {
    #echo "Running unoptimised version of $1"
    outputOfNonOptimised=$(./runUnoptimised.sh "$1")
    #echo "$outputOfNonOptimised"

    #echo "Running optimised version of $1"
    outputOfOptimised=$(./run.sh "$1")
    #echo "$outputOfOptimised"
    
    # Check they both succeded in their execution
    if echo "$outputOfNonOptimised" | grep -i -q 'error'; then
        echo "Non optimized compilation of $1 lead to error!"
        exit
    fi

     if echo "$outputOfOptimised" | grep -i -q 'error'; then
        echo "Optimized compilation of $1 lead to error!"
        exit
    fi


    programOutputOfNonOptimised=$(echo -e "$outputOfNonOptimised" | sed -n -e '/Running the executable file/, $p' )
    programOutputOfOptimised=$(echo -e "$outputOfOptimised" | sed -n -e '/Running the executable file/, $p' | sed '/./,$!d')

    
    nonOptimisedOutputHashed=$(echo -e "$programOutputOfNonOptimised" | md5sum)
    optimisedOutputHashed=$(echo -e "$programOutputOfOptimised" | md5sum)

    if [[ $optimisedOutputHashed == $nonOptimisedOutputHashed ]]; then 
        echo "Success: $1"; 
    else 
        echo "Failure - Outputs are different: $1";
        echo "Output of non optimised version";
        echo -e "$programOutputOfNonOptimised"
        echo "";
        echo "";
        echo "Output of optimised version";
        echo -e "$programOutputOfOptimised"
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
compare "fibonacciRecursive"
compare "fibonacciRecursive2"
compare "functions"
compare "if"
#compare "jump"  <- infinite loop in here
compare "mathsimplify"
compare "parameters"
compare "simple"
compare "simpler"
compare "string"
compare "write"

