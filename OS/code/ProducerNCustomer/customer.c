//
// Created by herongjin on 2022/4/28.
//
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <string.h>
#include <unistd.h>
#include <sys/shm.h>

int main(int argc, char *argv[]) {
    int shm_id;
    char *shm_buf;
    if (argc != 2)
    {
        printf("USAGE: atshm <identifier>");
        exit(1);
    }
    shm_id = atoi(argv[1]);
    if ((shm_buf = shmat(shm_id, 0, 0)) < (char *)0)
    { // 映射内存
        perror("shmat fail!\n");
        exit(1);
    }
    printf(" segment attached at %p\n", shm_buf);
    system("ipcs -m");

    sem_t *mutex = sem_open("mutex", 1);
    sem_t *empty = sem_open("empty", 1);
    sem_t *full = sem_open("full", 0);

    int pid = fork();
    if (pid < 0) {
        perror("pid error\n");
    } else if (pid == 0) {

        while (1) {
            sem_wait(full);
            sem_wait(mutex);

            printf("son pid %d receive message:%s\n", getpid(), shm_buf);
            strcpy(shm_buf, "");

            sem_post(mutex);
            sem_post(empty);
        }
    } else {
        while (1) {
            sem_wait(full);
            sem_wait(mutex);

            printf("parent pid %d receive message:%s\n", getpid(), shm_buf);
            strcpy(shm_buf, "");

            sem_post(mutex);
            sem_post(empty);
        }
    }

    return 0;
}