#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <algorithm>
#include <string.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <semaphore.h>
#include <mutex>
#include <pthread.h>
#include <fcntl.h>
#include <string>
#include <time.h>
#include <math.h>
#include <iostream>
#include <sstream>

using namespace std;

#define BLOCK_SIZE 4096
#define INODE_NUM 1024
#define BLOCK_NUM 2048

struct Super_block {
    int inode_num;        // 索引节点总数
    int block_num;        // 盘块总数
    int free_inode_num;   // 空闲索引节点数
    int free_block_num;   // 空闲盘块数
    int block_size;       // 盘块大小(4096字节)
};

struct Inode {
    int block_location[12];  // 数据block 的index数组
    int size;                // 文件长度(字节)
    time_t timestamp;        // 时间戳
    int type;                // 文件类型：0文件，1目录
};

struct shared_mem_st {
    struct Super_block super_block;
    bool inode_map[INODE_NUM]; // inode节点空闲
    bool data_map[BLOCK_NUM]; // 数据盘块空闲
    struct Inode inodes[INODE_NUM];
    char blocks[BLOCK_NUM][BLOCK_SIZE];
};

/* 操作函数  */
int Mkdir(int &, string, int);
void Rmdir(int, string);
void Mv(int, string, string);
int Open(int, string);
void Edit(int, string);
void Rm(int &, string, int);
void Cd(int &, string, string &);
void Cat(int, string);
void Ls(int);