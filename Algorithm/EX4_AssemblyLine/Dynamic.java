import java.util.Random;
import java.util.Scanner;

public class Dynamic {
    private static int n, e1, e2, x1, x2, DPResult, violenceResult;
    private static final Random r = new Random(); // 随机数生成器
    private static int[] solution;// n
    private static int[] a1; // n
    private static int[] a2; // n
    private static int[] t1; // n - 1
    private static int[] t2; // n - 1
    private static int[][] road; // 2 * n
    private static int[][] f; // 2 * n

    // road[i][j] 代表第i条流水线上第j个点的是从哪条流水线到达的 即记录了前一个节点
    // f[i][j] 代表到达第i条流水线上第j个点的最少花费值

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        long startTime, endTime, time1, time2;
        System.out.println("please enter n:");
        if (scanner.hasNextInt()) {
            n = scanner.nextInt();
        }
        randomInit();

        // 动态规划法
        startTime = System.currentTimeMillis();
        DynamicProgramming();
        endTime = System.currentTimeMillis();
        time1 = endTime - startTime;
        if (solutionIsMatch()) { // 检验
//            printSource();
//            printBPResult();
            System.out.println("DynamicProgramming used " + time1 + "ms");
        }

        // 暴力法
//        startTime = System.currentTimeMillis();
//        ViolenceLaw();
//        endTime = System.currentTimeMillis();
//        time2 = endTime - startTime;
//        // 暴力法与动态规划法的结果进行相互检验
//        if (isValid() && solutionIsMatch()) {
//            printSource();
//            printBPResult();
//            System.out.println("ViolenceLaw used " + time2 + "ms");
//            System.out.println("DynamicProgramming used " + time1 + "ms");
//        }
    }

    // 暴力递归
    private static void ViolenceLaw() {
        violenceResult = Math.min(Opt(0, n - 1) + x1, Opt(1, n - 1) + x2);
    }

    // 递归函数
    private static int Opt(int i, int j) {
        if (i == 0) {
            if (j == 0) {
                return e1 + a1[0];
            }
            int tmp1 = Opt(0, j - 1) + a1[j];
            int tmp2 = Opt(1, j - 1) + t2[j - 1] + a1[j];
            return Math.min(tmp1, tmp2);
        } else if (i == 1) {
            if (j == 0) {
                return e2 + a2[0];
            }
            int tmp1 = Opt(1, j - 1) + a2[j];
            int tmp2 = Opt(0, j - 1) + t1[j - 1] + a2[j];
            return Math.min(tmp1, tmp2);
        } else {
            System.out.println("Wrong");
            return -9999;
        }
    }

    // 动态规划
    private static void DynamicProgramming() {
        f[0][0] = e1 + a1[0];
        f[1][0] = e2 + a2[0];

        for (int k = 1; k <= n - 1; k++) {
            int tmp1 = f[0][k - 1] + a1[k]; // 0 -> 0
            int tmp2 = f[1][k - 1] + t2[k - 1] + a1[k]; // 1 -> 0
            int tmp3 = f[1][k - 1] + a2[k]; // 1 -> 1
            int tmp4 = f[0][k - 1] + t1[k - 1] + a2[k]; // 0 -> 1
            // 上面的流水线
            if (tmp1 < tmp2) {
                f[0][k] = tmp1;
                road[0][k] = 0;
            } else {
                f[0][k] = tmp2;
                road[0][k] = 1;
            }
            // 下面的流水线
            if (tmp3 < tmp4) {
                f[1][k] = tmp3;
                road[1][k] = 1;
            } else {
                f[1][k] = tmp4;
                road[1][k] = 0;
            }
        }
        // 结果
        int tmp5 = f[0][n - 1] + x1;
        int tmp6 = f[1][n - 1] + x2;
        if (tmp5 < tmp6) {
            DPResult = tmp5;
            findSolution(0);
        } else {
            DPResult = tmp6;
            findSolution(1);
        }
    }

    // 根据road和m寻找路线
    // m为终点选择的路线
    // 保存在solution中
    private static void findSolution(int m) {
        solution[n - 1] = m;
        // 从后面检查road数组 不断查找前一个选择的结点即可找到路线
        for (int j = n - 2; j >= 0; j--) {
            solution[j] = road[m][j + 1];
            m = road[m][j + 1];
        }
    }

    // 生成 1 ~ 16的随机整数
    private static int generateInt() {
        return (r.nextInt(15) + 1);
    }

    // 小规模下 暴力法与动态规划法的结果进行相互检验
    private static boolean isValid() {
        return violenceResult == DPResult;
    }

    // 前向检验solution[] 与 DPResult是否匹配
    private static boolean solutionIsMatch() {
        int min = 0, pre, current;
        pre = solution[0];
        if (pre == 0) {
            min += e1 + a1[0];
        } else {
            min += e2 + a2[0];
        }
        for (int i = 1; i < n; i++) {
            current = solution[i];
            if (pre == current) {
                if (pre == 0) {
                    min += a1[i];
                } else {
                    min += a2[i];
                }
            } else {
                if (pre == 0) {
                    min += t1[i - 1] + a2[i];
                } else {
                    min += t2[i - 1] + a1[i];
                }
            }
            pre = current;
        }
        if (solution[n - 1] == 0) {
            min += x1;
        } else {
            min += x2;
        }
        return min == DPResult;
    }

    // 分配空间
    private static void init() {
        solution = new int[n];
        a1 = new int[n];
        a2 = new int[n];
        road = new int[2][n];
        f = new int[2][n];
        t1 = new int[n - 1];
        t2 = new int[n - 1];
    }

    private static void printBPResult() {
        System.out.println("The solution is as follows:");
        for (int i = 0; i < n; i++) {
            System.out.println("S" + (i + 1) + " choose " + (solution[i] + 1));
        }
        System.out.println("Total value is " + DPResult);
    }

    // 随机生成源数据
    private static void randomInit() {
        init();
        x1 = generateInt();
        x2 = generateInt();
        e1 = generateInt();
        e2 = generateInt();
        for (int i = 0; i < n; i++) {
            a1[i] = generateInt();
            a2[i] = generateInt();
            solution[i] = -1;
            road[0][i] = road[1][i] = -1;
            f[0][i] = f[1][i] = -1;
        }
        for (int i = 0; i < n - 1; i++) {
            t1[i] = generateInt();
            t2[i] = generateInt();
        }
    }

    // 打印源数据
    private static void printSource() {
        System.out.println("The source data is as follows:");
        System.out.println("n: " + n);
        System.out.println("e1: " + e1);
        System.out.println("e2: " + e2);
        System.out.println("x1: " + x1);
        System.out.println("x2: " + x2);
        System.out.print("a1[]: ");
        for (int i = 0; i < n; i++) {
            System.out.print(a1[i] + " ");
        }
        System.out.println();
        System.out.print("a2[]: ");
        for (int i = 0; i < n; i++) {
            System.out.print(a2[i] + " ");
        }
        System.out.println();
        System.out.print("t1[]: ");
        for (int i = 0; i < n - 1; i++) {
            System.out.print(t1[i] + " ");
        }
        System.out.println();
        System.out.print("t2[]: ");
        for (int i = 0; i < n - 1; i++) {
            System.out.print(t2[i] + " ");
        }
        System.out.println("\n");
    }
}
