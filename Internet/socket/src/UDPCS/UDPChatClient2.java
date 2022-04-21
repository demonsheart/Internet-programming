package UDPCS;

import java.net.DatagramSocket;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class UDPChatClient2 extends Thread {

    public static void main(String[] args) throws Exception {
        // 开启监听子线程 用于监听控制台输入 发送数据包任务交给子线程
        UDPChatClient2 c1 = new UDPChatClient2();
        c1.start();

        // 监听接收的udp包 并显示
        DatagramSocket serverSocket = new DatagramSocket(55556);
        byte[] receiveData = new byte[1024];

        while (true) {
            // 接收数据包
            DatagramPacket packet =
                    new DatagramPacket(receiveData, receiveData.length);
            serverSocket.receive(packet);

            // 转化为字符串
            String sentence = new String(packet.getData(), packet.getOffset(), packet.getLength(), StandardCharsets.UTF_8);
            System.out.println("对方：" + sentence);
        }

    }

    // 监听控制台输入 发送数据包任务交给子线程
    @Override
    public void run() {
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String sentence = scanner.nextLine().trim();
            if (sentence.length() == 0) {
                continue;
            }

            // 发送包到对方用户
            try {
                InetAddress address = InetAddress.getByName("localhost");
                DatagramSocket socket = new DatagramSocket();
                // 转换sentence并发送数据包给对方
                byte[] sendData = sentence.getBytes(StandardCharsets.UTF_8);
                DatagramPacket sendPacket =
                        new DatagramPacket(sendData, sendData.length, address, 55555);
                socket.send(sendPacket);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
