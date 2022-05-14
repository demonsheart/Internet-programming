package GrammarAnalysis;

import tool.MyTool;

import java.io.BufferedReader;
import java.io.IOException;

public class PredictiveAnalyticMain {
    public static void main(String[] args) throws IOException {
        // 配置项 注意顺序问题
        char startVN = 'E';
        String VN = "EGTHF";
        String VT = "+-*/()i#"; // #代表字符串尾部
        String[][] table = { // 四则运算初始化分析表 table = VN X VT; ? 代表epsilon
                {"", "", "", "", "TG", "", "TG", ""},
                {"+TG", "-TG", "", "", "", "?", "", "?"},
                {"", "", "", "", "FH", "", "FH", ""},
                {"?", "?", "*FH", "/FH", "", "?", "", "?"},
                {"", "", "", "", "(E)", "", "i", ""},
        };

        String path = "src/GrammarAnalysis/data/arithmetic.txt";
        BufferedReader br = MyTool.getReader(path);
        PredictiveAnalytic p = new PredictiveAnalytic(table, VN, VT, startVN);

        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            p.setExpression(line);
            p.initTree();
            p.display();
        }
    }
}
