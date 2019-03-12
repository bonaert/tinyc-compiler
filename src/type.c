#include "type.h"
#include "array.h"
#include <assert.h> /* for assert(condition) */
#include <stdio.h>  /* for fprintf() and friends */
#include <stdlib.h> /* for malloc() and friends */

static TYPE_LIST* currentTypeList = 0;

TYPE_INFO* getBaseType(TYPE_INFO* typeInfo){
    return (typeInfo->type == array_t) ? typeInfo->info.array.base : typeInfo;
}

int areTypesEqual(TYPE_INFO* t1, TYPE_INFO* t2) {
    if (t1 == t2) {
        return 1;  // If both pointers point to the same type, the types are equal
    } else if (t1->type != t2->type) {
        return 0;  // If the type's kind are different (ex: INT and ARRAY), the types are different
    }

    switch (t1->type) {
        case int_t:
        case char_t:
            return 1;  // In the case of INT and CHAR, if the kinds are equal then the types are equal
        case array_t:
            return areTypesEqual(t1->info.array.base, t2->info.array.base) &&
                   areDimensionsEqual(t1->info.array.dimensions, t2->info.array.dimensions);  // the types of the contents of the arrays must be equal
        case function_t:
            return areTypesEqual(t1->info.function.target, t2->info.function.target) &&          // same types for return values
                   areTypeListsEqual(t1->info.function.arguments, t2->info.function.arguments);  // same types for arguments
        default:
            assert(0);  // Should never happend, must lead to a crash.
    }
}

/**
 * Tries to find if the type was already created. If it already exists, it returns a pointer to
 * the already created (heap-allocated) type. Otherwise, returns 0.
 * 
 * The goal is to avoid re-allocating on the heap types that were already created, thus saving memory.
 */
TYPE_INFO* findType(TYPE_INFO* type) {
    TYPE_LIST* typeList;
    for (typeList = currentTypeList; typeList; typeList = typeList->next) {
        if (areTypesEqual(typeList->type, type)) {
            return typeList->type;
        }
    }
    return 0;
}

TYPE_LIST* getLastTypeCell(TYPE_LIST* typeList) {
    if (typeList == 0) { return 0; }
    for(; typeList->next; typeList = typeList->next) {}
    return typeList;
}

/**
 * Utility function that heap-allocates a TYPE_INFO object with the given typeKind
 * and adds it to the list of existing types. 
 * Returns a pointer to the TYPE_INFO that was created.
 */
TYPE_INFO* createType(TBASIC typeKind) {
    TYPE_INFO* type = malloc(sizeof(TYPE_INFO));
    type->type = typeKind;

    TYPE_LIST* typeList = insertTypeInList(type, currentTypeList);
    if (currentTypeList == 0) { currentTypeList = typeList; }
    return type;
}


TYPE_LIST* insertTypeInList(TYPE_INFO* newType, TYPE_LIST* typeList) {
    TYPE_LIST* typeCell = malloc(sizeof(TYPE_LIST));
    typeCell->type = newType;
    typeCell->next = 0;

    TYPE_LIST* lastTypeCell = getLastTypeCell(typeList);
    typeCell->prev = lastTypeCell;
    if (lastTypeCell != 0) { lastTypeCell->next = typeCell; }

    return typeList ? typeList : typeCell;
}

/**
 * Creates a TYPE_INFO describing either a INT or a CHAR; returns a pointer to it.
 * 
 * If the type has already been created in the past, we find it and return a pointer to 
 * the previously created TYPE_INFO (this is to save memory, since we avoid having several
 * times the same TYPE_INFO in memory).
 */
TYPE_INFO* createSimpleType(TBASIC typeKind) {
    TYPE_INFO type;
    type.type = typeKind;

    TYPE_INFO* foundType;
    if ((foundType = findType(&type))) {
        return foundType;
    } else {
        return createType(typeKind);
    }
}

