import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.*;

public class CountSmallFiles {
    public static CountDownLatch latch;

    public static void main(String[] args) throws Exception {
        File dic = new File("src/Datasets/File100/");
        if (dic.isDirectory()) {
            String[] str = dic.list();
            latch = new CountDownLatch(str.length);
            long startTime = System.currentTimeMillis();

            // 创建线程池
            ExecutorService es = Executors.newFixedThreadPool(5);
            for (String fileName : str) {
                es.submit(new Task(fileName));
            }
            es.shutdown();

            // 通过latch阻塞主函数线程
            // 当所有线程跑完 解除阻塞 进而统计时间
            latch.await();
            long endTime = System.currentTimeMillis();
            System.out.println("total used " + (endTime - startTime) + "ms");
        }
    }
}

class Task implements Runnable {
    private final String fileName;

    public Task(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public void run() {
        try {
            countWords(fileName);
            CountSmallFiles.latch.countDown(); // 线程基本完毕 latch-1
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 对单个文件统计输出单词频次
     *
     * @param fileName 文件名
     */
    public static void countWords(String fileName) throws Exception {
        String filePath = "src/Datasets/File100/" + fileName;
        BufferedReader br = new BufferedReader(new FileReader(filePath, StandardCharsets.UTF_8));
        String line;
        List<String> lists = new ArrayList<>();
        while ((line = br.readLine()) != null) {
            // 每一行以非单词字符分割 并且将单词转换为小写
            line = line.toLowerCase(Locale.ROOT);
            String[] wordsArr = line.split("[^a-zA-Z]");
            for (String word : wordsArr) {
                if (word.length() != 0) {
                    if (word.length() == 1 && !word.equals("a") && !word.equals("i")) {
                        continue;
                    }
                    lists.add(word);
                }
            }
        }
        br.close();

        //通过Map统计频次
        Map<String, Integer> mp = new TreeMap<>();
        for (String word : lists) {
            mp.merge(word, 1, Integer::sum);
        }

        //将Map的键值对取出到list中， 再通过频次降序排序
        ArrayList<Map.Entry<String, Integer>> res = new ArrayList<>(mp.entrySet());
        // 降序排序
        res.sort(new Comparator<>() {
            @Override
            public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
                return o2.getValue() - o1.getValue();
            }
        });

        //Sta_A.txt
        String path = "src/Result/File100/Sta_" + fileName;
        BufferedWriter bw = new BufferedWriter(new FileWriter(path, StandardCharsets.UTF_8));
        for (Map.Entry<String, Integer> x : res) {
            bw.write(x.getKey() + ' ' + x.getValue() + '\n');
        }
        bw.close();
        System.out.println(fileName + " has been processed.");
    }
}