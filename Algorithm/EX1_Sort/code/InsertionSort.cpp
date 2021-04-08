#include <iostream>
#include <random>
#include <time.h>
#include <vector>
using namespace std;

void InsertionSort(vector<unsigned int> &v)
{
    int len = v.size();
    for (int i = 1; i < len; i++)
    {
        unsigned int key = v[i];     // 待排序元素
        int j = i - 1;               // 已排序列的尾索引
        while (j >= 0 && key < v[j]) // 已排序列从后往前寻找合适的位置
        {
            v[j + 1] = v[j];
            --j;
        }
        v[j + 1] = key;
    }
}

/**
 * 生成以n为个数的非负整数序列
 * @param 个数 n
 * @return 非负整数序列
 */
vector<unsigned int> GenerateRandom(int n)
{
    vector<unsigned int> l;
    default_random_engine rd(time(0)); // 随机数引擎（以时间关联种子发生器）

    for (int i = 0; i < n; i++)
        l.push_back(rd());

    return l;
}

/* 输出vector*/
void PrintVec(vector<unsigned int> &v)
{
    for (auto x : v)
        cout << x << " ";
    cout << endl;
}

/*检查排序是否正确*/
bool IsSorted(vector<unsigned int> &v)
{
    int len = v.size();
    bool flag = true;
    for (int i = 0; i < len - 1; i++)
    {
        if (v[i] > v[i + 1])
        {
            flag = false;
            break;
        }
    }
    return flag;
}

int main()
{
    vector<unsigned int> v = GenerateRandom(1000);
    InsertionSort(v);
    if (IsSorted(v))
    {
        cout << "valid sort" << endl;
    }
}