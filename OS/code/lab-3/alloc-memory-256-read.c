#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define KB 1024
#define MB 1024 * 1024

int main() {
    printf("PID: %d\n", getpid());
    getchar();

    // 分配256MB内存
    char * buf = (char *) malloc(256 * MB * sizeof(char));
    printf("Alloc buf: %p-%p\n", buf, buf + 256 * MB);
    getchar();

    // 每隔4KB读操作
    long long tmp;
    for (int i = 0; i < 256 * MB; i += 4 * KB) {
        tmp += buf[i];
    }
    printf("read ok");
    getchar();

    return 0;
}