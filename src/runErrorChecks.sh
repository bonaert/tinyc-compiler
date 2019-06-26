#!/bin/bash

checkThrowsError() {
    outputOfNonOptimised=$(./runUnoptimised.sh "$1")
    outputOfOptimised=$(./run.sh "$1")
    
    # Check they both fail in their compilation
    if echo "$outputOfNonOptimised" | grep -q 'error'; then
        echo "Non optimised - threw error for $1.tc"
    else
        echo "Non optimised - PROBLEM - didn't throw error for $1.tc"
    fi

    if echo "$outputOfOptimised" | grep -i -q 'error'; then
        echo "    Optimised - threw error for $1.tc"
    else
        echo "    Optimised - PROBLEM - didn't throw error for $1.tc"
    fi
}

for f in testfiles/error-*.tc ; do
    checkThrowsError $(basename "$f" .tc)
done