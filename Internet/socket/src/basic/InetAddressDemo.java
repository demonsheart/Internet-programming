package basic;

import java.net.InetAddress ;

public class InetAddressDemo {
    public static void main(String[] args)throws Exception {
        InetAddress locAdd = null ;
        locAdd = InetAddress.getLocalHost() ;
        //获取本机的IP地址并打印
        System.out.println("本地IP" + locAdd.getHostAddress());
        //获取本机的名称并打印
        System.out.println("本机名称" + locAdd.getHostName());
    }
}