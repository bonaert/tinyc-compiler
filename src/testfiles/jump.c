#include <stdio.h>

int main() {
    int j = 1;
    while (5 > 2) {
        j = j + 1;

        int k = j / 10000;
        int e = k * 1000;
        if (e == j) {
            printf("%d ", j);
        }
        
    }
    return 5;
}

