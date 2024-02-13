#include <stdio.h>

int main() {
    char hex[3];
    int i, j;

    for (i = 0; i < 16; i++) {
        for (j = 0; j < 16; j++) {
            sprintf(hex, "%X%X", i, j);
            printf("%s ", hex);
        }
        printf("\n");
    }

    return 0;
}
