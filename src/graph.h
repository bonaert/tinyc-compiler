#ifndef GRAPHGUARD
#define GRAPHGUARD

/**
 * Graph data structure, which can be seen as a list of edges between 2 elements.
 * The elements can be anything, so we use void* pointers.
 */

typedef struct graph_edge {
    void* start;
    void* end;
} EDGE;

typedef struct graph_graph {
    EDGE* edges;
    int numEdges;
    int capacity;
} GRAPH;

GRAPH* initGraph();
void addEdge(GRAPH* blockGraph, void* start, void* end);

#endif // !GRAPHGUARD