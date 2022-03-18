package stop;

import java.io.IOException;
import java.util.ArrayList;

public class StopMain {
    public static void main(String[] args) throws IOException {
        // generate
        Text text = new Text(1000, (float) 0.05, 4, 5);
        text.create();
        text.write("text.txt", "stopWords.txt");

        // load && filter
        ArrayList<String> stopWordList = Text.LoadStopWords("stopWords.txt");
        Text.filter("text.txt", stopWordList, "finalText.txt");
    }
}
