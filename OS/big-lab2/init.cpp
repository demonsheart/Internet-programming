#include "fileSys.h"
using namespace std;

int main()
{
    /* 申请100M共享内存 */
    int shm_id = shmget((key_t)1234, 100 * 1024 * 1024, 0666 | IPC_CREAT);
    if (shm_id < 0)
    {
        perror("shmget fail!\n");
        exit(1);
    }
    cout << "Successfully created: " << shm_id << endl;
    return 0;
}
