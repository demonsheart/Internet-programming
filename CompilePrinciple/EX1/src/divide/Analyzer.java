package divide;

import java.io.*;
import java.util.*;

import tool.MyTool;

public class Analyzer {
    private final HashSet<String> keywords = new HashSet<>(Arrays.asList("include", "define", "pragma", "using",
            "namespace", "if", "else", "bool", "int", "char", "for", "while", "return"));
    private final HashMap<String, String> hash = new HashMap<>();
    private final RandomAccessFile reader;
    private final BufferedWriter writer;
    private int tupleCountInLine = 0;

    public Analyzer(String targetFileName, String outputFileName) throws IOException {
        reader = new RandomAccessFile("src/divide/data/" + targetFileName, "r");
        writer = MyTool.getWriter("src/divide/data/" + outputFileName);

        // init hashmap
        initHashTable();
    }

    public void startAnalyze() throws IOException {
        int c;
        int pair;
        StringBuilder sb = new StringBuilder();
        String str;
        int count = 0;

        while ((c = reader.read()) != -1) {
            char ch = (char) c;
            switch (ch) {
                case ' ':
                case '\n':
                case '\r':
                    break;
                case '#':
                    output("关键字", ch);
                    str = getIdentifierOrKeyword();
                    if (str.length() > 0) {
                        output(isKeyword(str) ? "关键字" : "标识符", str);
                    }
                    break;
                case '[':
                case ']':
                case '^':
                case '?':
                case '%':
                case '!':
                case '*':
                case '(':
                case ')':
                    str = String.valueOf(ch);
                    output(hash.get(str), str);
                    break;
                case '"':
                    str = getString();
                    output("字符串常量", str);
                    break;
                case '\'':
                    str = getChar();
                    output("字符型常量", str);
                    break;
                case '+':
                case '-':
                case '&':
                case '|':
                case '<':
                case '>':
                case '=':
                    pair = reader.read();
                    if (pair == ch) {
                        sb.append(ch);
                        sb.append(ch);
                        str = String.valueOf(sb);
                        sb.setLength(0);
                        output(hash.get(str), str);
                    } else {
                        str = String.valueOf(ch);
                        output(hash.get(str), str);
                    }
                    break;

                case ',':
                case '{':
                case ':':
                case '}':
                case '.':
                case ';':
                    output("分隔符", ch);
                    break;

                case '/':
                    if ((c = reader.read()) == -1) {
                        break;
                    }
                    ch = (char) c;
                    if (ch == '/') { // 单行注释
                        while ((c = reader.read()) != -1 && c != '\n') {
                        }
                    } else if (ch == '*') { // 多行注释
                        count = 1;
                        while ((c = reader.read()) != -1 && count > 0) {
                            ch = (char) c;
                            if (ch == '/') {
                                if ((c = reader.read()) == -1) {
                                    break;
                                }
                                ch = (char) c;
                                if (ch == '*') ++count;
                            } else if (ch == '*') {
                                if ((c = reader.read()) == -1) {
                                    break;
                                }
                                ch = (char) c;
                                if (ch == '/') --count;
                            }
                        }
                        if (count > 0) {
                            System.out.println("Error: /* doesn't match up");
                            System.exit(1);
                        }
                    } else {
                        rollbackOneChar();
                        output("运算符", '/');
                    }
                    break;

                default:
                    if (isAlpha(ch)) {                        // identifier or keywords
                        str = getIdentifierOrKeyword(ch);
                        if (isKeyword(str))
                            output("关键字", str);
                        else
                            output("标识符", str);
                    } else if (isDigital(ch)) {
                        str = getNumber(ch);
                        output("数字", str);
                    } else {
                    }
                    break;
            }
        }

        reader.close();
        writer.close();
        System.out.println("Analyze finished, please see output file.");
    }

    private Boolean isAlpha(int c) {
        return (c <= 'Z' && c >= 'A') || (c <= 'z' && c >= 'a') || (c == '_');
    }

    private Boolean isDigital(int c) {
        return (c <= '9' && c >= '0');
    }

    private Boolean isAlphaOrDigital(int c) {
        return isAlpha(c) || isDigital(c);
    }

    private Boolean isKeyword(String str) {
        return keywords.contains(str);
    }

    private void rollbackOneChar() throws IOException {
        reader.seek(reader.getFilePointer() - 1);
    }

    private String getIdentifierOrKeyword(char firstChar) throws IOException { // include firstChar
        String sb = firstChar + getIdentifierOrKeyword();
        return sb;
    }

    private String getIdentifierOrKeyword() throws IOException {
        StringBuilder sb = new StringBuilder();
        int c;
        while ((c = reader.read()) != -1 && (isAlphaOrDigital(c) || c == '-')) {
            sb.append((char) c);
        }
        rollbackOneChar();
        return String.valueOf(sb);
    }

    private String getNumber(char firstDigital) throws IOException {
        StringBuilder sb = new StringBuilder();
        sb.append(firstDigital);
        int c;
        while ((c = reader.read()) != -1 && isDigital(c)) {
            sb.append((char) c);
        }
        rollbackOneChar();
        return String.valueOf(sb);
    }

    private String getString() throws IOException {
        StringBuilder sb = new StringBuilder();
        int c;
        while ((c = reader.read()) != -1 && c != '"') {
            sb.append((char) c);
            if (c == '\\' && (c = reader.read()) != -1) {
                sb.append((char) c);
            }
        }

        if (c == -1) {
            System.out.println("Error: \" doesn't match up");
            System.exit(1);
        }
        return String.valueOf(sb);
    }

    private String getChar() throws IOException {
        StringBuilder sb = new StringBuilder();
        int c;
        while ((c = reader.read()) != -1 && c != '\'') {
            sb.append((char) c);
            if (c == '\\' && (c = reader.read()) != -1) {
                sb.append((char) c);
            }
        }

        if (c == -1) {
            System.out.println("Error: \" doesn't match up");
            System.exit(1);
        }
        return String.valueOf(sb);
    }

    private void output(String type, char value) throws IOException {
        if (++tupleCountInLine % 5 == 0) {
            writer.write('\n');
        }

        writer.write("(" + type + ", " + value + ") ");
    }

    private void output(String type, String value) throws IOException {
        if (++tupleCountInLine % 5 == 0) {
            writer.write('\n');
        }
        type = type == null ? "运算符" : type;
        writer.write("(" + type + ", " + value + ") ");
    }

    private void initHashTable() {
        hash.put("+", "加法运算符");
        hash.put("-", "减法运算符");
        hash.put("*", "乘法运算符");
        hash.put("/", "除法运算符");
        hash.put("%", "取膜运算符");
        hash.put("&", "与运算符");
        hash.put("|", "或运算符");
        hash.put("!", "非运算符");
        hash.put("^", "异或运算符");
        hash.put("<", "小于运算符");
        hash.put(">", "大于运算符");
        hash.put("=", "赋值运算符");
        hash.put("++", "自增运算符");
        hash.put("--", "自减运算符");
        hash.put("&&", "and运算符");
        hash.put("||", "or运算符");
        hash.put("<<", "左移运算符");
        hash.put(">>", "右移运算符");
        hash.put("==", "赋值运算符");
        hash.put("[", "下标运算符");
        hash.put("]", "下标运算符");
        hash.put("(", "函数运算符");
        hash.put(")", "函数运算符");
    }
}
