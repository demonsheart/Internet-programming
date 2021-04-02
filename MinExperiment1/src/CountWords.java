import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class CountWords {
    public static void main(String[] args) throws Exception {
        Vector v = new Vector(4);
        v.add("blockchain.txt");
        v.add("distributed system.txt");
        v.add("high performance.txt");
        v.add("trajectory.txt");
        long totalTime = 0;

        for (Object fileName : v) {
            // 记录时刻
            long startTime = System.currentTimeMillis();

            String filePath = "src/data/" + fileName;
            BufferedReader br = new BufferedReader(new FileReader(filePath, StandardCharsets.UTF_16LE));
            String line = null;
            List<String> lists = new ArrayList<String>();
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
            Map<String, Integer> mp = new TreeMap<String, Integer>();
            for (String word : lists) {
                if (mp.get(word) != null) {
                    mp.put(word, mp.get(word) + 1);
                } else {
                    mp.put(word, 1);
                }
            }

            //将Map的键值对取出到list中， 再通过频次降序排序
            ArrayList<Map.Entry<String, Integer>> res = new ArrayList<Map.Entry<String, Integer>>(mp.entrySet());
            // 降序排序
            res.sort(new Comparator<Map.Entry<String, Integer>>() {
                @Override
                public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
                    return o2.getValue() - o1.getValue();
                }
            });

            //Sta_A.txt
            String path = "src/result/Sta_" + fileName;
            BufferedWriter bw = new BufferedWriter(new FileWriter(path, StandardCharsets.UTF_8));
            for (Map.Entry<String, Integer> x : res) {
                bw.write(x.getKey() + ' ' + x.getValue() + '\n');
            }
            bw.close();

            // 记录时刻
            long endTime = System.currentTimeMillis();
            totalTime += endTime - startTime;
            System.out.println(fileName + " used "+(endTime-startTime)+"ms");
        }
        System.out.println("Successfully!");
        System.out.println("Total used "+ totalTime + "ms");
    }
}
