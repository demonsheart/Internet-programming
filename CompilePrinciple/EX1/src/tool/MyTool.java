package tool;

import java.io.*;
import java.nio.charset.StandardCharsets;

public class MyTool {
    // 生成一定范围内随机数 [min, max]
    public static int randomInt(int min, int max) {
        return min + (int) (Math.random() * (max - min + 1));
    }

    // 根据path生成writer
    public static BufferedWriter getWriter(String path) throws IOException {
        return new BufferedWriter(new FileWriter(path, StandardCharsets.UTF_8));
    }

    // 根据path生成reader
    public static BufferedReader getReader(String path) throws IOException {
        return new BufferedReader(new FileReader(path, StandardCharsets.UTF_8));
    }
}
