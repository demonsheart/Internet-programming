package GrammarDecision;

import java.io.IOException;
import java.util.ArrayList;

public class GrammarJudgeMain {
    public static void main(String[] args) throws IOException {
        ArrayList<Grammar> grammars = Grammar.loadFile("src/GrammarDecision/data/G.txt");
        for (Grammar grammar : grammars) {
            grammar.initGrammarType();
            grammar.display();
        }
    }
}
