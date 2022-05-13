package GrammarAnalysis;

import GrammarDecision.Grammar;

import java.io.IOException;
import java.util.ArrayList;

public class GrammarTreeMain {
    public static void main(String[] args) throws IOException {
        ArrayList<Grammar> grammars = Grammar.loadFile("src/GrammarAnalysis/data/G.txt");
        for (Grammar grammar : grammars) {
            grammar.createTree();
            System.out.println(grammar.preOrder());
            System.out.println(grammar.preOrderLeaves());
        }
    }
}
