#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define MB 1024 * 1024

int main() {
    printf("PID: %d\n", getpid());
    // 第一个分配130MB
    char * space1 = (char *) malloc(130 * MB * sizeof(char));
    printf("Alloc space 1: %p-%p\n", space1, space1 + 130 * MB);
    // 第二个分配100MB
    char * space2 = (char *) malloc(100 * MB * sizeof(char));
    printf("Alloc space 2: %p-%p\n", space2, space2 + 100 * MB);
    // 第三个分配150MB
    char * space3 = (char *) malloc(150 * MB * sizeof(char));
    printf("Alloc space 3: %p-%p\n", space3, space3 + 150 * MB);
    getchar();

    // 释放1， 2
    free(space1);
    free(space2);
    printf("Free 1 && 2\n");
    getchar();

    // 再分配100 看落在哪个空间
    char * space4 = (char *) malloc(100 * MB * sizeof(char));
    printf("Alloc space 4: %p-%p\n", space4, space4 + 100 * MB);
    getchar();

    return 0;
}