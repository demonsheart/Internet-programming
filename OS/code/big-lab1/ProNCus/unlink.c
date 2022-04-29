#include <semaphore.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

// ipcrm -m 65553
int main()
{
    sem_unlink("mutex");
    sem_unlink("empty");
    sem_unlink("full");
}