#include <algorithm>
#include <fstream>
#include <iostream>
#include <queue>
#include <sstream>
#include <string>
#include <time.h>
#include <vector>
using namespace std;

// 引入并查集 生成树
// 邻接表存边信息
class Graph
{
private:
    int verNum;
    int edgeNum;
    string filename;
    vector<int> fa;                 // 并查集
    vector<int> deep;               // 深度
    vector<vector<int>> li;         // 邻接表
    vector<int> tree;               // 生成树
    vector<bool> visited;           // 记录访问数组
    vector<bool> root;              // 根记录
    vector<pair<int, int>> bridges; // 桥集合

    inline void mergeSet(int i, int j)
    {
        //先找到两个根节点
        int x = findFa(i), y = findFa(j);
        if (x != y)
        {
            fa[y] = x;       // 以x作为最新的根节点
            root[y] = false; // 此时 y已不是根
        }
    }
    inline int findFa(int x)
    {
        if (x == fa[x])
            return x;
        else
        {
            fa[x] = findFa(fa[x]); //父节点设为根节点
            return fa[x];          //返回父节点
        }
    }
    // 通过BFS对每个根生成树
    void initTree(int start)
    {
        struct message
        {
            int pre;
            int cur;
            int dept;
        };

        // BFS建树
        queue<message> q;
        message m{start, start, 0};
        q.push(m);

        while (!q.empty())
        {
            message tmp = q.front();
            visited[tmp.cur] = true;
            deep[tmp.cur] = tmp.dept;
            tree[tmp.cur] = tmp.pre;
            q.pop();
            auto &l = li[tmp.cur];
            for (auto x : l)
            {
                if (!visited[x])
                {
                    visited[x] = true;
                    q.push(message{tmp.cur, x, tmp.dept + 1});
                }
            }
        }
    }
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
        li[v].push_back(u);
    }
    inline void clearVisit()
    {
        for (int i = 0; i < verNum; i++)
            visited[i] = false;
    }

    // lca找环边
    void lca()
    {
        ifstream in;
        in.open(filename, ios::in);
        string line;
        stringstream ss;
        int u, v;
        clearVisit();
        getline(in, line);
        getline(in, line);

        // 最基本的lca算法
        for (int i = 0; i < edgeNum; i++)
        {
            ss.clear();
            getline(in, line);
            ss << line;
            ss >> u >> v;
            // 重边开始找环边
            if (u != tree[v] && v != tree[u])
            {
                // 高度调整
                if (deep[u] > deep[v])
                {
                    int h = deep[u] - deep[v];
                    while (h--)
                    {
                        visited[u] = true;
                        u = tree[u];
                    }
                }
                else if (deep[v] > deep[u])
                {
                    int h = deep[v] - deep[u];
                    while (h--)
                    {
                        visited[v] = true;
                        v = tree[v];
                    }
                }

                // 同时寻找公共祖先
                while (u != v)
                {
                    visited[u] = visited[v] = true;
                    u = tree[u];
                    v = tree[v];
                }
            }
        }
    }
    // 暴力法 + 生成树优化
    void baseAndTree()
    {
        bool flag;
        int cur, u, v;
        for (int i = 0; i < verNum; ++i)
        {
            //初始化visit数组
            clearVisit();
            // 对于树上的每条边的两个顶点 删掉并判断是否能连通
            u = i, v = tree[i], flag = true;
            removeUV(u, v);
            // BFS检测
            queue<int> st;
            st.push(u);
            while (!st.empty())
            {
                cur = st.front();
                st.pop();
                visited[cur] = true;
                if (cur == v)
                {
                    flag = false;
                    break;
                }
                for (int j = 0; j < verNum; ++j)
                {
                    if (!visited[j] && isNeighbor(cur, j))
                    {
                        st.push(j);
                    }
                }
            }
            if (flag)
            {
                bridges.push_back(make_pair(u, v));
                // cout << u << " " << v << endl;
            }
            restoreUV(u, v);
        }
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
        this->filename = fileName;

        getline(in, line);
        ss << line;
        ss >> verNum;
        ss.clear();
        getline(in, line);
        ss << line;
        ss >> edgeNum;

        fa.resize(verNum);
        deep.resize(verNum);
        visited.resize(verNum);
        tree.resize(verNum);
        root.resize(verNum);
        vector<int> tmpl;
        for (int i = 0; i < verNum; ++i)
        {
            li.push_back(tmpl);
            fa[i] = i;
            tree[i] = i;
            deep[i] = 0;
            visited[i] = false;
            root[i] = true;
        }

        // cout << verNum << " " << edgeNum << endl;
        for (int i = 0; i < edgeNum; i++)
        {
            ss.clear();
            getline(in, line);
            ss << line;
            ss >> a1 >> a2;
            li[a1].push_back(a2);
            li[a2].push_back(a1);
            mergeSet(a1, a2);
            // cout << i + 3 << ": " << a1 << " " << a2 << endl;
        }
        // 对每个根节点建树
        for (int i = 0; i < verNum; ++i)
        {
            if (root[i])
                initTree(i);
        }
        cout << "Successfully init " << fileName << endl;
    }

    void BaseGetResult()
    {
        baseAndTree();
        // 输出结果
        cout << "There are " << bridges.size() << " bridges: " << endl;
        for (auto x : bridges)
        {
            cout << x.first << " " << x.second << endl;
        }
    }
    void lcaGetResult()
    {
        lca();
        for (int i = 0; i < verNum; ++i)
        {
            if (!visited[i] && tree[i] != i)
                bridges.push_back(make_pair(i, tree[i]));
        }
        cout << "There are " << bridges.size() << " bridges: " << endl;
        for (auto x : bridges)
        {
            cout << x.first << " " << x.second << endl;
        }
    }
};

int main()
{
    // string fileName = "minG.txt";
    // string fileName = "mediumG.txt";
    string fileName = "largeG.txt";
    Graph g(fileName);

    clock_t start = clock();
    // g.BaseGetResult();
    g.lcaGetResult();
    clock_t end = clock();
    double duration = (double)(end - start) / CLOCKS_PER_SEC * 1000;
    cout << "Total used " << duration << " ms." << endl;
    return 0;
}