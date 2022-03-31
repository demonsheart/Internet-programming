package CS;

import java.io.*;
import java.net.*;
import java.util.Date;

public class MyServer {
    public static void main(String[] args) {
        try {
            ServerSocket server = new ServerSocket(9527);
            System.out.println("服务器启动完毕");
            Socket socket = server.accept();
            System.out.println("创建客户连接");
            InputStream input = socket.getInputStream();
            InputStreamReader isreader = new InputStreamReader(input);
            BufferedReader reader = new BufferedReader(isreader);
            while (true) {
                String str = reader.readLine();
                //如果接收到“exit”，打印"bye"
                if (str.trim().equalsIgnoreCase("exit")) {
                    System.out.println("Bye");
                    break;
                }

                //如果收到"Time"，打印“服务器当前的时间为:”+实际时间
                if (str.trim().equalsIgnoreCase("time")) {
                    System.out.println("服务器当前的时间为: " + new Date().toString());
                }
            }

            reader.close();
            isreader.close();
            input.close();
            socket.close();
            server.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
