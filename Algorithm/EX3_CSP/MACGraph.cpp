/**
 * 对给出的图进行染色
 * 由于数据量比较大 在回溯的基础上 加上弧一致性进行压缩处理
 * 基于MAC-3算法实现
 */
#include <algorithm>
#include <fstream>
#include <iostream>
#include <queue>
#include <sstream>
#include <time.h>
#include <vector>
using namespace std;

struct Point
{
    int index;
    int remain; // 剩余量
    Point(int index, int remain)
    {
        this->index = index;
        this->remain = remain;
    }
};

struct Color
{
    int index;  // 颜色
    int impact; // 颜色的影响力
    Color(int index, int impact)
    {
        this->index = index;
        this->impact = impact;
    }
};

bool cmpRe(const Point &p1, const Point &p2)
{
    return p1.remain < p2.remain;
}

bool cmpImpact(const Color &c1, const Color &c2)
{
    return c1.impact < c2.impact;
}

class MACGraph
{
private:
    int VerNum;  // 顶点数
    int edgeNum; // 边数
    int dyedNum; // 已经染色的数量
    int colorNum;
    vector<Point> vars;
    bool **Ma;            // 图的邻接矩阵
    vector<int> solution; // index -> Color 解决方案
    queue<pair<int, int>> arcs;
    int **domain; // 解空间 验证弧一致性用到
    string fileName;

public:
    // 初始化变量
    MACGraph(string fileName, int colorNum)
    {
        this->fileName = fileName;
        this->colorNum = colorNum;
        dyedNum = 0;
        ifstream in;
        string line, tmp;
        int i, j;
        string c;

        in.open(fileName, ios::in);
        while (getline(in, line))
        {
            stringstream ss;
            ss << line;
            ss >> c;
            if (c == "p")
            {
                ss >> tmp >> VerNum >> edgeNum;
                // cout << VerNum << " " << edgeNum;
                break;
            }
        }

        // 邻接矩阵的初始化
        Ma = new bool *[VerNum];
        for (i = 0; i < VerNum; i++)
            Ma[i] = new bool[VerNum];
        for (i = 0; i < VerNum; i++)
            for (j = 0; j < VerNum; ++j)
                Ma[i][j] = false;

        // domain solution vars初始化
        domain = new int *[VerNum];
        for (int i = 0; i < VerNum; i++)
        {
            domain[i] = new int[colorNum];
            solution.push_back(-1);
            vars.push_back(Point(i, colorNum));
        }
        for (int i = 0; i < VerNum; i++)
            for (int j = 0; j < colorNum; j++)
                domain[i][j] = -1; // 未上色

        while (getline(in, line))
        {
            stringstream ss;
            ss << line;
            // cout << line << endl;
            ss >> c >> i >> j;
            Ma[i - 1][j - 1] = Ma[j - 1][i - 1] = true;
            // cout << i - 1 << " " << j - 1 << endl;
        }
        // 度数大在前面
        in.close();
    }
    // 主调函数 负责部分变量的初始化
    void startMAC3()
    {
        int level = 0; // 当前递归深度
        backTrackingWithMAC(level);
        if (isValid())
        {
            printRe();
        }
        else
            cout << "Fail!" << endl;
    }
    // 递归回溯函数
    bool backTrackingWithMAC(int level)
    {
        // 排序 选剩余量最少的
        for (int i = 0; i < (int)vars.size(); ++i)
            vars[i].remain = caculateRemain(vars[i].index);

        sort(vars.begin(), vars.end(), cmpRe);
        Point pi = vars[0];
        int xi = pi.index;
        // cout << xi << " ";
        vector<Color> cols; // xi各种颜色的影响力
        for (int ci = 0; ci < colorNum; ++ci)
        {
            int impact = caculateImpact(xi, ci);
            cols.push_back(Color(ci, impact));
        }
        sort(cols.begin(), cols.end(), cmpImpact);

        // 涂色 每次选影响力最小的
        for (Color col : cols)
        {
            int c = col.index;
            if (domain[xi][c] == -1) // 如果颜色c未被排除
            {
                solution[xi] = c;     // 涂色 色号为c
                if (vars.size() == 1) // 结束条件 最后一个点
                    return true;
                else
                {
                    for (int k = 0; k < colorNum; ++k)
                    {
                        if (k != c && domain[xi][k] == -1) //给除了c颜色外未排除的颜色标上递归深度 便于回溯时恢复
                            domain[xi][k] = level;
                    }
                    for (Point pj : vars) // 将xi相关联的未被上色的点添加弧
                    {
                        if (Ma[pj.index][xi])
                            arcs.push(make_pair(pj.index, xi));
                    }
                    // 弧一致性检验以及下一层递归
                    vars.erase(vars.begin());
                    if (maintainingArcConsistency(level) && backTrackingWithMAC(level + 1))
                        return true;
                    else
                    {
                        // 回溯
                        solution[xi] = -1;
                        vars.insert(vars.begin(), pi);
                        restoreDomainAtLevel(level);
                    }
                }
            }
        }
        return false;
    }
    // 计算点的剩余值
    int caculateRemain(int xi)
    {
        int remain = 0;
        for (int c = 0; c < colorNum; ++c)
        {
            if (domain[xi][c] == -1)
                remain++;
        }
        return remain;
    }
    // 计算颜色影响力
    int caculateImpact(int xi, int ci)
    {
        int impact = 0;
        for (int xj = 0; xj < VerNum; ++xj)
        {
            if (xj != xi && Ma[xi][xj] && domain[xj][ci] == -1)
                impact++;
        }
        return impact;
    }
    // 检查某个变量的值域是否被清空
    bool domainWipedOut(int xi)
    {
        for (int c = 0; c < colorNum; ++c)
        {
            if (domain[xi][c] == -1)
                return false;
        }
        return true;
    }
    // 回溯时 需要恢复值域
    void restoreDomainAtLevel(int level)
    {
        for (Point pi : vars)
        {
            int xi = pi.index;
            for (int c = 0; c < colorNum; ++c)
            {
                if (domain[xi][c] == level)
                    domain[xi][c] = -1;
            }
        }
    }
    // 剔除xi xj中颜色冲突的值(弧一致性检验的单步骤)
    bool revise(int xi, int xj, int level)
    {
        bool deleted = false;
        for (int ci = 0; ci < colorNum; ++ci)
        {
            if (domain[xi][ci] == -1)
            {
                bool found = false;
                for (int cj = 0; cj < colorNum; ++cj)
                {
                    if (domain[xj][cj] == -1 && ci != cj)
                    {
                        found = true;
                        break;
                    }
                }
                if (!found)
                {
                    domain[xi][ci] = level;
                    deleted = true;
                }
            }
        }
        return deleted;
    }
    // 弧一致性检验
    bool maintainingArcConsistency(int level)
    {
        while (!arcs.empty())
        {
            pair<int, int> ar = arcs.front();
            arcs.pop();
            int xi = ar.first, xj = ar.second;
            if (revise(xi, xj, level))
            {
                if (domainWipedOut(xi))
                    return false;
                else
                {
                    for (Point pk : vars)
                    {
                        int xk = pk.index;
                        if (xj != xk && Ma[xj][xk])
                            arcs.push(make_pair(xk, xj));
                    }
                }
            }
        }
        return true;
    }

