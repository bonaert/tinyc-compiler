#!/bin/bash

compare() {
    #echo "Running unoptimised version of $1"
    outputOfNonOptimised=$(./runUnoptimised.sh "$1")
    #echo "$outputOfNonOptimised"

    #echo "Running optimised version of $1"
    outputOfOptimised=$(./run.sh "$1")
    #echo "$outputOfOptimised"
    
    # Check they both succeded in their execution
    if echo "$outputOfNonOptimised" | grep -q 'error'; then
        echo "Non optimized compilation of $1 lead to error!"
        exit
    fi

     if echo "$outputOfOptimised" | grep -i -q 'error'; then
        echo "Optimized compilation of $1 lead to error!"
        exit
    fi


    outputOfNonOptimised=$(echo "$outputOfNonOptimised" | sed -n -e '/Running the executable file/, $p')
    outputOfOptimised=$(echo "$outputOfOptimised" | sed -n -e '/Running the executable file/, $p')

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


#compare "error-undefined-var"

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

