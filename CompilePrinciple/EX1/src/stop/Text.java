package stop;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.*;

public class Text {
    private final int totalWordNum;     // 1000
    private final int stopWordNum;
    private final ArrayList<String> stopWordList = new ArrayList<>();
    private final HashSet<String> stopWordHash = new HashSet<>();
    private final ArrayList<String> finalWords = new ArrayList<>();
    private final RandomWord r;

    public Text(int totalWordNum, float stopWordPercent, int wordMinLen, int wordMaxLen) {
        this.totalWordNum = totalWordNum;
        this.stopWordNum = (int) (totalWordNum * stopWordPercent);
        this.r = new RandomWord(wordMinLen, wordMaxLen);
    }

    /*
     产生随机停用词：生成一个文件长度和单词平均长度可控的文本文件，要求字符集为26个字母，每行生产一个单词，
     每个单词的长度随机，全部单词的平均长度可控制，通常为4、5（非严格要求），总共输出的文件长度可控制。
     */
    private void createStopWords() {
        for (int i = 0; i < stopWordNum; i++) {
            String word = r.randomWord();
            stopWordList.add(word);
            stopWordHash.add(word);
        }
    }

    /*
    产生随机待过滤文本：生成一个文件大小和单词平均长度可控的文本文件，要求字符集为26个字母+“ ”（空格）+“\r\n”（回车换行
    从文件开始一直到结束，持续输出，不额外换行（除非遇到生成的\r\n），总共输出的文件大小可控制。
     */
    private void createText() {
        // add stop words
        for (int i = 0; i < stopWordNum; i++) {
            String word = stopWordList.get(MyTool.randomInt(0, stopWordList.size() - 1));
            finalWords.add(word);
        }

        // add normal words && 5% '\n'
        int normalNum = totalWordNum - stopWordNum;
        int enterNum = (int) (totalWordNum * 0.05);
        for (int i = 0; i < normalNum; i++) {
            String word = r.randomWord();
            while (stopWordHash.contains(word)) {
                word = r.randomWord();
            }
            finalWords.add(word);
            if (i < enterNum) { finalWords.add("\n"); }
        }

        // shuffle
        Collections.shuffle(finalWords);
    }

    public void create() {
        createStopWords();
        createText();
    }

    // write list to files
    public void write(String textFileName, String stopWordFileName) throws IOException {
        String path = "src/stop/data/" +
                "" +
                "" + stopWordFileName;
        BufferedWriter bw = MyTool.getWriter(path);
        for (String word : stopWordList) {
            bw.write(word + "\n");
        }
        bw.close();

        path = "src/stop/data/" +
                "" +
                "" + textFileName;
        bw = MyTool.getWriter(path);
        for(String word : finalWords) {
            if (Objects.equals(word, "\n")) {
                bw.write(word);
            } else {
                bw.write(word + " ");
            }
        }
        bw.close();
    }

    // 一行一个单词 -> 转化为arrayList
    public static ArrayList<String> LoadStopWords(String stopWordFileName) throws IOException {
        BufferedReader br = MyTool.getReader("src/stop/data/" +
                "" +
                "" + stopWordFileName);
        ArrayList<String> words = new ArrayList<>();
        String line;
        while ((line = br.readLine()) != null) {
            words.add(line.trim());
        }
        return words;
    }

    /*
    过滤停用词：写一个程序，快速扫描待过滤文本，然后将待过滤文本中出现的所有停用词，替换为“**”，
    要求禁用正则表达式，不要误杀（例如，若停用词包括“abc”，那么“abcd”等不应该被误杀。
     */
    public static void filter(String textFileName, ArrayList<String> stopWordList, String outputFileName) throws IOException {
        BufferedReader br = MyTool.getReader("src/stop/data/" +
                "" +
                "" + textFileName);
        BufferedWriter bw = MyTool.getWriter("src/stop/data/" +
                "" +
                "" + outputFileName);
        HashSet<String> stopWordsHash = new HashSet<>(stopWordList);
        String srcLine;
        StringBuilder tarLine = new StringBuilder();

        // 拆行 滤掉"\n"
        while ((srcLine = br.readLine()) != null) {
            // 考虑到效率问题 不用replace()函数
            // 分解成词 注意保留" "
            int i = 0;
            StringBuilder wordBuffer = new StringBuilder();
            for (; i < srcLine.length(); ++i) {
                char ch = srcLine.charAt(i);
                if (ch == ' ') { // 空格即为单词界限 判定单词读入完毕 进行停用词判定并写入tarLine
                    String word = wordBuffer.toString();
                    word = stopWordsHash.contains(word) ? "**" : word; // replace
                    tarLine.append(word);
                    tarLine.append(ch);
                    wordBuffer.setLength(0); // clear
                } else {
                    wordBuffer.append(ch);
                }
            }
            bw.write(tarLine + "\n");
            tarLine.setLength(0);
        }

        br.close();
        bw.close();
    }
}
