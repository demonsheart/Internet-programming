package GrammarAnalysis;

// 四则运算文法 硬编码
public class ArithmeticGrammar {
    private char lookAhead; // ? 代表EOF
    private int index;
    private String expression;
    private NaryTreeNode<String> root;

    public ArithmeticGrammar(String expression) {
        this.expression = expression;
        this.index = 0;
        this.lookAhead = index < expression.length() ? expression.charAt(index) : '?';
        this.root = new NaryTreeNode<>("E");
    }

    public void initTree() {
        E(root);
    }

    // 先序遍历形成的语法树字符串 加括号 这里要用递归
    public String preOrder() {
        StringBuilder sb = new StringBuilder();
        helper(root, sb);
        return sb.toString();
    }

    // 先序遍历 递归形式
    private void helper(NaryTreeNode<String> node, StringBuilder sb) {
        if (node == null) {
            return;
        }
        // 注意epsilon节点不输出
        if (node.getVal().equals("epsilon")) {
            return;
        }
        sb.append(node.getVal());
        int cSize = node.getChildren().size();
        if (cSize != 0 && !node.getChildren().get(0).getVal().equals("epsilon")) {
            sb.append('(');
        }
        for (NaryTreeNode<String> str : node.getChildren()) {
            helper(str, sb);
        }
        if (cSize != 0 && !node.getChildren().get(cSize - 1).getVal().equals("epsilon")) {
            sb.append(')');
        }
    }

    private void advance() {
        index++;
        this.lookAhead = index < expression.length() ? expression.charAt(index) : '?';
    }

    /**
     * E -> TE'
     * first(E) = {(, i}
     * follow(E) = {#, ) }
     * @param node
     */
    private void E(NaryTreeNode<String> node) {
        if (lookAhead == '(' || lookAhead == 'i') { // match first
            NaryTreeNode<String> t = new NaryTreeNode<>("T");
            node.addChildNode(t);
            T(t);

            NaryTreeNode<String> e_p = new NaryTreeNode<>("E'");
            node.addChildNode(e_p);
            E_prime(e_p);
        }
    }

    /**
     * E' -> ATE'|epsilon
     * first(E') = {epsilon, +, -}
     * follow(E') = {#, ) }
     * @param node
     */
    private void E_prime(NaryTreeNode<String> node) {
        if (lookAhead == '+' || lookAhead == '-') { // match first
            NaryTreeNode<String> a = new NaryTreeNode<>("A");
            node.addChildNode(a);
            A(a);

            NaryTreeNode<String> t = new NaryTreeNode<>("T");
            node.addChildNode(t);
            T(t);

            NaryTreeNode<String> e_p = new NaryTreeNode<>("E'");
            node.addChildNode(e_p);
            E_prime(e_p);
        }

        if (lookAhead == ')' || lookAhead == '?') { // match follow
            // E' -> epsilon
            NaryTreeNode<String> epsilon = new NaryTreeNode<>("epsilon");
            node.addChildNode(epsilon);
        }
    }

    /**
     * T -> FT'
     * first(T) = {(, i}
     * follow(T) = {+, -, #, )}
     * @param node
     */
    private void T(NaryTreeNode<String> node) {
        if (lookAhead == '(' || lookAhead == 'i') {
            NaryTreeNode<String> f = new NaryTreeNode<>("F");
            node.addChildNode(f);
            F(f);

            NaryTreeNode<String> t_p = new NaryTreeNode<>("T'");
            node.addChildNode(t_p);
            T_prime(t_p);
        }
    }

    /**
     * T' -> MFT'|epsilon
     * first(T') = {epsilon, *, /}
     * follow(T') = {+, -, #, )}
     * @param node
     */
    private void T_prime(NaryTreeNode<String> node) {
        if (lookAhead == '*' || lookAhead == '/') {
            NaryTreeNode<String> m = new NaryTreeNode<>("M");
            node.addChildNode(m);
            M(m);

            NaryTreeNode<String> f = new NaryTreeNode<>("F");
            node.addChildNode(f);
            F(f);

            NaryTreeNode<String> t_p = new NaryTreeNode<>("T'");
            node.addChildNode(t_p);
            T_prime(t_p);
        }

        if (lookAhead == '+' || lookAhead == '-' || lookAhead == '?' || lookAhead == ')') {
            // T' -> epsilon
            NaryTreeNode<String> epsilon = new NaryTreeNode<>("epsilon");
            node.addChildNode(epsilon);
        }
    }

    /**
     * F -> (E)|i
     * first(F) = {(, i}
     * follow(F) = {+, -, *, /, #}
     * @param node
     */
    private void F(NaryTreeNode<String> node) {
        if (lookAhead == '(') {
            // F -> (E)
            NaryTreeNode<String> l = new NaryTreeNode<>("(");
            node.addChildNode(l);

            NaryTreeNode<String> e = new NaryTreeNode<>("E");
            node.addChildNode(e);
            E(e);

            NaryTreeNode<String> r = new NaryTreeNode<>(")");
            node.addChildNode(r);
        }
        if (lookAhead == 'i') {
            // F -> i
            NaryTreeNode<String> i = new NaryTreeNode<>("i");
            node.addChildNode(i);
            advance();
        }
    }

    /**
     * A -> +|-
     * first(A) = {+, -}
     * follow(A) = {(, i}
     * @param node
     */
    private void A(NaryTreeNode<String> node) {
        if (lookAhead == '+' || lookAhead == '-') {
            NaryTreeNode<String> a = new NaryTreeNode<>(String.valueOf(lookAhead));
            node.addChildNode(a);
            advance();
        }
    }

    /**
     * M -> *|/
     * first(A) = {*, /}
     * follow(A) = {(, i}
     * @param node
     */
    private void M(NaryTreeNode<String> node) {
        if (lookAhead == '*' || lookAhead == '/') {
            NaryTreeNode<String> m = new NaryTreeNode<>(String.valueOf(lookAhead));
            node.addChildNode(m);
            advance();
        }
    }
}
