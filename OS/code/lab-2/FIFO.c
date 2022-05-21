#include <sched.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
	struct sched_param param;
	param.sched_priority = 2;
	sched_setscheduler(getpid(), SCHED_FIFO, &param);
	while(1);

	return 0;
}