/**
 * Creates a TYPE_INFO describing an function which return a value of type returnType
 * and takes as arguments values that have the types in argumentTypes.
 * 
 * If the type has already been created in the past, we find it and return a pointer to 
 * the previously created TYPE_INFO (this is to save memory, since we avoid having several
 * times the same TYPE_INFO in memory).
 */
TYPE_INFO* createFunctionType(TYPE_INFO* returnType, TYPE_LIST* argumentTypes) {
    TYPE_INFO type;
    type.type = function_t;
    type.info.function.target = returnType;
    type.info.function.arguments = argumentTypes;

    TYPE_INFO* typePt;
    if (!(typePt = findType(&type))) {
        typePt = createType(function_t);
        typePt->info.function.target = returnType;
        typePt->info.function.arguments = argumentTypes;
        return typePt;
    } else {
        return typePt;
    }
}

/**
 * Creates a TYPE_INFO describing an array which contains objects of type baseType.
 * 
 * If the type has already been created in the past, we find it and return a pointer to 
 * the previously created TYPE_INFO (this is to save memory, since we avoid having several
 * times the same TYPE_INFO in memory).
 */
TYPE_INFO* createArrayType(TYPE_INFO* baseType, DIMENSIONS* dimensions) {
    TYPE_INFO type;
    type.type = array_t;
    type.info.array.base = baseType;
    type.info.array.dimensions = dimensions;

    TYPE_INFO* typePt;
    if (!(typePt = findType(&type))) {
        typePt = createType(array_t);
        typePt->info.array.base = baseType;
        typePt->info.array.dimensions = dimensions;
        
        return typePt;
    } else {
        return typePt;
    }
}



/**
 * Returns 1 if the two type lists are equal, otherwise returns 0. 
 */
int areTypeListsEqual(TYPE_LIST* typeList1, TYPE_LIST* typeList2) {
    if (typeList1 == typeList2) {
        return 1;  // if both pointers point to the same type list, then the type lists are equal
    }

    // loop over both lists and compare types
    while (typeList1 && typeList2) {
        if (!areTypesEqual(typeList1->type, typeList2->type)) {
            return 0;
        }
        typeList1 = typeList1->next;
        typeList2 = typeList2->next;
    }

    // Return true if we reached the end of both list, which means they have same size
    return (typeList1 == NULL) && (typeList2 == NULL);
}

/*
 * Print a description of a type in the given output.
 */
void printType(FILE* output, TYPE_INFO* type) {
    if (type == 0){
        fprintf(output, "<type not declared>");
        return;
    }

    if (type->type == int_t) {
        fprintf(output, "int");
    } else if (type->type == char_t) {
        fprintf(output, "char");
    } else if (type->type == array_t) {
        fprintf(output, "array[");
        printType(output, type->info.array.base);
        fprintf(output, "]");
    } else if (type->type == function_t) {
        fprintf(output, "function(");
        printTypeList(output, type->info.function.arguments, ',');
        fprintf(output, ") -> ");
        printType(output, type->info.function.target);
    } else {
        fprintf(stderr, "unknown type %d", type->type);
        exit(1);
    }
}

/*
 * Print all a description of all the types in a type list in the given output, 
 * separating them by the character separator.
 */
void printTypeList(FILE* output, TYPE_LIST* type, char separator) {
    int i = 0;
    for (; type; type = type->next) {
        if (i > 0) {
            fprintf(output, "%c", separator);
        }
        printType(output, type->type);
        i++;
    }
}




int getTypeSize(TYPE_INFO* type) {
    TBASIC typeKind = type->type;
    if       (typeKind == char_t) { return sizeof(char); }
    else if  (typeKind == int_t) { return sizeof(int); }
    else if  (typeKind == array_t) { 
        return getArrayTotalSize(type) * getTypeSize(type->info.array.base);
    } else {
        fprintf(stderr, "Trying to get the symbol");
        exit(1);
    }
}