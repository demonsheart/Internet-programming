#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define MB 1024 * 1024

int main() {
    printf("PID: %d", getpid());
    char *address[8]; // 分配内存块的指针地址
    getchar(); // 阻塞 以查看分配内存前的信息

    // 连续申请分配六块128MB的内存
    for (int i = 1; i <= 6; ++i) {
        address[i] = (char *) malloc(128 * MB * sizeof(char));
        printf("Alloc space %d: %p-%p\n", i, address[i], address[i] + 128 * MB);
    }
    getchar();// 阻塞 以查看连续分配六块内存后的信息

    // 释放第2、3、5号内存
    free(address[2]);
    printf("Free space2\n");
    free(address[3]);
    printf("Free space3\n");
    free(address[5]);
    printf("Free space5\n");
    getchar();

    // 分配1024MB内存
    address[0] = (char *) malloc(1024 * MB * sizeof(char));
    printf("Alloc space %d: %p-%p\n", 0, address[0], address[0] + 1024 * MB);
    getchar();

    // 再分配64MB内存
    address[7] = (char *) malloc(64 * MB * sizeof(char));
    printf("Alloc space %d: %p-%p\n", 7, address[7], address[7] + 64 * MB);
    getchar();

    return 0;
}


