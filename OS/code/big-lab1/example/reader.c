#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("input the shmid!\n");
        exit(1);
    } // if

    // get the shmid from argv
    int shm_id = atol(argv[1]);

    char *shm_buf;
    // get the share memory address

    if ((shm_buf = shmat(shm_id, 0, 0)) < (char *)0)
    {
        perror("shm_buf error\n");
        exit(1);
    } // if

    sem_t *mutex = sem_open("mutex", 1);
    sem_t *full = sem_open("full", 0);
    sem_t *empty = sem_open("empty", 1);
    int pid = fork();
    if (pid < 0)
    {
        perror("pid error\n");
    } // if

    else if (pid == 0)
    {

        while (1)
        {
            // wait the semaphore
            sem_wait(full);
            sem_wait(mutex);

            printf("son pid %d receive message:%s\n", getpid(), shm_buf);
            // clear the share memory
            strcpy(shm_buf, "");

            // semaphore +1
            sem_post(mutex);
            sem_post(empty);
        } // while
    }     // else if

    else
    {
        while (1)
        {
            // wait the semaphore
            sem_wait(full);
            sem_wait(mutex);

            printf("parent pid %d receive message:%s\n", getpid(), shm_buf);
            // clear the share memory
            strcpy(shm_buf, "");

            // semaphore +1
            sem_post(mutex);
            sem_post(empty);
        } // while
    }     // else

    return 0;
}