    // 检验涂色是否有效
    bool isValid()
    {
        for (int i = 0; i < VerNum; ++i)
        {
            int ci = solution[i];
            if (ci == -1)
                return false;
            for (int j = 0; j < VerNum; ++j)
            {
                int cj = solution[j];
                if (i != j && Ma[i][j] && ci == cj)
                {
                    return false;
                }
            }
        }
        return true;
    }

    // 输出染色情况
    void printRe()
    {
        cout << "Sucessfully! You used " << colorNum << " colors to draw " << fileName << endl;
        cout << "A solution:" << endl;
        for (int i = 0; i < VerNum; i++)
            cout << "Place " << i + 1 << ":Color " << solution[i] << endl;
    }
    ~MACGraph()
    {
        for (int i = 0; i < VerNum; i++)
        {
            delete[] Ma[i];
            delete[] domain[i];
        }
        delete[] Ma;
        delete[] domain;
    }
};

void test(string fileName, int colorNum)
{
    clock_t start, end;
    start = clock();
    MACGraph g(fileName, colorNum);
    g.startMAC3();
    end = clock();
    double duration = (double)(end - start) / CLOCKS_PER_SEC * 1000;
    cout << fileName << " Total used " << duration << " ms." << endl;
}

int main()
{
    test("le450_5a.col", 5);
    cout << "------------------------------------------------------------------------------------" << endl;
    test("le450_25a.col", 25);

    return 0;
}