package GrammarAnalysis;

import java.util.HashMap;
import java.util.Map;
import java.util.Stack;

public class PredictiveAnalytic {
    private String[][] table;
    private String VN;
    private String VT; // #代表字符串尾部
    private char startVN;
    private HashMap<Map.Entry<Character, Character>, String> hashMapTable; // VN X VT ; ? 代表epsilon

    private Stack<Character> stack;
    private char lookAhead; // # 代表EOF
    private int index;
    private NaryTreeNode<Character> root;
    private String expression;

    private boolean success;

    public PredictiveAnalytic(String[][] table, String VN, String VT, char startVN) {
        this.table = table;
        this.VN = VN;
        this.VT = VT;
        this.startVN = startVN;
        this.expression = "";
        this.stack = new Stack<>();
        // init hashMapTable
        hashMapTable = new HashMap<>();
        for (int i = 0; i < VN.length(); i++) {
            for (int j = 0; j < VT.length(); j++) {
                if (table[i][j].length() == 0) { continue; }
                hashMapTable.put(Map.entry(VN.charAt(i), VT.charAt(j)), table[i][j]);
            }
        }
        // printHashTable
//        hashMapTable.forEach((k,v) -> System.out.println(k + " : " + v));
        this.reset();
    }

    public void setExpression(String expression) {
        StringBuilder sb = new StringBuilder(expression + "#"); // 补尾部字符串
        this.expression = sb.toString();
        this.reset();
    }

    private void reset() {
        this.success = true;
        this.index = 0;
        this.lookAhead = index < expression.length() ? expression.charAt(index) : '#';
        this.root = new NaryTreeNode<>(startVN);
        this.stack.clear();
    }

    private boolean isVT(char ch) {
        return VT.contains(String.valueOf(ch));
    }

    private void advance() {
        index++;
        this.lookAhead = index < expression.length() ? expression.charAt(index) : '#';
    }

    public void initTree() {
        stack.push('#');
        stack.push(startVN);

        char top = stack.peek();
        while (top != '#') {
            if (top == lookAhead) {
                stack.pop();
                advance();
            } else if (isVT(top)) { // 两个终结符不匹配 则整个字符串不符合文法
                success = false;
                break;
            } else {
                // 栈顶非终结符 查表判断
                String re;
                if ((re = hashMapTable.get(Map.entry(top,lookAhead))) != null) {
                    // 产生式 top -> re
                    insertTree(top, re);
                    stack.pop();
                    if (!re.equals("?")) {
                        // 逆向入栈
                        char[] chars = re.toCharArray();
                        for (int i = chars.length - 1; i >= 0; i--) {
                            stack.push(chars[i]);
                        }
                    }
                } else { // null值 匹配失败
                    success = false;
                    break;
                }
            }
            top = stack.peek();
        }
    }

    private void insertTree(char target, String children) {
        // 先找到目标节点(深度优先) 再插入子节点
        // 定位到相应的叶子处 此处一定存在
        Stack<NaryTreeNode<Character>> stack = new Stack<>();
        stack.add(root);
        while (!stack.isEmpty()) {
            NaryTreeNode<Character> node = stack.pop();

            if (node.isLeaf() && node.getVal() == target) {
                for (char ch : children.toCharArray()) {
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
    }

    private String preOrder() {
        StringBuilder sb = new StringBuilder();
        helper(root, sb);
        return sb.toString();
    }

    private void helper(NaryTreeNode<Character> node, StringBuilder sb) {
        if (node == null) {
            return;
        }
        // epsilon节点不输出
        if (node.getVal() == '?') {
            return;
        }
        sb.append(node.getVal());
        int cSize = node.getChildren().size();
        if (cSize != 0 && node.getChildren().get(0).getVal() != '?') {
            sb.append('(');
        }
        for (NaryTreeNode<Character> ch : node.getChildren()) {
            helper(ch, sb);
        }
        if (cSize != 0 && node.getChildren().get(cSize - 1).getVal() != '?') {
            sb.append(')');
        }
    }

    public void display() {
        if (success) {
            System.out.println(expression + "'s tree:\n" + preOrder() + "\n");
        } else {
            System.out.println(expression + " does not match.");
        }
    }
}
