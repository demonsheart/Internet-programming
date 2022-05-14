package GrammarAnalysis;

import tool.MyTool;

import java.io.BufferedReader;
import java.io.IOException;

public class PredictiveAnalyticMain {
    public static void main(String[] args) throws IOException {
        String[][] table = { // 四则运算初始化分析表
                {"", "", "", "", "TG", "", "TG", ""},
                {"+TG", "-TG", "", "", "", "#", "", "#"},
                {"", "", "", "", "FH", "", "FH", ""},
                {"#", "#", "*FH", "/FH", "", "#", "", "#"},
                {"", "", "", "", "(E)", "", "i", ""},
        };

        String path = "src/GrammarAnalysis/data/arithmetic.txt";
        BufferedReader br = MyTool.getReader(path);

        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            PredictiveAnalytic p = new PredictiveAnalytic(table);

        }
    }
}
