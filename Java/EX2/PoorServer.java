import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.*;

public class PoorServer {
    private static final int SERVER_PORT = 9999;
    private static final int ThreadNum = 100;

    public static void main(String[] args) throws IOException {
        System.out.println("===============TCP SERVER==============");
        ServerSocket server = null;
        ExecutorService es = Executors.newFixedThreadPool(ThreadNum);
        try {
            server = new ServerSocket(SERVER_PORT);

            System.out.println("Listening Port is " + server.getLocalPort() + "...");
            while (true) {
                Socket client = server.accept();
                es.submit(new ThreadPoorServer(client));
            }
        } catch (Exception e) {
            e.printStackTrace();
            server.close();
            es.shutdown();
        }
    }
}

class ThreadPoorServer implements Runnable {
    private Socket socket;
    private String name;
    private String time;

    ThreadPoorServer(Socket socket) {
        this.socket = socket;
    }


    @Override
    public void run() {
        try {
            InputStream is = socket.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is));
            String line = br.readLine();

            String[] strs = line.split(" ## ");
            name = strs[0];
            time = strs[1];
            String message = strs[2];
            // 记录日志
            System.out.println(name + " connected to server on " + time + " with message: '" + message + "'");
            this.writelog();

            OutputStream out = socket.getOutputStream();
            out.write(("Hello! " + name + ". Your request has been processed!").getBytes(StandardCharsets.UTF_8));
            out.flush();

            br.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private synchronized void writelog() {
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter("log2.txt", true));
            bw.write(socket.getInetAddress() + ":" + socket.getPort() + " [" + time + "]" + '\n');
            bw.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}