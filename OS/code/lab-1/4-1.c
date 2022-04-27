#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    // 直接孩子 50个儿子
    for (int i = 0; i < 50; i++)
    {
        pid_t pid = fork();
        if (pid > 0)
        { // 父进程
            // waitpid(pid, NULL, 0);
            continue;
        }
        else if (pid == 0)
        { // 子进程
            break;
        }
        else
        {
            printf("error!\n");
        }
    }

    getchar(); // 阻塞等待

    return 0;
}