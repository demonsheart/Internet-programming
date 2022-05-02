package REToNFA;

import java.util.*;

// 默认字母表 a-z E代表Epsilon
// 默认初始状态是0 状态集是 [0, final_state] 终止状态只有一个
public class NFA {
    public ArrayList<Integer> states;
    public ArrayList<Transition> transitions;

    // transitions的哈希表
    private HashMap<Map.Entry<Integer, Character>, Integer> transitionsMap;

    // Matrix
    private char[][] Matrix;
    public int final_state;

    public NFA() {
        this.states = new ArrayList<Integer>();
        this.transitions = new ArrayList<Transition>();
        this.final_state = 0;
    }

    public NFA(int size) {
        this.states = new ArrayList<Integer>();
        this.transitions = new ArrayList<Transition>();
        this.final_state = 0;
        this.initStates(size);
    }

    public NFA(char ch) {
        this.states = new ArrayList<Integer>();
        this.transitions = new ArrayList<Transition>();
        this.initStates(2);
        this.final_state = 1;
        this.transitions.add(new Transition(0, 1, ch));
    }

    // 等NFA构造完成 需要识别字符串再调用
    private void initTransitionsMap() {
        transitionsMap = new HashMap<>();
        for (Transition t : transitions) {
            transitionsMap.put(Map.entry(t.from, t.symbol), t.to);
        }
    }

    private void initMatrix() {
        int stateNum = states.size();
        Matrix = new char[stateNum][stateNum];

        for (int i = 0; i < stateNum; i++) {
            for (int j = 0; j < stateNum; j++) {
                Matrix[i][j] = '-'; // 不可达
            }
        }

        for (Transition t : transitions) {
            Matrix[t.from][t.to] = t.symbol;
        }
    }

    public boolean scan(String str) {
        initTransitionsMap();
        initMatrix();
        Set<Integer> currentSet = new HashSet<>();
        currentSet.add(0);
        currentSet = epsClosure(currentSet);

        for (char ch : str.toCharArray()) {
            // 状态转移
            currentSet = transToNextStates(currentSet, ch);
            // 空迁移
            currentSet = epsClosure(currentSet);
        }

        // 最终做判断
        return currentSet.contains(final_state);
    }

    // 读入字符 进行状态转移
    private Set<Integer> transToNextStates(Set<Integer> set, char ch) {
        Set<Integer> result = new HashSet<>();
        for (Integer curState : set) {
            Integer nextState;
            if ((nextState = transitionsMap.get(Map.entry(curState, ch))) != null) {
                result.add(nextState);
            }
        }
        return result;
    }

    // 对集合进行空转移 得到拓展结果集
    private Set<Integer> epsClosure(Set<Integer> set) {
        // 初始化变量
        boolean[] visited = new boolean[states.size()];
        Queue<Integer> queue = new LinkedList<Integer>();
        Set<Integer> result = new HashSet<>();

        for(Integer state : set) { // 对集合中的每个状态进行空迁移 用BFS
            queue.add(state);

            while (!queue.isEmpty()) {
                Integer curState = queue.peek(); // 取队首访问
                queue.poll();
                result.add(curState);
                visited[curState] = true;

                for (int nextState = 0; nextState < states.size(); nextState++) {
                    if(Matrix[curState][nextState] == 'E' && !visited[nextState]) {
                        queue.add(nextState);
                    }
                }
            }
        }

        return result;
    }

    private void initStates(int size) {
        for (int i = 0; i < size; i++)
            this.states.add(i);
    }

    public void print() {
        // 状态由数字转换成大写字母(超过26个状态会异常字符) E->epsilon
        for (Transition t : transitions) {
            char from = (char) (t.from + 'A');
            char to = (char) (t.to + 'A');
            String symbol = t.symbol == 'E' ? "epsilon" : String.valueOf(t.symbol);
            System.out.println("(" + from + ", " + symbol + ") = " + to);
        }
    }

    // Thompson方法中的 *
    public NFA star() {
        int size = this.states.size();
        NFA result = new NFA(size + 2);

        result.transitions.add(new Transition(0, 1));
        for (Transition t : transitions) {
            result.transitions.add(new Transition(t.from + 1, t.to + 1, t.symbol));
        }
        result.transitions.add(new Transition(size, 1));
        result.transitions.add(new Transition(size, size + 1));
        result.transitions.add(new Transition(0, size + 1));
        result.final_state = size + 1;

        return result;
    }

    // Thompson方法中的 ·
    public NFA concat(NFA other) {
        int thisSize = this.states.size();
        int otherSize = other.states.size();

        NFA result = new NFA(thisSize + otherSize - 1);
        for (Transition t : this.transitions) {
            result.transitions.add(new Transition(t.from, t.to, t.symbol));
        }
        for (Transition t : other.transitions) {
            result.transitions.add(new Transition(t.from + thisSize - 1, t.to + thisSize - 1, t.symbol));
        }
        result.final_state = thisSize + otherSize - 2;

        return result;
    }

    // Thompson方法中的 |
    public NFA union(NFA other) {
        int thisSize = this.states.size();
        int otherSize = other.states.size();

        NFA result = new NFA(thisSize + otherSize + 2);
        result.transitions.add(new Transition(0, 1));

        for (Transition t : this.transitions) {
            result.transitions.add(new Transition(t.from + 1, t.to + 1, t.symbol));
        }

        result.transitions.add(new Transition(thisSize, thisSize + otherSize + 1, 'E'));

        result.transitions.add(new Transition(0, thisSize + 1));

        for (Transition t : other.transitions) {
            result.transitions.add(new Transition(t.from + thisSize + 1, t.to + thisSize + 1, t.symbol));
        }
        result.transitions.add(new Transition(otherSize + thisSize, thisSize + otherSize + 1));

        result.final_state = thisSize + otherSize + 1;

        return result;
    }
}
