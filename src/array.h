#ifndef ARRAYGUARD
#define ARRAYGUARD

#include "symbol.h"


/* Returns size of each element of the array (example: char[10][12] -> 1)*/
int arrayElementSize(SYMBOL_INFO* array);

/* -------------------------------------------------------------------------- */
/*                            Position in the array                           */
/* -------------------------------------------------------------------------- */

typedef struct leftValue {
    SYMBOL_INFO* offset;
    SYMBOL_INFO* place;
    TBASIC typeKind;
} LEFT_VALUE;

typedef struct arrayAccessInfo {
    SYMBOL_INFO* place;
    SYMBOL_INFO* array;
    int ndim;
} ARRAY_ACCESS_INFO;


/* -------------------------------------------------------------------------- */
/*                                 Dimensions                                 */
/* -------------------------------------------------------------------------- */

typedef struct dimensions {
    int* dimensions;
    int numDimensions;
} DIMENSIONS;


DIMENSIONS* initDimensions();
void addDimension(DIMENSIONS* dimensions, int dimension);
int areDimensionsEqual(DIMENSIONS* dimensions1, DIMENSIONS* dimensions2);

/* return size of dimension 'dimension' of array */
int arrayDimSize(SYMBOL_INFO* array, int dimension);

int getArrayTotalSize(TYPE_INFO* array);

#endif