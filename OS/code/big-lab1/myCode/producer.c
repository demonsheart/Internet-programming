//
// Created by herongjin on 2022/4/28.
//

#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdlib.h>
#include <stdio.h>
#include <semaphore.h>
#include <string.h>
#include <unistd.h>

#define BUF_SIZE 4096
#define LINE_SIZE 256
char *shm_buf;
sem_t *mutex;
sem_t *empty;
sem_t *full;
void write_to_buf(char *line);

int main()
{
    // 创建共享内存
    int shm_id = shmget(IPC_PRIVATE, BUF_SIZE, 0666);
    if (shm_id < 0)
    {
        perror("shmget fail!\n");
        exit(1);
    }
    printf("Successfully created segment : %d \n", shm_id);
    system("ipcs -m"); //执行ipcs –m 命令，显示系统的共享内存信息

    // 映射内存到进程空间
    if ((shm_buf = shmat(shm_id, 0, 0)) < (char *)0)
    {
        perror("shmat fail!\n");
        exit(1);
    }
    printf(" segment attached at %p\n", shm_buf);
    system("ipcs -m"); //显示共享内存信息

    // 创建信号量
    // mutex互斥信号量 empty根据题意取1 full初始化为0
    mutex = sem_open("mutex", O_CREAT, 0666, 1);
    empty = sem_open("empty", O_CREAT, 0666, 1);
    full = sem_open("full", O_CREAT, 0666, 0);

    // 缓冲区行字符串
    char *line = (char *)malloc(LINE_SIZE);

    while (1)
    {
        printf("Enter your text('quit' for exit): ");
        gets(line);

        if (strcmp(line, "quit") == 0)
        {
            // 发送两次 让接收方两个线程都退出
            write_to_buf(line);
            sleep(2); // 需要间隔等待 等某一个线程接受完才能再次发送 否则会产生死锁
            write_to_buf(line);
            sem_unlink("mutex");
            sem_unlink("empty");
            sem_unlink("full");
            break;
        }

        write_to_buf(line);
    }

    //解除共享内存的映射
    if ((shmdt(shm_buf)) < 0)
    {
        perror("shmdt");
        exit(1);
    }
    free(line);
    return 0;
}

void write_to_buf(char *line)
{
    // V操作 "先私后公原则"
    sem_wait(empty);
    sem_wait(mutex);

    // 往共享内存写入数据
    strcpy(shm_buf, line);

    // P操作
    sem_post(mutex);
    sem_post(full);
}