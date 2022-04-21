package basic;

import java.net.InetAddress ;

public class InetAddressDemo2 {
    public static void main(String[] args)throws Exception {
//        String host = "www.csdn.net";
        String host = "www.baidu.com";

        //获取网站的IP地址
        InetAddress[] addresses = InetAddress.getAllByName(host);

        for (InetAddress addr : addresses) {
            System.out.println(addr.getHostAddress());
        }
    }
}