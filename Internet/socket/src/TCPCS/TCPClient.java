package TCPCS;

import java.io.*;
import java.net.*;

public class TCPClient {
    public static void main(String[] args) {
        try {
            //创建客户端TCP socket接口
            Socket socket = new Socket("127.0.0.1", 9527);
            //生成名为out的输出流
            OutputStream out = socket.getOutputStream();

            out.write("Time\n".getBytes());
            out.write("exit\n".getBytes());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
