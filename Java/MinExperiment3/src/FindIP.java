import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.*;

// 扫描指定文件中的域名，获得该域名的所有IP地址，并按原先域名顺序保存到一个文本文件中
public class FindIP {
    public static String[] result; // 结果集 每一个字符串格式为 序号, 域名, IP1, IP2, IP3, …
    public static List<String> list; // 域名集合
    private static final int POOL_SIZE = 2000; // 线程数
    public static CountDownLatch latch = new CountDownLatch(POOL_SIZE); // 计数器 让主线程等待以完成计时

    public static void main(String[] args) throws Exception {
        list = new ArrayList<>();
        int len = 0;
        String line;
        String url;
        long startTime = System.currentTimeMillis();
        BufferedReader br = new BufferedReader(new FileReader("src/top-1m.csv"));
        // 读文件 将域名存入list
        while ((line = br.readLine()) != null) {
            len++;
            url = line.substring(line.lastIndexOf(',') + 1);
            list.add(url);
        }
        br.close();

        // 创建一个固定大小的线程池:
        ExecutorService es = Executors.newFixedThreadPool(POOL_SIZE);
        int low, high;
        int step = len / POOL_SIZE;
        result = new String[len];

        // 计算每个线程应该处理的url的[low, high]集合
        for (int i = 0; i < POOL_SIZE; ++i) {
            low = i * step;
            high = low + step - 1;
            es.submit(new GetAllIP(low, high));
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
        BufferedWriter bw = new BufferedWriter(new FileWriter("src/result.csv", StandardCharsets.UTF_8));
        for (String line : result) {
            bw.write(line + "\n");
        }
        bw.close();
    }
}

// 线程 每个线程处理[low, high]的域名 将结果存进result[low, high]
class GetAllIP implements Runnable {
    private final int low;
    private final int high;

    GetAllIP(int low, int high) {
        this.low = low;
        this.high = high;
    }

    @Override
    public void run() {
        for (int k = low; k <= high; k++) {
            String url = FindIP.list.get(k);
            StringBuffer sb = new StringBuffer(k + ", " + url);
            try {
                // 获取域名下所有的IP
                InetAddress[] addresses = InetAddress.getAllByName(url);
                for (InetAddress address : addresses) {
                    sb.append(", ").append(address.getHostAddress());
                }
                String line = sb.toString();
                FindIP.result[k] = line;
                System.out.println(line);

            } catch (Exception e) {
                FindIP.result[k] = sb.append(", DNS not found").toString();
                System.out.println(FindIP.list.get(k) + " DNS not found");
            }
        }
        FindIP.latch.countDown(); // 线程完毕 latch-1
    }
}
