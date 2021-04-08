#include <iostream>
#include <random>
#include <time.h>
#include <vector>
using namespace std;

/* 快排中，为一个元素找到正确的位置 */
int GetRightPos(vector<unsigned int> &v, int left, int right)
{
    int i = left, j = right;
    unsigned int key = v[i];

    while (i < j)
    {
        // 从右边开始寻找第一个比key小的数
        while (i < j && v[j] >= key)
            j--;
        // 当找到比 v[i] 小的时，就把后面的值 v[j] 赋给它
        if (i < j)
            v[i] = v[j];
        // 从左边开始寻找第一个比key大的数
        while (i < j && v[i] <= key)
            i++;
        // 当找到比 v[j] 大的时，就把前面的值 v[i] 赋给它
        if (i < j)
            v[j] = v[i];
    }
    // 循环结束后， i就是正确的位置
    v[i] = key;
    return i;
}

void QuickSort(vector<unsigned int> &v, int low, int high)
{
    if (low < high)
    {
        int mid = GetRightPos(v, low, high); // mid位置已经是正确的位置
        QuickSort(v, low, mid - 1);
        QuickSort(v, mid + 1, high);
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
    QuickSort(v, 0, (int)v.size() - 1);
    if (IsSorted(v))
    {
        cout << "valid sort" << endl;
    }
}