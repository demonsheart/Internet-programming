#include<unistd.h>
#include<stdio.h>

int main(int argc, char** argv)
{
    int pid = fork();
    if(pid == -1) {
        printf("error\n");
    } else if(pid == 0) {
        printf("Child process\n");
    } else {
        printf("Parent process; child process id = %d\n", pid);
    }

    return 0;
}