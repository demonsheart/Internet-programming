import java.io.IOException;
import java.io.RandomAccessFile;

public class Tmp {
    public static void main(String[] args) throws IOException {
        int treadSize = 10;
        for (int i = 1; i <= treadSize; ++i) {
            test(treadSize, i);
        }
    }

    public static void test(int threadSize, int currentPart) throws IOException {
        RandomAccessFile fileAccess = new RandomAccessFile("src/tmp.txt", "r");

        long len = fileAccess.length();
        long step = len / threadSize;
        long start = step * (currentPart - 1);
        long end = start + step;

        // 处理"\r\n"情况
        // 指向末尾，获取字符，判断是否\r\n中的\n，是的话末尾位置向下移一位，可以将本行输出
        fileAccess.seek(end);
        char lastChar = (char) fileAccess.read();
        if (lastChar == '\n') {
            end += 1;
        }
        // 指向起始位置
        fileAccess.seek(start);
        if (start > 0) {
            while (fileAccess.read() != '\n') {
                start++;
            }
            start++;
        }

        fileAccess.seek(start);
        while (fileAccess.getFilePointer() < end) {
            System.out.println(fileAccess.readLine());
        }
    }
}
