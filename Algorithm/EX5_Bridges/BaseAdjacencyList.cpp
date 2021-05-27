#include <algorithm>
#include <fstream>
#include <iostream>
#include <sstream>
#include <stack>
#include <string>
#include <time.h>
#include <vector>
using namespace std;

// 邻接表存边信息
class Graph
{
private:
    int verNum;
    int edgeNum;
    int connectedNum;               // 图的连通分量
    vector<pair<int, int>> bridges; // 桥
    vector<vector<int>> li;         // 邻接表

    // 是否有边
    bool isNeighbor(int i, int j)
    {
        auto &p = li[i];
        for (int k = 0; k < (int)p.size(); ++k)
        {
            if (p[k] == j)
                return true;
        }
        auto &q = li[j];
        for (int k = 0; k < (int)q.size(); ++k)
        {
            if (q[k] == i)
                return true;
        }
        return false;
    }
    void removeUV(int u, int v)
    {
        auto &p = li[u];
        auto &q = li[v];
        auto it1 = find(p.begin(), p.end(), v);
        auto it2 = find(q.begin(), q.end(), u);
        if (it1 != p.end())
            p.erase(it1);
        if (it2 != q.end())
            q.erase(it2);
    }
    void restoreUV(int u, int v)
    {
        li[u].push_back(v);
    }

public:
    // 读数据
    Graph(string fileName)
    {
        int a1, a2;
        ifstream in;
        in.open(fileName, ios::in);
        string line;
        stringstream ss;

        getline(in, line);
        ss << line;
        ss >> verNum;
        ss.clear();
        getline(in, line);
        ss << line;
        ss >> edgeNum;

        vector<int> tmpl;
        for (int i = 0; i < verNum; ++i)
            li.push_back(tmpl);

        // cout << verNum << " " << edgeNum << endl;
        for (int i = 0; i < edgeNum; i++)
        {
            ss.clear();
            getline(in, line);
            ss << line;
            ss >> a1 >> a2;
            li[a1].push_back(a2);
            // cout << i + 3 << ": " << a1 << " " << a2 << endl;
        }
        cout << "Successfully init " << fileName << endl;
        connectedNum = caculateConnectedComponent();
        cout << "Successfully calculate the connected components of the original image: " << connectedNum << endl;
    }
    // 计算桥
    void caculateBridges()
    {
        for (int i = 0; i < verNum; i++)
        {
            for (int j = 0; j < verNum; j++)
            {
                // 重复检验、 桥检验
                if (isNeighbor(i, j) && !isExistInBridges(i, j) && isBridge(i, j))
                {
                    bridges.push_back(make_pair(i, j));
                    // cout << i << " " << j << endl;
                }
            }
        }
    }
    // (i, j) (j, i)地位等同
    bool isExistInBridges(int i, int j)
    {
        return (find(bridges.begin(), bridges.end(), make_pair(i, j)) != bridges.end()) || (find(bridges.begin(), bridges.end(), make_pair(j, i)) != bridges.end());
    }

    // 检测(u, v)是否为桥
    bool isBridge(int u, int v)
    {
        bool flag = false;
        // 去除边 (u, v)
        removeUV(u, v);
        // 计算连通分量
        int num = caculateConnectedComponent();
        // cout << num << " ";
        // 与原连通做对比 增加了则为桥
        if (num > connectedNum)
            flag = true;
        // 恢复边 (u, v)
        restoreUV(u, v);
        return flag;
    }

    // 计算当前图连通分量
    int caculateConnectedComponent()
    {
        int num = 0;
        bool *visited = new bool[verNum];
        for (int i = 0; i < verNum; ++i)
            visited[i] = false;
        for (int i = 0; i < verNum; ++i)
        {
            if (!visited[i])
            {
                ++num;
                DFS(i, visited);
            }
        }
        delete[] visited;
        return num;
    }
    // 用栈代替递归 降低函数开销
    void DFS(int start, bool *visit)
    {
        stack<int> s;
        int current;
        s.push(start);

        // 深度遍历
        while (!s.empty())
        {
            current = s.top();
            s.pop();
            visit[current] = true;
            for (int i = 0; i < verNum; ++i)
            {
                if (!visit[i] && isNeighbor(current, i))
                {
                    s.push(i);
                }
            }
        }
    }

    void displayBridges()
    {
        cout << "There are " << bridges.size() << " bridges in this Graph:" << endl;
        for (auto x : bridges)
            cout << x.first << " " << x.second << endl;
    }

    ~Graph()
    {
    }
};

int main()
{
    // string fileName = "minG.txt";
    string fileName = "mediumG.txt";
    // string fileName = "largeG.txt";
    Graph g(fileName);

    clock_t start = clock();
    g.caculateBridges();
    g.displayBridges();
    clock_t end = clock();
    double duration = (double)(end - start) / CLOCKS_PER_SEC * 1000;
    cout << "Total used " << duration << " ms." << endl;
    return 0;
}