package UDPCS;

import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class UDPClient {
    public static void main(String args[]) throws Exception
    {
        Scanner scanner = new Scanner(System.in);
        DatagramSocket clientSocket = new DatagramSocket();
        InetAddress address = InetAddress.getByName("localhost");

        byte[] sendData;
        byte[] receiveData = new byte[1024];

        while (scanner.hasNextLine()) {
            String sentence = scanner.nextLine();

            // end 退出程序
            if (sentence.equalsIgnoreCase("end")) {
                break;
            }

            // 准备并发送数据包
            sendData = sentence.getBytes(StandardCharsets.UTF_8);
            DatagramPacket sendPacket =
                    new DatagramPacket(sendData, sendData.length, address, 55555);
            clientSocket.send(sendPacket);

            // 接收数据包
            DatagramPacket receivePacket =
                    new DatagramPacket(receiveData, receiveData.length);
            clientSocket.receive(receivePacket);

            // 转化为字符串并输出
            String receiveSentence =
                    new String(receivePacket.getData(), receivePacket.getOffset(), receivePacket.getLength());
            System.out.println("FROM Server: " + receiveSentence);
        }
        clientSocket.disconnect();
    }
}
