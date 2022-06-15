#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdlib.h>
#include <stdio.h>

#define MB 1024 * 1024

int main(void)
{
    int shm_id;
    shm_id = shmget(IPC_PRIVATE, 100 * MB, 0666); //创建共享内存
    if (shm_id < 0)
    {
        perror("shmget fail!\n");
        exit(1);
    }
    printf("Successfully created segment : %d \n", shm_id);
    return 0;
}