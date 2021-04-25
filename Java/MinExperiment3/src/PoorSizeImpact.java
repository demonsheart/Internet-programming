import java.io.*;
import java.net.InetAddress;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class PoorSizeImpact {
    public static String[] result; // 结果集 每一个字符串格式为 序号, 域名, IP1, IP2, IP3, …
    public static List<String> list; // 域名集合
    private static final int POOL_SIZE = 2000; // 线程数
    public static CountDownLatch latch = new CountDownLatch(POOL_SIZE); // 计数器 让主线程等待以完成计时
    private static int len = 10000; // 读取域名数

    public static void main(String[] args) throws Exception {
        list = new ArrayList<>();
        String line;
        String url;
        long startTime = System.currentTimeMillis();
        BufferedReader br = new BufferedReader(new FileReader("src/top-1m.csv"));
        // 读文件 将域名存入list
        int i = len;
        while (i > 0 && (line = br.readLine()) != null) {
            url = line.substring(line.lastIndexOf(',') + 1);
            list.add(url);
            i--;
        }
        System.out.println(list.size());
        br.close();

        // 创建一个固定大小的线程池:
        ExecutorService es = Executors.newFixedThreadPool(POOL_SIZE);
        int low, high;
        int step = len / POOL_SIZE;
        result = new String[len];

        // 计算每个线程应该处理的url的[low, high]集合
        for (i = 0; i < POOL_SIZE; ++i) {
            low = i * step;
            high = low + step - 1;
            es.submit(new GetIP(low, high));
        }
        es.shutdown();

        // 通过latch阻塞主函数线程
        // 当所有线程跑完 解除阻塞 进而统计时间
        latch.await();
        saveResult();
        long endTime = System.currentTimeMillis();
        System.out.println("total used " + (endTime - startTime) + "ms");
    }

    // 当结果统计完 存入文件
    private static void saveResult() throws IOException {
        BufferedWriter bw = new BufferedWriter(new FileWriter("src/tmp.csv", StandardCharsets.UTF_8));
        for (String line : result) {
            bw.write(line + "\n");
        }
        bw.close();
    }
}

class GetIP implements Runnable {
    private final int low;
    private final int high;

    GetIP(int low, int high) {
        this.low = low;
        this.high = high;
    }

    @Override
    public void run() {
        for (int k = low; k <= high; k++) {
            String url = PoorSizeImpact.list.get(k);
            StringBuffer sb = new StringBuffer(k + ", " + url);
            try {
                InetAddress[] addresses = InetAddress.getAllByName(url);
                for (InetAddress address : addresses) {
                    sb.append(", ").append(address.getHostAddress());
                }
                String line = sb.toString();
                PoorSizeImpact.result[k] = line;
                System.out.println(line);

            } catch (Exception e) {
                PoorSizeImpact.result[k] = sb.append(", DNS not found").toString();
                System.out.println(PoorSizeImpact.list.get(k) + " DNS not found");
            }
        }
        PoorSizeImpact.latch.countDown(); // 线程完毕 latch-1
    }
}
