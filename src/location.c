#include <stdio.h> /* fprintf */
#include <stdlib.h> /* malloc */
#include "location.h"


LOCATIONS_SET* locationsCreateSet() {
    LOCATIONS_SET* locationsSet = malloc(sizeof(LOCATIONS_SET));
    locationsSet->size = 0;
    locationsSet->locations = 0;
    locationsSet->capacity = 0;
    return locationsSet;
}

LOCATIONS_SET* locationsCreateSetWithCapacity(int capacity) {
    LOCATIONS_SET* locationsSet = malloc(sizeof(LOCATIONS_SET));
    locationsSet->size = 0;
    locationsSet->locations = malloc(sizeof(int) * capacity);
    locationsSet->capacity = capacity;
    return locationsSet;
}


int isInSet(LOCATIONS_SET* locations, int location){
    for(int i = 0; i < locations->size; i++) {
        // TODO: random garbage in unnocupied part of buffer may be equal to location by coincidence, may need to initialize to -1
        if (locations->locations[i] == location) { 
            return 1;
        }
    }
    return 0;
}

static int INCREMENT_SIZE = 20 * sizeof(int);
void growLocationsIfNeeded(LOCATIONS_SET* locations) {
    int capacity = locations->capacity;
    if (locations->capacity == 0){ // Haven't allocated buffer yet
        locations->locations = malloc(sizeof(int) * 20);
        locations->capacity = 20;
    } else if (locations->size == capacity) {  // Reached max
        locations->locations = realloc(locations->locations, capacity + INCREMENT_SIZE); /* like malloc() if buf==0 */
        if (!locations->locations) {
            fprintf(stderr, "Cannot expand name space (%d bytes)", capacity + INCREMENT_SIZE);
            exit(1);
        }
        locations->capacity = capacity + 20;
    }
}

void locationInsert(LOCATIONS_SET* locations, int location) {
    growLocationsIfNeeded(locations);
    locations->locations[locations->size] = location;
    locations->size++;
}

LOCATIONS_SET* locationsAdd(LOCATIONS_SET* locations, int location) {
    if (!isInSet(locations, location)) {
        locationInsert(locations, location);
    }
    return locations;
}


void printLocations(LOCATIONS_SET* locations) {
    fprintf(stderr, "Locations: ");
    for(int i = 0; i < locations->size; i++){
        fprintf(stderr, "%d ", locations->locations[i]);
    }
    fprintf(stderr, " \n");
}


LOCATIONS_SET* locationsUnion(LOCATIONS_SET* locations1, LOCATIONS_SET* locations2) {
    LOCATIONS_SET* newLocations = locationsCreateSetWithCapacity(locations1->size + INCREMENT_SIZE);
    
    // Not ultra efficient, a memcpy could be faster
    for(int i = 0; i < locations1->size; i++){
        locationInsert(newLocations, locations1->locations[i]);
    }
    
    for(int i = 0; i < locations2->size; i++){
        locationsAdd(newLocations, locations2->locations[i]);
    }

    fprintf(stderr, "size 1:  %d     size2:  %d    finalSize:    %d  \n", locations1->size, locations2->size, newLocations->size);
    printLocations(locations1);
    printLocations(locations2);
    printLocations(newLocations);

    return newLocations;
}