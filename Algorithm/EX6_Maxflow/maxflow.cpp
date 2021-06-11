#include <algorithm>
#include <climits>
#include <cstdlib>
#include <iostream>
#include <queue>
#include <random>
#include <sstream>
#include <time.h>
#include <vector>

using namespace std;

default_random_engine e(time(0));

// [min, max]
inline int random_int(int min, int max)
{
    uniform_int_distribution<unsigned> u(min, max);
    return u(e);
}

struct OriginalEdge // 原来的边
{
    int u, v, w;
};

struct Edge // 算法用的边
{
    int to, w, pre; // 指向、边权、以该顶点为起点的上一条边
    // pre = -1 表示没有上一条边
    Edge() {}
    Edge(int to, int w, int pre)
    {
        this->to = to;
        this->w = w;
        this->pre = pre;
    }
};

class Graph
{
private:
    int doctorNum, holidayNum, c, totalday, source, target, verNum, edgeNum, count, maxflow;

    vector<int> D;              // D[i]表示假期i对应的天数
    vector<OriginalEdge> edges; // 初始边
    vector<int> tail;           // 邻接表 tail[u]表示以u为起点的最后一条边的下标 通过pre上溯可查找到以u为起点的所有的边
    vector<int> cur;            // 记录每个顶点遍历到哪条边 进行弧优化
    vector<Edge> e;             // 边集
    queue<int> Q;               // bfsForDinic队列
    vector<int> deep;           // 深度 即离汇点的距离
    vector<bool> visited;       // FK算法用 访问数组

    // FordFulkerson的最直接的DFS
    int dfsForFk(int tis, int delta)
    {
        visited[tis] = true;
        if (tis == target)
            return delta;
        for (int i = tail[tis]; i != -1; i = e[i].pre)
        {
            if (e[i].w && !visited[e[i].to])
            {
                // f 为一条dfs路径上的增广
                int f = dfsForFk(e[i].to, min(e[i].w, delta));
                if (f > 0)
                {
                    e[i].w -= f;     // 正边减流
                    e[i ^ 1].w += f; // 反边加流 异或保证正反边
                    return f;
                }
            }
        }
        return 0;
    }
    // BFS分层
    bool bfsForDinic()
    {
        // 重新计算deep数组
        for (int i = 0; i < verNum; ++i)
            deep[i] = -1;
        while (!Q.empty())
            Q.pop();
        Q.push(source);
        deep[source] = 0;
        while (!Q.empty())
        {
            int tis = Q.front();
            Q.pop();
            // 当i = -1表示以tis为起点的边已被遍历完
            for (int i = tail[tis]; i != -1; i = e[i].pre)
            {
                // 下一层
                if (e[i].w && deep[e[i].to] == -1)
                {
                    Q.push(e[i].to);
                    deep[e[i].to] = deep[tis] + 1;
                }
            }
        }
        return deep[target] != -1; // 汇点是否可达
    }
    // dfs 弧优化 多路复用
    int dfsForDinic(int tis, int delta)
    {
        if (tis == target)
            return delta;
        int result = 0;
        // 多路增广 tis -> i(多个边)
        for (int i = cur[tis]; delta && i != -1; i = e[i].pre)
        {
            cur[tis] = i;                                 // 弧优化记录
            if (e[i].w && deep[e[i].to] == deep[tis] + 1) // 沿着深度增加的方向增广
            {
                // f 为一条dfsForDinic路径上的增广
                int f = dfsForDinic(e[i].to, min(e[i].w, delta));
                if (f > 0)
                {
                    e[i].w -= f;     // 正边减流
                    e[i ^ 1].w += f; // 反边加流 异或保证正反边
                    delta -= f;      // 减去f以检测是否需要终止本次多路增广
                    result += f;
                }
            }
        }
        return result;
    }

