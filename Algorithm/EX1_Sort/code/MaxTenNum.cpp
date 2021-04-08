#include <algorithm>
#include <iostream>
#include <queue>
#include <random>
#include <time.h>
using namespace std;

/* 输出vector*/
void PrintVec(vector<unsigned int> &v)
{
    for (auto x : v)
        cout << x << " ";
    cout << endl;
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

vector<unsigned int> FindMaxTen(vector<unsigned int> &v)
{
    vector<unsigned int> result;
    //小顶堆
    priority_queue<unsigned int, vector<unsigned int>, greater<unsigned int>> q;
    //无符号数 以十个零作为小顶堆的初始值
    for (int i = 0; i < 10; ++i)
        q.push(0);
    for (auto x : v)
    {
        if (x > q.top()) // 如果当前值比堆顶大
        {
            q.pop();
            q.push(x);
        }
    }
    while (!q.empty())
    {
        result.push_back(q.top());
        q.pop();
    }

    return result;
}

int main()
{
    int n;
    cout << "please input lenth:";
    cin >> n;

    auto v = GenerateRandom(n);
    auto max_ten = FindMaxTen(v);
    reverse(max_ten.begin(), max_ten.end());
    PrintVec(max_ten);

    //通过排序检验算法的正确性
    sort(v.begin(), v.end(), greater<unsigned int>());
    vector<unsigned int> re(v.begin(), v.begin() + 10);
    PrintVec(re);

    if (max_ten == re)
        cout << "valid" << endl;

    return 0;
}