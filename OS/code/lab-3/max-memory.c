#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define MB 1024 * 1024

int main() {
    printf("PID: %d\n", getpid());

    // 循环分配
    size_t step = 100 * MB * sizeof(char);
    int i = 0;
    while (1) {
        char * addr = (char *)malloc(step);
        i++;
        printf("Memory: %ldMB\n", (long)(i * 100));
    }

    return 0;
}