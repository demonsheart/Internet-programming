import java.io.*;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Future;
import java.util.concurrent.FutureTask;

public class Client {
    public static int clientNum = 1000;

    public static void main(String[] args) throws Exception {
        // 多线程模拟并发效果
        long startTime = System.currentTimeMillis();
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
        long endTime = System.currentTimeMillis();
        System.out.println("total used " + (endTime - startTime) + "ms");
    }
}

class ClientThread implements Callable<Object> {
    private int i;
    private String name;

    ClientThread(int i, String name) {
        this.i = i;
        this.name = name;
    }

    @Override
    public Object call() throws Exception {
        try {
            Socket socket = new Socket("127.0.0.1", 8888);
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