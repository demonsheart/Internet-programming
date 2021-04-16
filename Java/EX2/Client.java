import java.io.*;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.*;

public class Client {
    public static int clientNum = 1000; // 一次并发线程数

    public static void main(String[] args) throws Exception {
        // 多线程模拟并发效果
        long startTime = System.currentTimeMillis();
        for (int multiple = 0; multiple < 1; ++multiple) { // 由于客户端连接会占用系统端口 并发过高会报错 故以1000为倍数 线性的执行
            List<FutureTask<Object>> tasks = new ArrayList<>();
            for (int i = 1; i < clientNum; ++i) {
                ClientThread clientThread = new ClientThread(i, "Client" + i);
                FutureTask<Object> re = new FutureTask<>(clientThread);
                tasks.add(re);
                new Thread(re).start();
            }
            // 利用get产生堵塞，计时
            for (FutureTask<Object> t : tasks) {
                t.get();
            }
        }
        long endTime = System.currentTimeMillis();
        System.out.println("total used " + (endTime - startTime) + "ms");
    }
}

class ClientThread implements Callable<Object> {
    private int i;
    private String name;
//    private static final int PORT = 8888;
    private static final int PORT = 9999;

    ClientThread(int i, String name) {
        this.i = i;
        this.name = name;
    }

    @Override
    public Object call() throws Exception {
        try {
            Socket socket = new Socket("127.0.0.1", PORT);
            System.out.println("Connected to server...sending command string");
            OutputStream out = socket.getOutputStream();
            SimpleDateFormat sdf = new SimpleDateFormat();
            sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
            String name = "Client" + i;
            String message = "Hey, gays. I'm " + name;
            out.write((name + " ## " + sdf.format(new Date()) + " ## " + message + "\n").getBytes(StandardCharsets.UTF_8));  // 发送
            out.flush();

            InputStream is = socket.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is));
            String line = br.readLine();
            System.out.println(line);

            out.close();
            socket.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}