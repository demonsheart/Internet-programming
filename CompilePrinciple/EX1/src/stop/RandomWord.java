package stop;

import tool.MyTool;

public class RandomWord {
    private int minLen;
    private int maxLen;

    public RandomWord(int minLen, int maxLen) {
        this.minLen = minLen;
        this.maxLen = maxLen;
    }

    // 生成随机小写字母
    private char randomLetter() {
        return (char) ('a' + MyTool.randomInt(0, 25));
    }

    // 随机停用词生成器
    public String randomWord() {
        int len = MyTool.randomInt(minLen, maxLen);
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < len; i++) {
            sb.append(randomLetter());
        }
        return sb.toString();
    }
}
