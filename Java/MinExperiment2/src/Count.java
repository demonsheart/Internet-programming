import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class Count {
    public static void main(String[] args) throws Exception {
        File dic = new File("src/Datasets/BigFiles");
        if (dic.isDirectory()) {
            String[] str = dic.list();
            for (String fileName : str) {
                // 记录时刻
                long startTime = System.currentTimeMillis();

                String filePath = "src/Datasets/BigFiles/" + fileName;
                BufferedReader br = new BufferedReader(new FileReader(filePath, StandardCharsets.UTF_8));
                String line = null;
                //通过Map统计频次
                HashMap<String, Integer> mp = new HashMap<>();
                while ((line = br.readLine()) != null) {
                    // 每一行以非单词字符分割 并且将单词转换为小写
                    line = line.toLowerCase(Locale.ROOT);
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
                br.close();

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
                String path = "src/Result/BigFiles/Sta_" + fileName;
                BufferedWriter bw = new BufferedWriter(new FileWriter(path, StandardCharsets.UTF_8));
                for (Map.Entry<String, Integer> x : res) {
                    bw.write(x.getKey() + ' ' + x.getValue() + '\n');
                }
                bw.close();
                // 记录时刻
                long endTime = System.currentTimeMillis();
                System.out.println(fileName + " used " + (endTime - startTime) + "ms");
            }
        }
    }
}