#include <unistd.h>
#include <stdarg.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>

int tprintf (const char* fmt, ...);

int main(void)
{
    int i = 0;
    pid_t pid;
    printf("Hello from Parent Process, Pid is %d.\n", getpid());

    pid = fork();

    if (pid == 0) // child
    {
        sleep(1);
        for (i = 0; i < 3; i++)
        {
            printf("Hello from Child Process %d. %d times\n", getpid(), i + 1);
            sleep(1);
        }
        
    }
    else if (pid != -1) // parent
    {
        tprintf("Parent forked one child process--%d.\n", pid);
        tprintf("Parant is waiting for child to exist.\n");
        waitpid(pid, NULL, 0);
        tprintf("Child Process had existed.\n");
        tprintf("Parent Process had existed.\n");
    }
    else
    {
        tprintf("Everything was done without error.\n");
    }

    return 0;
}

int tprintf (const char* fmt, ...)
{
    va_list args;
    struct tm *tstruct;
    time_t tsec;
    tsec = time(NULL);
    tstruct = localtime(&tsec);
    printf("%02d:%02d:%02d: %05d|", tstruct->tm_hour, tstruct->tm_min, tstruct->tm_sec, getpid());
    va_start(args, fmt);
    return vprintf(fmt, args);
}