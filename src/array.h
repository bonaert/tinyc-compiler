#ifndef ARRAYGUARD
#define ARRAYGUARD

#include "symbol.h"

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

/* return size of dimension 'dimension' of array */
int arrayDimSize(SYMBOL_INFO* array, int dimension);

/* return constant C associated with array */
//int arrayBase(SYMBOL_INFO* array); 

/* return size of element of array */
int arrayElementSize(SYMBOL_INFO* array);

int areDimensionsEqual(DIMENSIONS* dimensions1, DIMENSIONS* dimensions2);




typedef struct dimensions {
    int* dimensions;
    int numDimensions;
} DIMENSIONS;


DIMENSIONS* initDimensions();
void addDimension(DIMENSIONS* dimensions, int dimension);

int getArrayTotalSize(TYPE_INFO* array);

#endif