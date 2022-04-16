package UnsignedNumber;

import java.io.IOException;

public class UnsignedNumberMain {
    public static void main(String[] args) throws IOException {
//        UnsignedNumberRecognizer reg = new UnsignedNumberRecognizer("data1.txt", UnsignedNumberRecognizer.NumberType.DiGiTAL);
        UnsignedNumberRecognizer reg = new UnsignedNumberRecognizer("data2.txt", UnsignedNumberRecognizer.NumberType.ALPHABET);
        reg.startAnalyze();
    }
}
