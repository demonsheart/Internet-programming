import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.RandomAccessFile;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.*;

public class CountBigFiles {
    public static int threadSize = 1;
    public static String rootPath = "src/Datasets/BigFiles/";
    // src/Datasets/BigFiles/
    // src/Datasets/File100/
    public static String fileName = "test.txt";
    // Alexander Pope___The Works of Alexander Pope, Volume 1.txt
    public static String outRootPath = "src/Result/BigFiles/Sta_";
    // src/Result/BigFiles/Sta_
    // src/Result/Sta_


    public static void main(String[] args) throws Exception {
        //开启线程池
        ExecutorService es = Executors.newFixedThreadPool(threadSize);

        //线程处理
        long startTime = System.currentTimeMillis();
        List<CountPartOfBigFiles> tasks = new ArrayList<>();
        for (int i = 1; i <= threadSize; ++i) {
            tasks.add(new CountPartOfBigFiles(i));
        }
        HashMap<String, Integer> mp = new HashMap<>();
        // 任务批量提交并执行
        List<Future<HashMap<String, Integer>>> futures = es.invokeAll(tasks);
        // 获取执行结果，这个方法会产生阻塞，会一直等到任务执行完毕才返回
        for (Future<HashMap<String, Integer>> future : futures) {
            HashMap<String, Integer> f = future.get();
            for (Map.Entry<String, Integer> v : f.entrySet()) {
                mp.merge(v.getKey(), v.getValue(), Integer::sum);
            }
        }
        es.shutdown();

        //统计输出
        //将Map的键值对取出到list中， 再通过频次降序排序
        ArrayList<Map.Entry<String, Integer>> re = new ArrayList<>(mp.entrySet());
        // 降序排序
        re.sort((o1, o2) -> o2.getValue() - o1.getValue());

        //Sta_A.txt
        String path = outRootPath + fileName;
        BufferedWriter bw = new BufferedWriter(new FileWriter(path, StandardCharsets.UTF_8));
        for (Map.Entry<String, Integer> x : re) {
            bw.write(x.getKey() + ' ' + x.getValue() + '\n');
        }
        bw.close();
        long endTime = System.currentTimeMillis();
        System.out.println("threadSize:" + threadSize + " used " + (endTime - startTime) + "ms");
        System.out.println(fileName + " has been processed.");
    }
}

/**
 * 线程池的任务
 * 分部分读取大文件
 */
class CountPartOfBigFiles implements Callable<HashMap<String, Integer>> {

    private final int currentPart;
    private HashMap<String, Integer> mp;


    public CountPartOfBigFiles(int currentPart) {
        this.currentPart = currentPart;
        mp = new HashMap<>();
    }

    @Override
    public HashMap<String, Integer> call() throws Exception {
        try {
            RandomAccessFile fileAccess = new RandomAccessFile(CountBigFiles.rootPath + CountBigFiles.fileName, "r");
            // 计算[start, end]偏移量范围
            long len = fileAccess.length();
            long step = len / CountBigFiles.threadSize;
            long start = step * (currentPart - 1);
            long end = start + step;

            // end处理， 如果刚好到末尾，则下移一位偏移量
            fileAccess.seek(end);
            char lastChar = (char) fileAccess.read();
            if (lastChar == '\n') {
                end += 1;
            }

            // start处理
            fileAccess.seek(start);
            if (start > 0) {
                while (fileAccess.read() != '\n') {
                    start++;
                }
                start++;
            }

            fileAccess.seek(start);
            String line;
            while (fileAccess.getFilePointer() < end) {
                // 每一行以非单词字符分割 并且将单词转换为小写
                line = fileAccess.readLine().toLowerCase(Locale.ROOT);
                String[] wordsArr = line.split("[^a-zA-Z]");
                for (String word : wordsArr) {
                    if (word.length() != 0) {
                        if (word.length() == 1 && !word.equals("a") && !word.equals("i")) {
                            continue;
                        }
                        mp.merge(word, 1, Integer::sum);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return this.mp;
    }
}