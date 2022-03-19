package divide;

import java.io.IOException;

public class DivideMain {
    public static void main(String[] args) {
        try {
            Analyzer analyzer = new Analyzer("a.txt", "b.txt");
//            Analyzer analyzer = new Analyzer("test.txt", "testre.txt");
            analyzer.startAnalyze();
        } catch (IOException e) {
            System.out.println("Could not load files");
        }
    }
}
