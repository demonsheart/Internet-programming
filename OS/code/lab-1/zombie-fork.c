#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
    pid_t pid;
    pid = fork();
    if (pid < 0)
        printf("error occurred!\n");
    else if (pid == 0)
    {
        printf("僵尸蹦蹦跳\n");
        exit(0); // 直接退出 此时父进程还没有调用wait()
    }
    else
    {
        getchar(); // 阻塞父进程
        waitpid(pid, NULL, 0); // 处理僵尸进程
    }
    return 0;
}
