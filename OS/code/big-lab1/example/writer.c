#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#define BUFFERSIZE 4096

int main(int argc, char *argv[])
{
    // create the share memory by shmget()
    int shm_id = shmget(IPC_PRIVATE, BUFFERSIZE, 0666);
    if (shm_id < 0)
    {
        perror("shmid error\n");
        exit(1);
    } // if

    // get the virtual address of this share memory
    char *shm_buf;
    if ((shm_buf = shmat(shm_id, 0, 0)) < (char *)0)
    {
        perror("shmbuffer error!\n");
        exit(1);
    }

    // message input
    char message[128];

    // create the semaphore
    sem_t *mutex = sem_open("mutex", O_CREAT, 0666, 1);
    sem_t *full = sem_open("full", O_CREAT, 0666, 0);
    sem_t *empty = sem_open("empty", O_CREAT, 0666, 1);

    char c;
    int i;
    printf("shmid = %d\n", shm_id);

    while (1)
    {
        i = -1;
        while ((c = getchar()) != '\n')
        {
            message[++i] = c;
        } // while
        message[++i] = '\0';
        // wait the semaphore
        sem_wait(empty);
        sem_wait(mutex);

        // send the message to shm_buf
        sprintf(shm_buf, message);

        // semaphore +1
        sem_post(mutex);
        sem_post(full);
    } // while
    return 0;
}