    // 如果有解 则可计算出方案
    void getSolution()
    {
        // 从汇点反查三步 构造解路径
        vector<vector<int>> list; // 反查路径链表
        list.resize(totalday);
        // 反查到具体天数节点
        int index = 0;
        for (int i = tail[target]; i != -1; i = e[i].pre)
        {
            if (e[i].w == 1)
            {
                // cout << e[i].to << endl;
                list[index++].push_back(e[i].to);
            }
        }
        // 反查到假期
        for (int i = 0; i < totalday; ++i)
        {
            int day = list[i][0];
            for (int j = tail[day]; j != -1; j = e[j].pre)
            {
                if (e[j].w == 1)
                {
                    // cout << e[j].to << endl;
                    list[i].push_back(e[j].to);
                    break;
                }
            }
        }
        // 反查到医生
        for (int i = 0; i < totalday; ++i)
        {
            int day = list[i][1];
            for (int j = tail[day]; j != -1; j = e[j].pre)
            {
                if (e[j].w == 1 && e[j].to <= doctorNum) // 在这里 有可能有第三层的正边没被推入流 需要过滤掉
                {
                    // cout << e[j].to << endl;
                    list[i].push_back(e[j].to);
                }
            }
        }
        // 至此 已经找到路径 需要还原为答案解
        // list的一个数组为 具体天数节点 -> 假期节点 -> 医生节点
        for (int i = 0; i < totalday; ++i)
        {
            list[i][1] = ((list[i][1] - doctorNum - 1) / doctorNum) + 1; // 假期节点转换为假期类型
            // cout << list[i][1] << endl;
        }
        for (int i = 0; i < totalday; ++i)
        {
            int day = list[i][0];
            day -= doctorNum + doctorNum * holidayNum; // 减去前面节点数偏移
            // 反查D[i]数组获取第几天
            for (auto x : D)
            {
                day -= x;
                if (day <= 0)
                {
                    day += x;
                    break;
                }
            }
            list[i][0] = day;
            // cout << index << " ";
        }
        sort(list.begin(), list.end(), [](vector<int> x, vector<int> y)
             { return x[2] < y[2]; });
        // 输出答案
        for (int i = 0; i < totalday; ++i)
        {
            cout << "doctor: " << list[i][2] << ", holiday: " << list[i][1] << ", exactly day: " << list[i][0] << endl;
        }
    }

public:
    Graph() {}
    void enterInitOrigin()
    {
        cout << "Please enter c: " << endl;
        cin >> c;
        cout << "Please enter doctorNum: " << endl;
        cin >> doctorNum;
        cout << "Please enter holidayNum: " << endl;
        cin >> holidayNum;
        cout << "Please enter the number of days of the holiday in turn" << endl;

        int tmp;
        for (int i = 0; i < holidayNum; ++i)
        {
            cin >> tmp;
            D.push_back(tmp);
        }
        cout << "Init c as " << c << ", doctorNum as " << doctorNum << ", holidayNum as " << holidayNum << endl;
        cout << "Dj as belows:" << endl;
        for (auto x : D)
            cout << x << " ";
        cout << "\n"
             << endl;
    }
    void randomInitOrigin()
    {
        doctorNum = random_int(1, 100);
        holidayNum = random_int(1, 50);
        c = random_int(1, 20);
        D.clear();
        for (int i = 0; i < holidayNum; ++i)
            D.push_back(random_int(2, 7));
        cout << "Random init c as " << c << ", doctorNum as " << doctorNum << ", holidayNum as " << holidayNum << endl;
        cout << "Dj as belows:" << endl;
        for (auto x : D)
            cout << x << " ";
        cout << "\n"
             << endl;
    }
    // 生成数据
    void generateGraph()
    {
        totalday = 0;
        for (auto x : D)
            totalday += x;
        source = 0;
        target = 1 + totalday + doctorNum + doctorNum * holidayNum;
        verNum = target + 1;

        int i, j, k, u, v, w;
        // 第一层
        u = 0;
        w = c; // 假设c
        for (i = 1; i <= doctorNum; ++i)
        {
            // cout << u << " -> " << i << endl;
            edges.push_back(OriginalEdge{u, i, w});
        }
        // 第二层
        w = 1;
        for (i = 1; i <= doctorNum; ++i)
        {
            for (j = 0; j < holidayNum; ++j)
            {
                u = i;
                v = doctorNum + i + j * doctorNum;
                // cout << u << " -> " << v << endl;
                edges.push_back(OriginalEdge{u, v, w});
            }
        }
        // cout << endl;
        // 第三层
        int len = 0;
        for (i = 1; i <= holidayNum; ++i)
        {
            for (j = 1; j <= doctorNum; ++j)
            {
                u = doctorNum + doctorNum * (i - 1) + j;
                for (k = 1; k <= D[i - 1]; ++k)
                {
                    v = doctorNum + doctorNum * holidayNum + k + len;
                    // cout << u << " -> " << v << endl;
                    edges.push_back(OriginalEdge{u, v, w});
                }
            }
            len += D[i - 1];
        }
        // cout << endl;
        // 第四层
        v = target;
        for (k = 1; k <= totalday; ++k)
        {
            u = doctorNum + doctorNum * holidayNum + k;
            // cout << u << " -> " << v << endl;
            edges.push_back(OriginalEdge{u, v, w});
        }

        edgeNum = edges.size();
    }
    // 为算法初始化变量
    void initVarForAlgorithm()
    {
        // 初始化vector
        tail.resize(verNum, -1);
        cur.resize(verNum, -1);
        deep.resize(verNum, -1);
        e.resize(2 * edgeNum);
        visited.resize(verNum, false);

        count = -1;
        for (auto x : edges)
        {
            int u = x.u, v = x.v, w = x.w;
            // 正边
            e[++count] = Edge(v, w, tail[u]);
            tail[u] = count;
            // 反边
            e[++count] = Edge(u, 0, tail[v]);
            tail[v] = count;
        }
    }

    int DinicMaxflow()
    {
        int result = 0;
        // Dinic算法 bfsForDinic结合dfsForDinic
        while (bfsForDinic())
        {
            cur = tail; // 每做一次bfsForDinic 刷新cur数组
            result += dfsForDinic(source, INT_MAX);
        }
        return result;
    }

    int FkMaxflow()
    {
        int result = 0;
        // FordFulkerson
        while (true)
        {
            for (int i = 0; i < verNum; ++i)
                visited[i] = false;
            int delta = dfsForFk(source, INT_MAX);
            if (delta == 0)
            {
                break;
            }
            result += delta;
        }
        return result;
    }

    void getResult(int method)
    {
        if (method == 0)
            maxflow = DinicMaxflow();
        if (method == 1)
            maxflow = FkMaxflow();
        cout << "maxflow: " << maxflow << " totalDay: " << totalday << endl;
        if (maxflow == totalday)
        {
            cout << "OK, have got a solution:" << endl;
            getSolution();
        }
        else
        {
            cout << "No solution" << endl;
        }
    }
};

int main()
{
    Graph g;
    g.enterInitOrigin();
    // g.randomInitOrigin();
    g.generateGraph();
    g.initVarForAlgorithm();

    clock_t start = clock();
    g.getResult(0); // 0使用Dicnic 1使用FK
    clock_t end = clock();
    double duration = (double)(end - start) / CLOCKS_PER_SEC * 1000;
    cout << "Total used " << duration << " ms." << endl;
    return 0;
}