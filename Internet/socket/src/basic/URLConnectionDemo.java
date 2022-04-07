package basic;
import java.io.FileOutputStream;
import java.net.URL ;
import java.net.URLConnection ;
import java.io.InputStream ;

public class URLConnectionDemo {


    public static void main(String[] args) throws Exception{
        URL url = new URL("https://www.szu.edu.cn") ;
        //使用URLConnection建立url连接
        URLConnection connection = url.openConnection();
        InputStream in = connection.getInputStream();
        FileOutputStream out = new FileOutputStream("index.html");

        // 下载数据
        byte[] bytes = in.readAllBytes();

        //统计下载得到网页文件的大小，并打印
        System.out.println("Type: " + connection.getContentType() + "\t Length: " + bytes.length / 1024 + " KB");
        out.write(bytes);
        out.close();
        System.out.println("saved file in index.html");
    }
}