package REToNFA;

import java.util.Scanner;
import java.util.Stack;

public class RegularExpression {

    private Stack<NFA> nfaStack;
    private Stack<Character> operatorStack;

    public RegularExpression() {
        nfaStack = new Stack<>();
        operatorStack = new Stack<>();
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter a regex:");


        String line = scanner.nextLine();
        RegularExpression re = new RegularExpression();
        NFA nfa = re.generateNFA(line);
        nfa.print();

        System.out.println("Enter a string to recognize(':q' to quit):");
        while (scanner.hasNextLine()) {
            System.out.println("Enter a string to recognize(':q' to quit):");

            line = scanner.nextLine();
            if (line.equals(":q")) { break; }
            System.out.println(nfa.scan(line) ? "Yes" : "No");
        }
    }

    public NFA generateNFA(String str) {
        if (!isAllRegexChar(str)) {
            return null;
        }
        nfaStack.clear();
        operatorStack.clear();

        // 补充'.'运算符
        str = addConcatOperator(str);

        for (char head : str.toCharArray()) {
            if (isAlphabet(head)) { // 字母表字符 后面的else if都是操作符
                NFA nfa = new NFA(head);
                nfaStack.push(nfa);
            } else if (operatorStack.isEmpty()) { // 空直接push
                operatorStack.push(head);
            } else if (head == '(') { // 左括号直接push
                operatorStack.push(head);
            } else if (head == ')') { // 遇到右括号 开始往回运算
                // 此时在栈中'('到栈顶部分 可直接运算
                while (operatorStack.peek() != '(') {
                    doOperation();
                }
                operatorStack.pop();
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

        NFA result = nfaStack.pop();

        return result;
    }

    private void doOperation() {
        if (!operatorStack.isEmpty()) {
            char operator = operatorStack.pop();

            switch (operator) {
                case ('|'):
                    union();
                    break;

                case ('.'):
                    concat();
                    break;

                case ('*'):
                    star();
                    break;

                default:
                    System.out.println("Unknown Symbol !");
                    System.exit(1);
                    break;
            }
        }
    }

    private String addConcatOperator(String regular) {
        String newRegular = new String("");
        for (int i = 0; i < regular.length() - 1; i++) {
            if (isAlphabet(regular.charAt(i)) && isAlphabet(regular.charAt(i + 1))) {
                newRegular += regular.charAt(i) + ".";

            } else if (isAlphabet(regular.charAt(i)) && regular.charAt(i + 1) == '(') {
                newRegular += regular.charAt(i) + ".";

            } else if (regular.charAt(i) == ')' && isAlphabet(regular.charAt(i + 1))) {
                newRegular += regular.charAt(i) + ".";

            } else if (regular.charAt(i) == '*' && isAlphabet(regular.charAt(i + 1))) {
                newRegular += regular.charAt(i) + ".";

            } else if (regular.charAt(i) == '*' && regular.charAt(i + 1) == '(') {
                newRegular += regular.charAt(i) + ".";

            } else if (regular.charAt(i) == ')' && regular.charAt(i + 1) == '(') {
                newRegular += regular.charAt(i) + ".";

            } else {
                newRegular += regular.charAt(i);
            }
        }
        newRegular += regular.charAt(regular.length() - 1);
        return newRegular;
    }

    private void union() {
        NFA nfa2 = nfaStack.pop();
        NFA nfa1 = nfaStack.pop();
        NFA result = nfa1.union(nfa2);
        nfaStack.push(result);
    }

    private void concat() {
        NFA nfa2 = nfaStack.pop();
        NFA nfa1 = nfaStack.pop();
        NFA result = nfa1.concat(nfa2);
        nfaStack.push(result);
    }

    private void star() {
        NFA nfa = nfaStack.pop();
        NFA result = nfa.star();
        nfaStack.push(result);
    }

    private boolean isNeedToCalculate(char head, Character topChar) {
        // * > · > |
        if (head == topChar) {
            return true;
        }
        if (head == '*') {
            return false;
        }
        if (topChar == '*') {
            return true;
        }
        if (head == '.') {
            return false;
        }
        if (topChar == '.') {
            return true;
        }
        return head != '|';
    }

    private boolean isAlpha(char ch) {
        return ch >= 'a' && ch <= 'z';
    }

    private boolean isAlphabet(char ch) {
        return isAlpha(ch) || ch == 'E';
    }

    private boolean isOperator(char ch) {
        return ch == '(' || ch == ')' || ch == '|' || ch == '*';
    }

    private boolean isRegexChar(char ch) {
        return isAlphabet(ch) || isOperator(ch);
    }

    private boolean isAllRegexChar(String str) {
        if (str.length() == 0) {
            return false;
        }
        for (char ch : str.toCharArray()) {
            if (!isRegexChar(ch)) {
                return false;
            }
        }
        return true;
    }
}
