package REToNFA;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

// 默认字母表 a-z E代表Epsilon
// 默认初始状态是0 状态集是 [0, final_state] 终止状态只有一个
public class NFA {
    public ArrayList<Integer> states;
    public ArrayList<Transition> transitions;

    // transitions的哈希表 用于字符串识别时加速
    public HashMap<Map.Entry<Integer, Character>, Integer> transitionsMap;
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
    public void initTransitionsMap() {
        transitionsMap = new HashMap<>();
        for (Transition t : transitions) {
            transitionsMap.put(Map.entry(t.from, t.symbol), t.to);
        }
    }

    public void initStates(int size) {
        for (int i = 0; i < size; i++)
            this.states.add(i);
    }

    public void print() {
        // TODO print
        for (Transition t : transitions) {
            System.out.println("(" + t.from + ", " + t.symbol +
                    ", " + t.to + ")");
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
        for (Transition t: this.transitions) {
            result.transitions.add(new Transition(t.from, t.to, t.symbol));
        }
        for (Transition t: other.transitions) {
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
