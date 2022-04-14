package SendFile;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetSocketAddress;
import java.net.Socket;

/*
 * 用TCP进行文件传输
 * 此文件为客户端文件
 * 连接上服务器之后，直接接受文件
 *
 * */
public class SendFileClient {

    private static final String SERVERIP = "127.0.0.1";
    private static final int SERVER_PORT = 12345;
    private static final int CLIENT_PORT = 54321;
    private static final String DIR = "src/data/";

    public static void main(String[] args) {

        Socket s = new Socket();
        try {
            // 建立连接
            s.connect(new InetSocketAddress(SERVERIP, SERVER_PORT), CLIENT_PORT);
            InputStream is = s.getInputStream();
            System.out.println("与服务器连接成功");

            // 接收传输来的文件名
            byte[] buf = new byte[100];
            int len = is.read(buf);
            String fileName = new String(buf, 0, len);
            System.out.println("接收到的文件为：" + fileName);
            System.out.println("保存为为：" + "1" + fileName);

            // 接收传输来的文件
            FileOutputStream fos = new FileOutputStream(DIR +"1" + fileName);
            byte[] data = is.readAllBytes();
            fos.write(data);

            // 关闭资源
            fos.close();
            is.close();
            s.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}