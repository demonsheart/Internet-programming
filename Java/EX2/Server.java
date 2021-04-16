import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class Server {
    private static final int SERVER_PORT = 8888;

    public static void main(String[] args) throws IOException {
        System.out.println("===============TCP SERVER==============");
        ServerSocket server = null;
        try {
            server = new ServerSocket(SERVER_PORT);

            System.out.println("Listening Port is " + server.getLocalPort() + "...");
            while (true) {
                Socket client = server.accept();
                new ServerThread(client).start();
            }
        } catch (Exception e) {
            e.printStackTrace();
            server.close();
        }
    }
}

class ServerThread extends Thread {
    private Socket threadClient;
    private String name;
    private String time;

    public ServerThread(Socket threadSocket) {
        this.threadClient = threadSocket;
    }

    @Override
    public void run() {
        try {
            InputStream is = threadClient.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is));
            String line = br.readLine();

            String[] strs = line.split(" ## ");
            name = strs[0];
            time = strs[1];
            String message = strs[2];
            // 记录日志
            System.out.println(name + " connected to server on " + time + " with message: '" + message + "'");
            this.writelog();

            OutputStream out = threadClient.getOutputStream();
            out.write(("Hello! " + name + ". Your request has been processed!").getBytes(StandardCharsets.UTF_8));
            out.flush();

            br.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private synchronized void writelog() {
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter("log1.txt", true));
            bw.write(threadClient.getInetAddress() + ":" + threadClient.getPort() + " [" + time + "]" + '\n');
            bw.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}