#include <iostream>
#include <random>
#include <time.h>
#include <vector>
using namespace std;

void SelectSort(vector<unsigned int> &v)
{
    int len = v.size();
    int index, i, j;

    for (i = 0; i < len - 1; i++)
    {
        index = i;
        // 寻找最小数索引
        for (j = i + 1; j < len; j++)
        {
            if (v[index] > v[j])
                index = j;
        }
        // 交换
        if (index != i)
            swap(v[index], v[i]);
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
    SelectSort(v);
    if (IsSorted(v))
    {
        cout << "valid sort" << endl;
    }
}