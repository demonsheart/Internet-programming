#include <iostream>
#include <random>
#include <time.h>
#include <vector>
using namespace std;

/* 二路归并 */
void Merge(vector<unsigned int> &v, vector<unsigned int> &left, vector<unsigned int> &right)
{
    int i = 0, j = 0, k = 0;
    int l_len = left.size();
    int r_len = right.size();

    while (i < l_len && j < r_len)
    {
        if (left[i] < right[j])
            v[k++] = left[i++];
        else
            v[k++] = right[j++];
    }
    while (i < l_len)
        v[k++] = left[i++];
    while (j < r_len)
        v[k++] = right[j++];
}
/* 基于二路归并的归并排序 */
void MergeSort(vector<unsigned int> &v, int len)
{
    if (len < 2)
        return;

    int mid = len / 2;
    // 二分需要的三个迭代器
    auto it_begin = v.begin();
    auto it_mid = v.begin() + mid;
    auto it_end = v.end();
    // 二分
    vector<unsigned int> left(it_begin, it_mid);
    vector<unsigned int> right(it_mid, it_end);

    MergeSort(left, mid); // 左边排序
    MergeSort(right, len - mid); // 右边排序
    Merge(v, left, right); // 归并
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
    MergeSort(v, (int)v.size());
    if (IsSorted(v))
    {
        cout << "valid sort" << endl;
    }
}