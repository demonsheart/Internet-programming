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

struct Super_bolck
{
    int inode_num;		// 索引节点总数
    int block_num;		// 盘块总数
    int free_inode_num; // 空闲索引节点数
    int free_block_num; // 空闲盘块数
    int block_size;		// 盘块大小(4096字节)
};

struct Inode
{
    int block_location[12]; // 数据盘块指针数组(直接索引)[是一个数据盘块下标数组]
    int size;				// 文件长度(字节)
    time_t st_time;			// 创建时间戳
    int i_mode;				// 文件类型：0文件，1目录
};

struct shared_mem_st
{
    struct Super_bolck superblock;
    bool i_map[INODE_NUM]; // bool数组, false: inode节点空闲
    bool b_map[BLOCK_NUM]; // bool数组, false: 数据盘块空闲
    struct Inode inodes[INODE_NUM];
    char blocks[BLOCK_NUM][BLOCK_SIZE];
    int read_count[INODE_NUM]; // readerCnt
};