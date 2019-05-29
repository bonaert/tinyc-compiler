#ifndef GRAPHGUARD
#define GRAPHGUARD



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