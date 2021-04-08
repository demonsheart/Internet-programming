import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.RandomAccessFile;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.*;

public class CountBigFiles {
    // 文件较大 直接设为静态
    public static int threadSize = 16;
    public static List<List<String>> lists = new LinkedList<>();
    public static Map<String, Integer> res = new TreeMap<>();
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
        // 任务批量提交并执行
        List<Future<Object>> futures = es.invokeAll(tasks);
        // 获取执行结果，这个方法会产生阻塞，会一直等到任务执行完毕才返回
        for (Future<Object> future : futures) {
            future.get();
        }
        es.shutdown();

        //通过Map统计频次
        for (List<String> list : lists) {
            for (String word : list) {
                res.merge(word, 1, Integer::sum);
            }
        }

        //统计输出
        //将Map的键值对取出到list中， 再通过频次降序排序
        ArrayList<Map.Entry<String, Integer>> re = new ArrayList<>(res.entrySet());
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
class CountPartOfBigFiles implements Callable<Object> {

    private final int currentPart;

    public CountPartOfBigFiles(int currentPart) {
        this.currentPart = currentPart;
    }

    @Override
    public Object call() throws Exception {
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
            List<String> list = new ArrayList<>();
            while (fileAccess.getFilePointer() < end) {
                // 每一行以非单词字符分割 并且将单词转换为小写
                line = fileAccess.readLine().toLowerCase(Locale.ROOT);
                String[] wordsArr = line.split("[^a-zA-Z]");
                for (String word : wordsArr) {
                    if (word.length() != 0) {
                        if (word.length() == 1 && !word.equals("a") && !word.equals("i")) {
                            continue;
                        }
                        list.add(word);
                    }
                }
            }
            CountBigFiles.lists.add(list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}