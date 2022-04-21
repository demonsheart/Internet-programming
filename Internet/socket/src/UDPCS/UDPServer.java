package UDPCS;

import java.net.*;
import java.nio.charset.StandardCharsets;

public class UDPServer {
    public static void main(String[] args) throws Exception {
        // UDP 端口监听
        DatagramSocket serverSocket = new DatagramSocket(30034);

        byte[] receiveData = new byte[1024];
        byte[] sendData;

        while (true) {
            // 接收数据包
            DatagramPacket packet =
                    new DatagramPacket(receiveData, receiveData.length);
            serverSocket.receive(packet);

            // 转化为字符串
            String sentence = new String(packet.getData(), packet.getOffset(), packet.getLength(), StandardCharsets.UTF_8);

            // 字符串处理
            String capitalizedSentence = sentence.toUpperCase();
            sendData = capitalizedSentence.getBytes();

            // 返回数据包
            DatagramPacket sendPacket =
                    new DatagramPacket(sendData, sendData.length, packet.getAddress(),
                            packet.getPort());
            serverSocket.send(sendPacket);
        }

    }
}
