#include <semaphore.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("please input a file name to act as the ID of the sem!\n");
        exit(1);
    }
    //撤销指定的信号量
    if (sem_unlink(argv[1]) == -1)
    {
        perror("Unlink fail\n");
        exit(1);
    }
    printf("Unlink succesfully!\n");
    exit(0);
}