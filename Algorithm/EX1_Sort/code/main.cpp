#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <time.h>
#include <vector>
#include <windows.h>
using namespace std;

void BubbleSort(vector<unsigned int> &v)
{
    int len = v.size();

    // 每次外循环把最大的数移到未排序的序列的最后一位
    for (int i = 0; i < len - 1; i++)
    {
        for (int j = 0; j < len - i - 1; j++)
        {
            if (v[j] > v[j + 1])
                swap(v[j], v[j + 1]);
        }
    }
}

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

    MergeSort(left, mid);
    MergeSort(right, len - mid);
    Merge(v, left, right);
}

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

/**
 * 获取排序所用时间(ms)
 * @param 排序序列 vector<unsigned int> &v
 * @param 排序方法 string
 * @return 时间(ms)
 */
double GetRunTime(vector<unsigned int> &v, string method)
{
    clock_t start_time, end_time;
    double duration = 0;
    start_time = clock();

    if (method == "SelectSort")
        SelectSort(v);
    else if (method == "BubbleSort")
        BubbleSort(v);
    else if (method == "MergeSort")
        MergeSort(v, (int)v.size());
    else if (method == "QuickSort")
        QuickSort(v, 0, (int)v.size() - 1);
    else if (method == "InsertionSort")
        InsertionSort(v);
    else
        return -1;
    end_time = clock();

    duration = (double)(end_time - start_time) / CLOCKS_PER_SEC * 1000;

    return duration;
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
    int TestNum = 20;
    ofstream outfile;
    // 导出csv文件 交付excel处理
    outfile.open("result.csv", ios::app);
    outfile << "Sample size, Select, Bubble, Merge, Quick, Insert" << endl;

    while (TestNum--)
    {
        double time;
        // 生成样本集
        vector<vector<unsigned int>> samples;
        samples.push_back(GenerateRandom(10000));
        samples.push_back(GenerateRandom(20000));
        samples.push_back(GenerateRandom(30000));
        samples.push_back(GenerateRandom(40000));
        samples.push_back(GenerateRandom(50000));

        vector<double> avg_time(5, 0); //平均结果

        for (int k = 0; k < (int)samples.size(); k++)
        {
            vector<unsigned int> v; // 用于测试的样本集的拷贝
            int cur_len = samples[k].size();
            cout << "Sample size: " << cur_len << endl;

            // 选择排序测试
            v = samples[k];
            time = GetRunTime(v, "SelectSort");
            if (IsSorted(v))
            {
                cout << "select: " << time << "ms" << endl;
                avg_time[0] = time;
            }

            // 冒泡排序测试
            v = samples[k];
            time = GetRunTime(v, "BubbleSort");
            if (IsSorted(v))
            {
                cout << "bubble: " << time << "ms" << endl;
                avg_time[1] = time;
            }

            // 合并排序测试
            v = samples[k];
            time = GetRunTime(v, "MergeSort");
            if (IsSorted(v))
            {
                cout << "Merge: " << time << "ms" << endl;
                avg_time[2] = time;
            }

            // 快速排序测试
            v = samples[k];
            time = GetRunTime(v, "QuickSort");
            if (IsSorted(v))
            {
                cout << "Quick: " << time << "ms" << endl;
                avg_time[3] = time;
            }

            // 插入排序测试
            v = samples[k];
            time = GetRunTime(v, "InsertionSort");
            if (IsSorted(v))
            {
                cout << "Insert: " << time << "ms" << endl;
                avg_time[4] = time;
            }
            cout << endl;

            // 写入记录
            outfile << cur_len;
            for (auto x : avg_time)
                outfile << ", " << x;
            outfile << endl;
        }
    }
    outfile.close();
    return 0;
}