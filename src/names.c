#include "names.h"
#include "string.h"
/*
static char* buffer;
static int bufferSize;
static int nextName;

char* findName(char* name){
    char * position = buffer;
    int currentStringLength = strlen(position) + 1;  // We include the '\0' in the length
    for (; position < nextName; position += currentStringLength) {
        if (strcmp(name, position) == 0) {
            return position;
        }
    }
    return 0;
};

char* addName(char* name) {
    int length = strlen(name) + 1; // We include the '\0' in the length
    expandBufferIfNeeded(length);

    char * position = nextName;
    strcpy(name, nextName);
    nextName += length;

    return position;
};
*/