package translate;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Stack;

public class Translate {
    private final Stack<Character> operatorStack;
    private final Stack<String> numStack;
    private int tNo;

    public Translate() {
        this.operatorStack = new Stack<>();
        this.numStack = new Stack<>();
        this.tNo = 0;
    }

    public static void main(String[] args) throws IOException {
        BufferedReader bf = new BufferedReader(new FileReader("src/translate/data/data.txt", StandardCharsets.UTF_8));
        String line;
        Translate translate = new Translate();

        while ((line = bf.readLine()) != null) {
            line = line.trim();

            // 分割成单个赋值表达式
            StringBuilder sb = new StringBuilder();
            for (char ch : line.toCharArray()) {
                if (ch == ' ') {
                    continue;
                }
                if (ch == ';') { // 遇到';' 表示式子完毕 可以开始运算
                    String[] out = sb.toString().split("=");
                    if (out.length != 2) {
                        System.out.println("invalid expression");
                        System.exit(1);
                    }
                    String left = out[0].trim();
                    String right = out[1].trim();
                    translate.startTranslate(left, right);

                    sb.setLength(0);
                    continue;
                }
                sb.append(ch);
            }
        }
    }

    public void startTranslate(String left, String right) {
        operatorStack.clear();
        numStack.clear();

        for (char head : right.toCharArray()) {
            if (isNum(head)) {
                numStack.push(String.valueOf(head));
            } else if (operatorStack.isEmpty() || head == '(') {
                // 空或者左括号直接push
                operatorStack.push(head);
            } else if (head == ')') {
                // 遇到右括号 开始往回运算
                while (operatorStack.peek() != '(') {
                    doOperation();
                }
                operatorStack.pop(); // pop '('
            } else { // 操作符入栈 根据优先级判断是否需要运算
                while (!operatorStack.isEmpty() && isNeedToCalculate(head, operatorStack.peek())) {
                    doOperation();
                }
                operatorStack.push(head);
            }
        }

        while (!operatorStack.isEmpty()) {
            doOperation();
        }

        String result = numStack.pop();
        System.out.println(left + "=" + result);
        System.out.println();
    }

    // 这里默认操作数只 a~z
    private boolean isNum(char ch) {
        return ch >= 'a' && ch <= 'z';
    }

    private boolean isOperator(char ch) {
        return ch == '(' || ch == ')' || ch == '+' || ch == '-' || ch == '*' || ch == '/';
    }

    private boolean isNeedToCalculate(char head, Character topChar) {
        return getPriority(head) <= getPriority(topChar);
    }

    private int getPriority(char ch) {
        switch (ch) {
            case '+':
            case '-':
                return 1;
            case '*':
            case '/':
                return 2;
            default:
                return 0;
        }
    }

    private void doOperation() {
        if (!operatorStack.isEmpty()) {
            char operator = operatorStack.pop();

            // 运算操作 本应分情况操作 但都是 tn = a ? b形式 故直接浓缩代码于此
            tNo++;
            String t = "t" + tNo;
            if (numStack.size() < 2) {
                System.out.println("invalid");
                System.exit(1);
            }
            String num2 = numStack.pop();
            String num1 = numStack.pop();
            System.out.println(t + "=" + num1 + operator + num2);
            numStack.push(t);
        }
    }
}
