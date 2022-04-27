#include<unistd.h>
#include<stdio.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    // 二叉树
    for (int i = 0; i < 6; i++)
    {
        pid_t pid = fork();
        if (pid > 0) { // 父进程
            pid = fork(); // 创建两次
            if (pid > 0) {
                break;
            }

        } else if (pid < 0) {
            printf("error!\n"); 
        }
    }

    getchar(); // 阻塞等待
    
    return 0;
}