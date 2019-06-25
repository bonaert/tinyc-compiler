#ifndef LOCATIONSGUARD
#define LOCATIONSGUARD

/** Data structure representing a set of location in the intermediate code */
typedef struct locationsSet {
    int* locations;
    int size;
    int capacity;
} LOCATIONS_SET;

/** Data structure representing the location set associated to the true branch
 * and the false branch of this choice point.
 */
typedef struct choice {
	LOCATIONS_SET* toFalse;
	LOCATIONS_SET* toTrue;
} CHOICE;

int isInSet(LOCATIONS_SET* locations, int location);
LOCATIONS_SET* locationsAdd(LOCATIONS_SET* locations, int location);
LOCATIONS_SET* locationsUnion(LOCATIONS_SET* locations1, LOCATIONS_SET* locations2);
LOCATIONS_SET* locationsCreateSet();
void printLocations(LOCATIONS_SET* locations);

#endif