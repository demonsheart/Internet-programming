import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Vector;

public class ReadAttributes {
    public static void main(String[] args) throws IOException {
        Vector v = new Vector(4);
        v.add("blockchain.txt");
        v.add("distributed system.txt");
        v.add("high performance.txt");
        v.add("trajectory.txt");
        BufferedWriter bw = new BufferedWriter(new FileWriter("src/result/property.txt", StandardCharsets.UTF_8));

        for (Object fileName : v) {
            String filePath = "src/data/" + fileName;
            File f = new File(filePath);

            if (f.exists()) {

                bw.write("filename: " + f.getName() + "\n");
                bw.write("absolute path: " + f.getAbsolutePath() + "\n");
                bw.write("path: " + f.getPath() + "\n");
                bw.write("size: " + f.length() + "byte" + "\n");
                bw.write("size: " + (float) f.length() / 1000 + "kb" + "\n");
                bw.write("hidden: " + f.isHidden() + "\n");
                bw.write("readable: " + f.canRead() + "\n");
                bw.write("writeable: " + f.canWrite() + "\n\n");

                System.out.println("the message of " + fileName + " was written in property.txt");
            } else {
                System.out.println("the " + fileName +" does not exists");
            }
        }
        bw.close();
    }
}
