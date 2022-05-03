package REToNFA;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;

public class StringRecognizer {

    public HashMap<NFA, String> nfaTypeMap = new HashMap<>(); // nfa -> type 映射集
    public ArrayList<String> strings = new ArrayList<>(); //strings

    public static void main(String[] args) throws IOException {
        StringRecognizer sr = new StringRecognizer();
        sr.loadFiles("src/REToNFA/data/types.txt", "src/REToNFA/data/strings.txt");
        sr.startRecognizer();
    }

    public void loadFiles(String reFilePath, String strFilePath) throws IOException {
       BufferedReader reReader = new BufferedReader(new FileReader(reFilePath, StandardCharsets.UTF_8));
       BufferedReader strReader = new BufferedReader(new FileReader(strFilePath, StandardCharsets.UTF_8));

       String line;
        while ((line = reReader.readLine()) != null) {
            line = line.trim();
            if (line.length() == 0) { continue; }
            String[] s = line.split("\\s+");
            RegularExpression re = new RegularExpression();
            NFA nfa = re.generateNFA(s[0]);
            nfaTypeMap.put(nfa, s[1]);
        }
        reReader.close();

        while ((line = strReader.readLine()) != null) {
            line = line.trim();
            if (line.length() == 0) { continue; }
            strings.add(line);
        }
    }

    public void startRecognizer() {
        for (String str : strings) {
            boolean canRecognizer = false;
            for (NFA nfa : nfaTypeMap.keySet()) {
                if (nfa.scan(str)) {
                    canRecognizer = true;
                    System.out.println(str + ", " + nfaTypeMap.get(nfa));
                }
            }
            if(!canRecognizer) {
                System.out.println(str + "不能被所有类识别");
            }
        }
    }
}
