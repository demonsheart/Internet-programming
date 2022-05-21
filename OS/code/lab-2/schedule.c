#include <stdio.h>
#include <stdlib.h>
#include <curses.h>
#include <time.h>

#define getpch(type) (type *)malloc(sizeof(type))
typedef struct pcb PCB;
struct pcb
{
    int id;
    char name[10];
    int time_start;
    int time_need;
    int time_left;
    int time_used;
    char state;
};

//******system func***********
void _sleep(int n)
{
    clock_t goal;
    goal = (clock_t)n * CLOCKS_PER_SEC + clock();
    while (goal > clock())
        ;
}

char _keygo()
{
    char c;
    printf("enter any key to continue.....\n");
    c = getch();
    return c;
}

//**********data************
int time_unit = 2;
const maxnum = 10; // max proc num
int num = 5;       // real proc num
PCB pcbdata[maxnum] = {
    {1000, "A", 0, 4, 4, 0, 'R'},
    {1001, "B", 1, 3, 3, 0, 'R'},
    {1002, "C", 2, 5, 5, 0, 'R'},
    {1003, "D", 3, 2, 2, 0, 'R'},
    {1004, "E", 4, 4, 4, 0, 'R'},
};
int ready[maxnum]; // ready queue for pcbdata
int order[maxnum];

void input()
{
    int i;
    printf("total proc num:");
    scanf("%d", &num);
    for (int i = 0; i < num; i++)
    {
        pcbdata[i].id = 1000 + i;
        printf("enter name of proc%d:", i + 1);
        scanf("%s", &pcbdata[i].name);
        printf("enter time_start of proc%d:", i + 1);
        scanf("%d", &pcbdata[i].time_start);
        printf("enter time_need of proc%d:", i + 1);
        scanf("%d", &pcbdata[i].time_need);
        pcbdata[i].time_left = pcbdata[i].time_need;
        printf("\n");
        pcbdata[i].time_used = 0;
        pcbdata[i].state = 'R';
    }
}

void FCFS()
{
    
}

void SJF()
{
}

void HRF()
{
}

void Timeslice()
{
}

void MRLA()
{
}

void main()
{
    int i = 0, sch = 99;
    while (sch != 0)
    {
        printf("\nselect a shcedule algorithm:\n");
        printf("(1)FCFS\n");
        printf("(2)SJF\n");
        printf("(3)HRF\n");
        printf("(4)Timeslice\n");
        printf("(5)MRLA\n");
        printf("(0)exit\n");
        printf("enter select num:");
        scanf("%d", &sch);
        switch (sch)
        {
        case 1:
            FCFS();
            break;
        case 2:
            SJF();
            break;
        case 3:
            HRF();
            break;
        case 4:
            Timeslice();
            break;
        case 5:
            MRLA();
            break;
        case 0:
            printf("exit\n");
            break;
        }
    }
    _keygo();
}

// ****************debug*************
void dis_pcb(PCB *pr)
{
    printf("%s's PCB:\n", pr->name);
    printf("id--%d, state--%c, time_start--%d\n", pr->id, pr->state, pr->time_start);
    printf("time_need--%d, time_left--%d, time_used--%d\n", pr->time_need, pr->time_left, pr->time_used);
    printf("----------------\n");
}

void dis_pcb_all()
{
    printf("********All PCB STATE********\n");
    for (int i = 0; i < num; i++)
    {
        dis_pcb(&pcbdata[i]);
    }
}

void dis_ready()
{
    printf("********Order Queue********\n");
    int i;
    for (i = 0; i < num - 1; i++)
    {
        printf("%s--", pcbdata[order[i]].name);
    }
    printf("%s\n", pcbdata[order[i]].name);
}