#include <algorithm>
#include <fstream>
#include <iostream>
#include <limits.h>
#include <random>
#include <time.h>
#include <vector>
using namespace std;

struct Point
{
    double x;
    double y;
    Point(double xx, double yy)
    {
        x = xx;
        y = yy;
    }
    Point()
    {
        x = 0;
        y = 0;
    }
    friend ostream &operator<<(ostream &output, const Point &p)
    {
        output << "(" << p.x << "," << p.y << ")";
        return output;
    }
};

bool CmpX(const Point &A, const Point &B)
{
    return A.x < B.x;
}

bool CmpY(const Point &A, const Point &B)
{
    return A.y < B.y;
}

double GetSquaredDis(const Point &A, const Point &B)
{
    return (A.x - B.x) * (A.x - B.x) + (A.y - B.y) * (A.y - B.y);
}

/* 生成规模为n的随机点集 */
vector<Point> GeneratePoint(int n)
{
    vector<Point> re;
    default_random_engine e;
    uniform_real_distribution<double> u(0, 10000.0); // 限制范围为[0,10000]
    e.seed(time(0));
    // cout << "Point Set:" << endl;
    for (int i = 0; i < n; ++i)
    {
        Point p(u(e), u(e));
        re.push_back(p);
        // cout << p << " ";
    }
    // cout << endl;
    return re;
}

/**
 * 蛮力法编程计算出所有点对的最短距离
 * @param pSet 平面点集
 * @param p1 结果点1
 * @param p2 结果点2
 * @return 最近距离
 */
double ViolenceClosestPair(vector<Point> &pSet, Point &p1, Point &p2)
{
    double mindis, tmp;
    int n = pSet.size();
    if (n <= 1)
        return numeric_limits<double>::max(); //设为无穷大
    else
    {
        mindis = GetSquaredDis(pSet[0], pSet[1]);
        for (int i = 0; i < n - 1; i++)
        {
            for (int j = i + 1; j < n; j++)
            {
                tmp = GetSquaredDis(pSet[i], pSet[j]);
                // cout << pSet[i] << " " << pSet[j] << " " << tmp << " ";
                if (tmp < mindis)
                {
                    mindis = tmp;
                    p1 = pSet[i];
                    p2 = pSet[j];
                }
            }
            // cout << endl;
        }
    }
    return mindis;
}

/**
 * 分治法编程计算出所有点对的最短距离
 * @param pSet 平面点集
 * @param p1 结果点1
 * @param p2 结果点2
 * @return 最近距离
 */
double DCClosestPair(vector<Point> &pSet, Point &p1, Point &p2)
{
    int len = pSet.size();

    if (len < 2)
        return numeric_limits<double>::max();
    else if (len == 2)
    {
        p1 = pSet[0];
        p2 = pSet[1];
        return GetSquaredDis(pSet[0], pSet[1]);
    }

    // 二分
    len = pSet.size();
    auto mid = (pSet.begin() + len / 2);
    vector<Point> lSet(pSet.begin(), mid);
    vector<Point> rSet(mid, pSet.end());
    double L = mid->x; // 分割线

    double left_min, right_min, min;
    Point l1, l2, r1, r2;
    left_min = DCClosestPair(lSet, l1, l2);
    right_min = DCClosestPair(rSet, r1, r2);

    if (left_min < right_min)
    {
        min = left_min;
        p1 = l1;
        p2 = l2;
    }
    else
    {
        min = right_min;
        p1 = r1;
        p2 = r2;
    }

    vector<Point> mSet; // 中间区域点集
    double d = sqrt(min);
    for (int i = 0; i < len; ++i)
        if (abs(pSet[i].x - L) < d)
            mSet.push_back(pSet[i]);
    sort(mSet.begin(), mSet.end(), CmpY); //以y排序

    // 以y顺序扫描点，并比较每个点与接下来11个邻居的距离。
    //如果其中任何一个距离小于min，更新min。
    int mlen = mSet.size();
    for (int i = 0; i < mlen - 1; ++i)
    {
        int k = 0;
        for (int j = i + 1; j < mlen; ++j)
        {
            if (++k > 11) // 最多扫描11个即可
                continue;
            double mdis = GetSquaredDis(mSet[i], mSet[j]);
            if (mdis < min)
            {
                min = mdis;
                p1 = mSet[i];
                p2 = mSet[j];
            }
        }
    }
    return min;
}
void isValid1(); //自测试
void isValid2(); // 随机数测试

