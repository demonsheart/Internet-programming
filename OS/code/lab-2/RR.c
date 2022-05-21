#include <sched.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>

int main()
{
	fork(); // two RR proc
	struct sched_param param;
	param.sched_priority = 1;
	sched_setscheduler(getpid(), SCHED_RR, &param);

	while(1)
	{
        int delay = 200000000;
        while (delay--); // delay printf
        
        time_t timep;
        time(&timep);
        printf("%d, time:%s", getpid(), ctime(&timep));
	}

	return 0;
}