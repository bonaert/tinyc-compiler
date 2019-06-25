#include <stdlib.h>
#include "array.h"



/* Returns size of each element of the array (example: char[10][12] -> 1)*/
int arrayElementSize(SYMBOL_INFO* array) {
    TBASIC baseType = array->type->info.array.base->type;
    if (baseType == char_t) {
        return sizeof(char);
    } else if (baseType == int_t) {
        return sizeof(int);
    } else {
        fprintf(stderr, "Array has illegal type %d", baseType);
        exit(1);
    }
} 




/* -------------------------------------------------------------------------- */
/*                               Dimensions list                              */
/* -------------------------------------------------------------------------- */


DIMENSIONS* initDimensions() {
    DIMENSIONS* dimensions = malloc(sizeof(DIMENSIONS));
    dimensions->numDimensions = 0;
    dimensions->dimensions = malloc(20 * sizeof(int));
    return dimensions;
}

void addDimension(DIMENSIONS* dimensions, int dimension){
    if (dimensions->numDimensions == 20) {
        fprintf(stderr, "An array can't have more than 20 dimensions");
        exit(1);
    }

    if (dimension <= 0) {
        int dimensionNum = dimensions->numDimensions + 1;
        fprintf(stderr, "Dimensions must be positive but dimension %d of the array is %d", dimensionNum, dimension);
        exit(1);
    }
    
    dimensions->dimensions[dimensions->numDimensions] = dimension;
    dimensions->numDimensions++;
}

int areDimensionsEqual(DIMENSIONS* dimensions1, DIMENSIONS* dimensions2) {
    if (dimensions1->numDimensions != dimensions2->numDimensions) return 0;

    for(int i = 0; i < dimensions1->numDimensions; i++){
        if (dimensions1->dimensions[i] != dimensions2->dimensions[i]) return 0;
    }
    
    return 1;
}




/* return size of dimension 'dimension' of array */
int arrayDimSize(SYMBOL_INFO* array, int dimension) {
    return array->type->info.array.dimensions->dimensions[dimension - 1];
} 




int getArrayTotalSize(TYPE_INFO* type) {
    int res = 1;
    DIMENSIONS* dimensions = type->info.array.dimensions;
    for(int i = 0; i < dimensions->numDimensions; i++) {
        res = res * dimensions->dimensions[i];
    }
    return res;
}