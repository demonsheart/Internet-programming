package GrammarDecision;

import tool.MyTool;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;

public class Grammar {
    public char startVn;
    public int type;
    public ArrayList<Production> productions = new ArrayList<>();
    public static final Map<Integer, String> convertMap = Map.of(
            0, "PSG",
            1, "CSG",
            2, "CFG",
            3, "RG"
    );

    public void initGrammarType() {
        // 特殊情况 S -> epsilon 且S在某产生式右侧
        boolean SInRight = false, hasSTE = false;
        for (Production production : productions) {
            if (production.right.contains(String.valueOf(startVn))) {
                SInRight = true;
            }
            if (production.type == 6) {
                hasSTE = true;
            }
        }
        if (SInRight && hasSTE) { type = 0; }

        int grammarType = 5;
        for (Production production : productions) {
            int productionType = production.type;
            // LRG && RRG == CFG
            if (grammarType * productionType == 12) { grammarType = 2; }
            // 取小值
            if (grammarType > productionType) { grammarType = productionType; }
        }
        type = Math.min(grammarType, 3);
    }

    public void display() {
        System.out.println("G[" + startVn + "] is " + convertMap.get(type));
        for (Production production : productions) {
            production.display();
        }
        System.out.println();
    }

    public static ArrayList<Grammar> loadFile(String path) throws IOException {
        BufferedReader br = MyTool.getReader(path);
        ArrayList<Grammar> grammars = new ArrayList<>();

        String line;
        Grammar grammar = null;
        int lineCount = 0;
        while ((line = br.readLine()) != null) {
            lineCount++;
            line = line.trim();

            // 终止当前grammar读入
            if (line.contains("end") && grammar != null) {
                grammar.initGrammarType();
                grammars.add(grammar);
                grammar = null;
            }

            // startVn初始化
            if (line.startsWith("G")) {
                grammar = new Grammar();
                int l = line.indexOf('['), r = line.indexOf(']');
                if (l == -1 || r == -1 || r < l+1) {
                    System.out.println("Get startVn error in line " + lineCount);
                    break;
                }
                String s = line.substring(l + 1, r).trim();
                if (s.length() != 1) {
                    System.out.println("startVn must be single char in line " + lineCount);
                    break;
                }
                grammar.startVn = s.charAt(0);
            } else if (line.length() > 0) { // production初始化
                if (grammar != null)
                    grammar.productions.add(new Production(line, grammar.startVn));
            }
        }

        return grammars;
    }
}
