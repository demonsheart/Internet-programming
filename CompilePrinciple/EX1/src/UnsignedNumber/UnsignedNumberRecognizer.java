package UnsignedNumber;

import tool.MyTool;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;

public class UnsignedNumberRecognizer {

    enum NumberType {
        DiGiTAL,
        ALPHABET
    }

    private final BufferedReader reader;
    private final HashMap<Map.Entry<Integer, Integer>, Integer> convertTable = new HashMap<>(); // 状态转移函数
    private final NumberType numberType;
    private final HashMap<Character, Character> numberMap = new HashMap<>();

    public UnsignedNumberRecognizer(String targetFileName, NumberType numberType) throws IOException {
        reader = MyTool.getReader("src/UnsignedNumber/data/" + targetFileName);
        this.numberType = numberType;
        initConvertTable();

        if (numberType == NumberType.ALPHABET) {
            initNumberMap();
        }
    }

    public void startAnalyze() throws IOException {
        String line;

        while ((line = reader.readLine()) != null) {
            line = line.trim();

            // 初始化读指针和初始状态
            int index = 0, curState = 0;
            StringBuilder number = new StringBuilder();
            StringBuilder str = new StringBuilder();
            for (; index < line.length(); index++) {
                char ch = line.charAt(index);

                // 状态转移
                int edgeType;
                if (numberType == NumberType.ALPHABET) {
                    edgeType = getEdgeTypeForALPHABET(ch);
                } else {
                    edgeType = getEdgeTypeForDiGiTAL(ch);
                }
                int preState = curState;
                curState = convertTable.get(Map.entry(curState, edgeType));

                if (curState == -1) {
                    if (number.length() == 0) { // 此前没有读入过数字部分 即 0 -> err
                        if (ch != ' ') str.append(ch); // 持续拼接(空格不拼接) 终止判断在else里
                    } else { // 从数字状态到达err 则异常结束
                        number.append(ch);
                        print("异常", number.toString());
                        number.setLength(0);
                        str.setLength(0);
                    }
                    curState = 0;
                } else if (curState == 7) { // 终止状态
                    print("数字", number.toString());
                    index--;
                    curState = 0;
                    number.setLength(0);
                    str.setLength(0);
                } else {
                    number.append(ch);
                    // 如果此前str有值 0 -> 1 或者 0 -> 3 将触发str的终止判断
                    boolean condition1 = preState == 0 && curState == 1;
                    boolean condition2 = preState == 0 && curState == 3;
                    if (str.length() != 0 && (condition1 || condition2)) {
                        print("其他", str.toString());
                        str.setLength(0);
                    }
                }
            }

            // 如果读完一行发现状态停留在非终止态 需要额外判断
            if (str.length() != 0) {
                print("其他", str.toString());
            }

            if (number.length() != 0) {
                if (curState == 1 || curState == 2 || curState == 6) {
                    print("数字", number.toString());
                } else {
                    print("异常", number.toString());
                }
            }
        }
    }

    /*
    A~J -> d -> 0
    K -> . -> 1
    L -> E/e -> 2
    M/N -> +/- -> 3
    other -> -1
     */
    private int getEdgeTypeForALPHABET(char ch) {
        if (ch >= 'A' && ch <= 'J') {
            return 0;
        } else if (ch == 'K') {
            return 1;
        } else if (ch == 'L') {
            return 2;
        } else if (ch == 'M' || ch == 'N') {
            return 3;
        } else {
            return -1;
        }
    }

    /*
    d -> 0
    . -> 1
    E/e -> 2
    +/- -> 3
    other -> -1
     */
    private int getEdgeTypeForDiGiTAL(char ch) {
        if (ch >= '0' && ch <= '9') {
            return 0;
        } else if (ch == '.') {
            return 1;
        } else if (ch == 'E' || ch == 'e') {
            return 2;
        } else if (ch == '+' || ch == '-') {
            return 3;
        } else {
            return -1;
        }
    }

    private void print(String type, String str) {
        if (numberType == NumberType.ALPHABET) { // ALPHABET模式下不输出异常和其他情况 并且需要解析成数字
            if (type.equals("数字")) {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < str.length(); i++) {
                    char ch = str.charAt(i);
                    if (numberMap.get(ch) != null) {
                        sb.append(numberMap.get(ch));
                    } else {
                        sb.append(ch);
                    }
                }
                System.out.println("(" + type + ", " + sb.toString() + ")");
            }
        } else {
            System.out.println("(" + type + ", "+ str + ")");
        }
    }

    private void initNumberMap() {
        numberMap.put('A', '0');
        numberMap.put('B', '1');
        numberMap.put('C', '2');
        numberMap.put('D', '3');
        numberMap.put('E', '4');
        numberMap.put('F', '5');
        numberMap.put('G', '6');
        numberMap.put('H', '7');
        numberMap.put('I', '8');
        numberMap.put('J', '9');
        numberMap.put('K', '.');
        numberMap.put('L', 'E');
        numberMap.put('M', '+');
        numberMap.put('N', '-');
    }

    // 初始化状态转移函数
    private void initConvertTable() {
        convertTable.put(Map.entry(0, 0), 1);
        convertTable.put(Map.entry(0, 1), 3);
        convertTable.put(Map.entry(0, -1), -1);
        convertTable.put(Map.entry(0, 2), -1);
        convertTable.put(Map.entry(0, 3), -1);

        convertTable.put(Map.entry(1, 0), 1);
        convertTable.put(Map.entry(1, 1), 2);
        convertTable.put(Map.entry(1, 2), 4);
        convertTable.put(Map.entry(1, -1), 7);
        convertTable.put(Map.entry(1, 3), 7);

        convertTable.put(Map.entry(2, 0), 2);
        convertTable.put(Map.entry(2, 2), 4);
        convertTable.put(Map.entry(2, -1), 7);
        convertTable.put(Map.entry(2, 1), 7);
        convertTable.put(Map.entry(2, 3), 7);

        convertTable.put(Map.entry(3, 0), 2);
        convertTable.put(Map.entry(3, -1), -1);
        convertTable.put(Map.entry(3, 1), -1);
        convertTable.put(Map.entry(3, 2), -1);
        convertTable.put(Map.entry(3, 3), -1);

        convertTable.put(Map.entry(4, 0), 6);
        convertTable.put(Map.entry(4, 3), 5);
        convertTable.put(Map.entry(4, -1), -1);
        convertTable.put(Map.entry(4, 1), -1);
        convertTable.put(Map.entry(4, 2), -1);

        convertTable.put(Map.entry(5, 0), 6);
        convertTable.put(Map.entry(5, -1), -1);
        convertTable.put(Map.entry(5, 1), -1);
        convertTable.put(Map.entry(5, 2), -1);
        convertTable.put(Map.entry(5, 3), -1);


        convertTable.put(Map.entry(6, 0), 6);
        convertTable.put(Map.entry(6, -1), 7);
        convertTable.put(Map.entry(6, 1), 7);
        convertTable.put(Map.entry(6, 2), 7);
        convertTable.put(Map.entry(6, 3), 7);
    }
}
