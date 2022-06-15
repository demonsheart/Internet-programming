#include <stdio.h>

#define MAX_FILENAME_LENGTH 16
#define INODE_TABLE_LENGTH 8
#define MAX_FILE_NUM 24

struct File {
    char filename[MAX_FILENAME_LENGTH];
    int inode_index;
};

struct Dir {
    char dir_path[MAX_FILENAME_LENGTH];
    int inode_index;
    struct File files[MAX_FILE_NUM];
};

struct Inode {
    int type; // file or dir
    int size;
    int table[INODE_TABLE_LENGTH];
};

int main() {
    printf("Hello, World!\n");
    return 0;
}
