package SendFile;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

/*
 * 用TCP进行文件传输
 * 此文件为服务器文件
 * 当接受到客户端的请求之后，先向其传输文件名
 * 当客户端接受完毕之后，向客户端传输文件
 * */

public class SendFileServer implements Runnable {

    // 服务器监听端口
    private static final int MONITOR_PORT = 22222;
    private final Socket socket;

    public SendFileServer(Socket socket) {
        super();
        this.socket = socket;
    }

    public static void server() {
        try {
            // 创建服务器socket
            ServerSocket ss = new ServerSocket(MONITOR_PORT);

            for (int i = 0; ; i++) {
                // 接收到一个客户端连接之后，创建一个新的线程进行服务
                // 并将联通的socket传给该线程
                Socket s = ss.accept();
                System.out.println("服务器的线程" + i + "启动,与客户端1连接成功");

                new Thread(new SendFileServer(s)).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        SendFileServer.server();
    }

    @Override
    public void run() {
        OutputStream os;
        FileInputStream fins;

        try {
            os = socket.getOutputStream();

            // 先将文件名传输过去
            String fileName = "test.txt";
            System.out.println("要传输的文件为: " + fileName);
            os.write(fileName.getBytes(StandardCharsets.UTF_8));

            // 读入文件数据
            String DIR = "src/data/";
            fins = new FileInputStream(DIR + fileName);
            byte[] data = fins.readAllBytes();

            // 涉及到异步IO问题 这里只是简单的制造时延
            Thread.sleep(500);

            // 发送数据
            System.out.println("开始传输文件");
            os.write(data);
            os.flush();
            System.out.println("文件传输结束");

            // 关闭资源
            fins.close();
            os.close();
            this.socket.close();

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }

}