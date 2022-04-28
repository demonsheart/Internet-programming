//
// Created by herongjin on 2022/4/28.
//
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <string.h>
#include <unistd.h>
#include <sys/shm.h>
#include <pthread.h>

#define thread_num 2
char *shm_buf;
sem_t *mutex;
sem_t *empty;
sem_t *full;
void *get_line(void *arg);

int main(int argc, char *argv[])
{
    // 映射内存
    int shm_id;
    if (argc != 2)
    {
        printf("USAGE: atshm <identifier>");
        exit(1);
    }
    shm_id = atoi(argv[1]);
    if ((shm_buf = shmat(shm_id, 0, 0)) < (char *)0)
    {
        perror("shmat fail!\n");
        exit(1);
    }
    printf(" segment attached at %p\n", shm_buf);
    system("ipcs -m");

    // 获取信号量
    mutex = sem_open("mutex", 1);
    empty = sem_open("empty", 1);
    full = sem_open("full", 0);

    // 生成两个线程 用于显示缓冲区内的信息 这两个进程/线程并发读取缓冲区信息后将缓冲区清空
    pthread_t threads[thread_num];
    int tid[thread_num];
    for (int i = 0; i < thread_num; i++)
    {
        tid[i] = i;
        int err = pthread_create(&(threads[i]), NULL, get_line, &(tid[i]));
        if (err)
        {
            printf("create thread error!\n");
            return 0;
        }
    }

    for (int i = 0; i < thread_num; i++)
    {
        pthread_join(threads[i], NULL);
    }

    // 解除共享内存的映射
    if ((shmdt(shm_buf)) < 0)
    {
        perror("shmdt");
        exit(1);
    }

    return 0;
}

void *get_line(void *id)
{
    int no = *(int *)id;
    while (1)
    {
        // V操作 "先私后公原则"
        sem_wait(full);
        sem_wait(mutex);
        // 读取共享内存数据
        printf("thread %d get line: %s\n", no, shm_buf);
        // 清空共享内存数据
        strcpy(shm_buf, "");

        // P操作
        sem_post(mutex);
        sem_post(empty);

        // fixme: 一下判断永远不生效
        if (strcmp(shm_buf, "quit") == 0)
        {
            printf("thread %d quit", no);
            return 0;
            break;
        }
    }
    return 0;
}