int main()
{
    int test_num = 10;
    ofstream outfile;
    // 导出csv文件 交付excel处理
    outfile.open("data.csv", ios::out);
    outfile << "size, violence, Divide" << endl;
    while (test_num--)
    {
        int n;
        double min, duration;
        Point p1, p2;
        clock_t start_time, end_time;

        cout << "please input the size of points:" << endl;
        cin >> n;
        outfile << n;

        auto pSet = GeneratePoint(n);

        start_time = clock();
        min = ViolenceClosestPair(pSet, p1, p2);
        end_time = clock();
        duration = (double)(end_time - start_time) / CLOCKS_PER_SEC * 1000;
        outfile << ", " << duration;
        cout << "Violence: " << sqrt(min) << " " << p1 << " " << p2 << endl;
        cout << "used time: " << duration << " ms" << endl;

        cout << endl;

        start_time = clock();
        // 预处理根据x排序
        sort(pSet.begin(), pSet.end(), CmpX);
        min = DCClosestPair(pSet, p1, p2);
        end_time = clock();
        duration = (double)(end_time - start_time) / CLOCKS_PER_SEC * 1000;
        outfile << ", " << duration << endl;
        cout << "DC: " << sqrt(min) << " " << p1 << " " << p2 << endl;
        cout << "used time: " << duration << " ms" << endl;
        cout << "---------------------------------" << endl;
    }
    outfile.close();
    return 0;
}

void isValid1() //自测试
{
    vector<Point> v1; // 测试集
    Point p1, p2;
    double min;
    // bool flag = true;

    v1.push_back(Point(0, 0));
    v1.push_back(Point(1, 0));
    v1.push_back(Point(2, 0));
    v1.push_back(Point(3, 0));
    v1.push_back(Point(0, 1));
    v1.push_back(Point(1, 1));
    v1.push_back(Point(2, 1));
    v1.push_back(Point(3, 1));
    v1.push_back(Point(2, 1.5));
    cout << "Violence: ";
    min = ViolenceClosestPair(v1, p1, p2); //0.5 (2,1) (2,1.5)
    cout << sqrt(min) << " " << p1 << " " << p2 << endl;
    cout << "DC: ";
    min = DCClosestPair(v1, p1, p2);
    cout << sqrt(min) << " " << p1 << " " << p2 << endl;

    cout << endl;

    v1.clear();
    v1.push_back(Point(0, 0));
    v1.push_back(Point(1, 1));
    v1.push_back(Point(1, 3));
    v1.push_back(Point(2, 1));
    v1.push_back(Point(2, 3));
    v1.push_back(Point(7, 1));
    v1.push_back(Point(4, 2));
    v1.push_back(Point(5, 2));
    v1.push_back(Point(4.1, 1.75));
    v1.push_back(Point(3, 1));
    cout << "Violence: ";
    min = ViolenceClosestPair(v1, p1, p2);
    cout << sqrt(min) << " " << p1 << " " << p2 << endl; // 0.269258 (4,2) (4.1,1.75)
    cout << "DC: ";
    min = DCClosestPair(v1, p1, p2);
    cout << sqrt(min) << " " << p1 << " " << p2 << endl;
}

void isValid2()
{
    for (int i = 1; i <= 10; ++i)
    {
        auto v = GeneratePoint(1000 * i);
        Point p1, p2;
        double min;

        cout << "Violence: ";
        min = ViolenceClosestPair(v, p1, p2);
        cout << sqrt(min) << " " << p1 << " " << p2 << endl;
        cout << "DC: ";
        min = DCClosestPair(v, p1, p2);
        cout << sqrt(min) << " " << p1 << " " << p2 << endl;
    }
}