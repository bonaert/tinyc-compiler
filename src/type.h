#ifndef TYPEGUARD
#define TYPEGUARD

#include <stdio.h> /* for FILE */


/*
 * We defined here the basic type data structures:
 * 
 * TBASIC: an enum of the different possibles types: ints, chars, functions and arrays
 * 
 * TFUNCTION: a struct containing the types of the arguments and the return type
 * TARRAY: a struct containing the type of the array
 * 
 * TYPE_INFO: contains the kind of type represented (one of the possibilities in ENUM) 
 *            and additional info for complex types (function and arrays).
 * TYPE_LIST: a list of types (used in TFUNCTION) - implemented as a linked list
 */

typedef struct dimensions DIMENSIONS;

typedef enum {
    int_t,
    char_t,
    function_t, 
    array_t
} TBASIC;


typedef struct {
    struct type_info* target;
    struct type_list* arguments;
} TFUNCTION;

typedef struct {
    struct type_info* base;
    DIMENSIONS* dimensions;
} TARRAY;

typedef struct type_info {
    TBASIC type;
    union {
        TFUNCTION function;
        TARRAY array;
    } info;
} TYPE_INFO;

typedef struct type_list {
    TYPE_INFO *type;
    struct type_list *next;
    struct type_list *prev;
} TYPE_LIST;


TYPE_INFO* createSimpleType(TBASIC typeKind);
TYPE_INFO* createFunctionType(TYPE_INFO* returnType, TYPE_LIST* argumentTypes);
TYPE_INFO* createArrayType(TYPE_INFO* baseType, DIMENSIONS* dimensions);

TYPE_LIST* insertTypeInList(TYPE_INFO* newType, TYPE_LIST* typeList);

int areTypesEqual(TYPE_INFO* type1, TYPE_INFO* type2);
int areTypeListsEqual(TYPE_LIST* typeList1, TYPE_LIST* argumentTypes);

void printType(FILE * output, TYPE_INFO* type);
void printTypeList(FILE * output, TYPE_LIST* type, char separator);

TYPE_INFO* getBaseType(TYPE_INFO* typeInfo);



#endif