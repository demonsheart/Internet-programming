package GrammarDecision;

import GrammarAnalysis.NaryTreeNode;
import tool.MyTool;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;

public class Grammar {
    public char startVn;
    public int type;
    public ArrayList<Production> productions = new ArrayList<>();
    public static final Map<Integer, String> convertMap = Map.of(
            -1, "Invalid",
            0, "PSG",
            1, "CSG",
            2, "CFG",
            3, "RG"
    );

    // 语法树
    private NaryTreeNode<Character> root;

    /**
     * Production.left长度必须为1
     */
    public void createTree() {
        for (Production p : productions) {
            if (p.left.length() != 1) {
                System.out.println("Production.left长度必须为1");
                return;
            }
            char left = p.left.charAt(0);
            if (left == startVn) {
                root = new NaryTreeNode<>(startVn);
                for (char ch : p.right.toCharArray()) {
                    root.addChildNode(new NaryTreeNode<>(ch));
                }
            } else { // 深度优先创建
                // 定位到相应的叶子处 此处假设一定存在
                Stack<NaryTreeNode<Character>> stack = new Stack<>();
                stack.add(root);
                while (!stack.isEmpty()) {
                    NaryTreeNode<Character> node = stack.pop();
                    // 找到相应叶子节点即退出
                    if (node.isLeaf() && node.getVal() == left) {
                        for (char ch : p.right.toCharArray()) {
                            node.addChildNode(new NaryTreeNode<>(ch));
                        }
                        break;
                    }
                    Stack<NaryTreeNode<Character>> reChildren = new Stack<>();
                    reChildren.addAll(node.getChildren());
                    while (!reChildren.isEmpty()) {
                        stack.push(reChildren.pop());
                    }
                }
//                root.initNodeType();
            }
        }
    }

    // 先序遍历形成的语法树字符串 加括号 这里要用递归
    public String preOrder() {
        StringBuilder sb = new StringBuilder();
        helper(root, sb);
        return sb.toString();
    }

    // 先序遍历 递归形式
    private void helper(NaryTreeNode<Character> node, StringBuilder sb) {
        if (node == null) {
            return;
        }
        sb.append(node.getVal());
        if (node.getChildren().size() != 0) {
            sb.append('(');
        }
        for (NaryTreeNode<Character> ch : node.getChildren()) {
            helper(ch, sb);
        }
        if (node.getChildren().size() != 0) {
            sb.append(')');
        }
    }

    // 先序遍历形成的叶子字符串
    public String preOrderLeaves() {
        StringBuilder sb = new StringBuilder();
        List<Character> list = root.preOrderLeaves();
        for (Character ch : list) {
            sb.append(ch);
        }
        return sb.toString();
    }

    public void initGrammarType() {
        // 特殊情况 S -> epsilon 且S在某产生式右侧
        // FIXME: 逻辑上好像不太对
//        boolean SInRight = false, hasSTE = false;
//        for (Production production : productions) {
//            if (production.right.contains(String.valueOf(startVn))) {
//                SInRight = true;
//            }
//            if (production.type == 6) {
//                hasSTE = true;
//            }
//        }
//        if (SInRight && hasSTE) { type = 0; return; }

        int grammarType = 5;
        for (Production production : productions) {
            int productionType = production.type;
            // LRG && RRG == CFG
            if (grammarType * productionType == 12) {
                grammarType = 2;
            }
            // 取小值
            if (grammarType > productionType) {
                grammarType = productionType;
            }
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
                grammars.add(grammar);
                grammar = null;
            }

            // startVn初始化
            if (line.startsWith("G")) {
                grammar = new Grammar();
                int l = line.indexOf('['), r = line.indexOf(']');
                if (l == -1 || r == -1 || r < l + 1) {
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
