package REToNFA;

public class Transition {
    public int from, to;
    public char symbol;

    public Transition(int from, int to, char symbol) {
        this.from = from;
        this.to = to;
        this.symbol = symbol;
    }

    // 空转移
    public Transition(int from, int to) {
        this.from = from;
        this.to = to;
        this.symbol = 'E';
    }
}