package GrammarAnalysis;

import tool.MyTool;

import java.io.BufferedReader;
import java.io.IOException;

public class ArithmeticGrammarMain {
    public static void main(String[] args) throws IOException {
        String path = "src/GrammarAnalysis/data/arithmetic.txt";
        BufferedReader br = MyTool.getReader(path);

        String line;
        ArithmeticGrammar arithmeticGrammar = new ArithmeticGrammar();
        while ((line = br.readLine()) != null) {
            line = line.trim();
            arithmeticGrammar.setExpression(line);
            arithmeticGrammar.initTree();
            System.out.println(line + "'s tree:\n" + arithmeticGrammar.preOrder() + "\n");
        }
    }
}
