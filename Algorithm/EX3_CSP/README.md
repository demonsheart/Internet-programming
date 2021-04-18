## 地图CSP问题

* 实验目的：

  > （1） 掌握回溯法算法设计思想。
  >
  > （2） 掌握地图填色问题的回溯法解法。

* 实验内容：

  > 1、对小规模数据，利用四色填色测试算法的正确性；
  >
  > 2、对附件中给定的地图数据填涂；

* 完成情况

  > * 简单回溯法下对小规模地图涂色
  >
  > * 附件中的三个col文件，只能跑通两个。运用了弧一致性检验、最小剩余量、最小约束值。

* 代码说明

  > 保证 cpp与col文件同目录
  > minGraph.col 是从 Map.png 中编写的数据
  > MACGraph.cpp 默认给le450_5a.col le450_25a.col着色
  > SimpleGraph.cpp 默认给minGraph.col着色
