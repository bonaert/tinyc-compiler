#include "graph.h"
#include <stdlib.h>
#include <stdio.h>

static int EDGE_INCREMENT_SIZE = 20;
void growEdgeListIfNeeded(GRAPH* graph) {
    int capacity = graph->capacity;
    if (capacity == 0){ // Haven't allocated buffer yet
        graph->edges = malloc(sizeof(EDGE) * EDGE_INCREMENT_SIZE);
        graph->capacity = EDGE_INCREMENT_SIZE;
        graph->numEdges = 0;
    } else if (graph->numEdges == capacity) {  // Reached max
        graph->edges = realloc(graph->edges, (capacity + EDGE_INCREMENT_SIZE) * sizeof(EDGE)); /* like malloc() if buf==0 */
        if (!graph->edges) {
            fprintf(stderr, "Cannot expand graph (%d edges)", (int) ((capacity + EDGE_INCREMENT_SIZE)));
            exit(1);
        }
        graph->capacity = capacity + EDGE_INCREMENT_SIZE;
    }
}

GRAPH* initGraph() {
    GRAPH* graph = (GRAPH*) malloc(sizeof(GRAPH));
    graph->capacity = 0;
    graph->edges = 0;
    graph->numEdges = 0;
    return graph;
}

void addEdge(GRAPH* graph, void* start, void* end) {
    growEdgeListIfNeeded(graph);
    graph->edges[graph->numEdges].start = start;
    graph->edges[graph->numEdges].end = end;
    graph->numEdges++;
}