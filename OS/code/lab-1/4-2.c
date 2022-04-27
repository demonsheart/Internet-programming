#include<unistd.h>
#include<stdio.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    // 父生子 子生孙 无穷溃也
    for (int i = 0; i < 50; i++)
    {
        pid_t pid = fork();
        if (pid > 0) { // 父进程
            break;
        } else if (pid == 0) { // 子进程
            continue;
        } else {
            printf("error!\n");
        }
    }

    getchar(); // 阻塞等待
    
    return 0;
}