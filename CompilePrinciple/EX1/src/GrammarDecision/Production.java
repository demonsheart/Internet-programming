package GrammarDecision;

import java.util.*;

public class Production {
    public final String left;
    public final String right;
    public final int type;
    private final char startVn;

    public static final Map<Integer, String> convertMap = Map.of(
            0, "PSG",
            1, "CSG",
            2, "CFG",
            3, "LRG",
            4, "RRG",
            5, "LRRG",
            6, "S2E" // S -> epsilon; S to epsilon
    );

    Production(String line, char startVn) {
        this.startVn = startVn;
        line = line.trim(); // trim space
        if (line.endsWith(";")) { // remove ;
            line = line.substring(0, line.length() - 1);
        }

        // split
        String[] strArr = line.split("->");
        if (strArr.length != 2) {
            System.out.println("Error production");
            left = "";
            right = "";
            type = -1;
        } else {
            left = strArr[0].trim();
            right = strArr[1].trim();
            if (isValid(left) && isValid(right)) {
                type = getProductionType();
            } else {
                type = -1;
            }
        }
    }

    private int getProductionType() {
        int Vnl = 0, Vnr = 0;
        int leftLen = left.length(), rightLen = right.length();

        for (int i = 0; i < leftLen; i++) {
            if (isNonTerminator(left.charAt(i))) {
                ++Vnl;
            }
        }

        for (int i = 0; i < rightLen; i++) {
            if (isNonTerminator(right.charAt(i))) {
                ++Vnr;
            }
        }

        if (left.equals(String.valueOf(startVn)) && right.equals("@")) { // S2E
            return 6;
        }

        if (Vnl == 1 && leftLen == 1) {
            if (Vnr == 0) {
                return 5; // LRRG
            } else if (Vnr == 1) {
                if (rightLen == 1) { // LRRG
                    return 5;
                }
                // Vn在最左
                if (isNonTerminator(right.charAt(0))) { // LRG
                    return 3;
                }
                // Vn在最右
                if (isNonTerminator(right.charAt(rightLen - 1))) { // RRG
                    return 4;
                }
                // 其他 CFG
                return 2;
            } else { // Vnr > 1, CFG
                return 2;
            }
        }

        if (Vnl >= 1) { // Vnl >= 1
            // 检查是否有@ epsilon
            boolean hasEpsilon = left.contains("@") || right.contains("@");
            if (rightLen > leftLen && !hasEpsilon) { // CSG
                return 1;
            } else { // PSG
                return 0;
            }
        }

        return 0; // PSG Vnl == 0
    }

    private boolean isNonTerminator(char i) {
        return i >= 'A' && i <= 'Z';
    }

    // 判断产生式左右是否合法
    private boolean isValid(String str) {
        int len = str.length();
        for (int i = 0; i < len; i++) {
            char c = str.charAt(i);
            if (c != '@' && (c < 'a' || c > 'z') && (c < 'A' || c > 'Z')) {
                return false;
            }
        }
        return true;
    }

    public void display() {
        System.out.println(left + " -> " + right + "; type: " + convertMap.get(type));
    }
}
