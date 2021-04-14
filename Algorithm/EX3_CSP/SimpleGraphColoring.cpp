#include <fstream>
#include <iostream>
#include <sstream>
#include <time.h>
using namespace std;

/**
 * 小规模数据，利用四色填色测试算法的正确性
 * 将报告所给的图 抽象为minGraph.txt里面的边集
 * 以二维邻接矩阵表示它 顶点i j相邻则Ma[i][j] == 1, 否则为0
 * 基于此 构建算法验证四色定理
 */
class SimpleGraphColoring
{
private:
    int colorNum;
    int **Ma;    // 图的邻接矩阵
    int VerNum;  // 顶点数
    int edgeNum; // 边数
    int *state;  // 记录染色状态
    int dyedNum; // 已经染色的数量

public:
    // 初始化变量
    SimpleGraphColoring(string fileName, int colorNum)
    {
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
        Ma = new int *[VerNum];
        state = new int[VerNum];
        for (i = 0; i < VerNum; i++)
        {
            state[i] = -1;
            Ma[i] = new int[VerNum];
        }

        for (i = 0; i < VerNum; i++)
            for (j = 0; j < VerNum; ++j)
                Ma[i][j] = 0;

        while (getline(in, line))
        {
            stringstream ss;
            ss << line;
            // cout << line << endl;
            ss >> c >> i >> j;
            Ma[i - 1][j - 1] = Ma[j - 1][i - 1] = 1;
            // cout << i - 1 << " " << j - 1 << endl;
        }
        in.close();
    }
    // 判断index下标对应节点是否可以染色
    bool isOK(int index)
    {
        for (int i = 0; i < VerNum; ++i)
        {
            if (Ma[index][i] && state[index] == state[i])
                return false;
        }
        return true;
    }
    // 开始染色
    void dye()
    {
        dye(0);
    }
    // 染色
    // 只给出一种解决方案
    bool dye(int index)
    {
        for (int i = 0; i < colorNum; ++i)
        {
            state[index] = i; // 上色
            if (isOK(index))
            {
                if (index == VerNum - 1) // 上色完成
                {
                    printState();
                    return true;
                }
                else
                {
                    if (dye(index + 1))
                        return true;
                    else
                        state[index] = -1; // 回溯
                }
            }
        }
        return false;
    }
    // 输出染色情况
    void printState()
    {
        for (int i = 0; i < VerNum; i++)
            cout << "Place " << i + 1 << ":Color " << state[i] << endl;
    }
    void printMa()
    {
        for (int i = 0; i < VerNum; i++)
        {
            for (int j = 0; j < VerNum; j++)
            {
                cout << Ma[i][j] << " ";
            }
            cout << endl;
        }
    }
    ~SimpleGraphColoring()
    {
        delete[] state;
        for (int i = 0; i < VerNum; i++)
        {
            delete[] Ma[i];
        }
        delete[] Ma;
    }
};

int main()
{
    clock_t start, end;

    start = clock();
    SimpleGraphColoring g("minGraph.col", 4);
    g.dye();
    end = clock();
    double duration = (double)(end - start) / CLOCKS_PER_SEC * 1000;
    cout << "Total used " << duration << " ms." << endl;
    return 0;
}