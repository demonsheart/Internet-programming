import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class GetIPThroughDomain {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.println("please input domain(enter q to quit):");
            if (scanner.hasNextLine()) {
                String domain = scanner.nextLine();
                if (domain.equalsIgnoreCase("q")) {
                    break;
                }
                List<String> ips = getAllIP(domain);
                for (String ip : ips) {
                    System.out.print(ip + " ");
                }
                System.out.println();
            }
        }
    }

    public static List<String> getAllIP(String url) {
        List<String> result = new ArrayList<>();
        try {
            InetAddress[] addresses = InetAddress.getAllByName(url);
            for (InetAddress address : addresses) {
                result.add(address.getHostAddress());
            }
        } catch (Exception e) {
            System.out.println("Cannot find ip from " + url);
        }
        return result;
    }
}
