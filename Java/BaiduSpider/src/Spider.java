import cn.wanghaomiao.xpath.model.JXDocument;
import cn.wanghaomiao.xpath.model.JXNode;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.lang.Thread;

import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;


public class Spider {
    private static final String USER_AGENT[] = new String[]{
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1",
            "Mozilla/5.0 (X11; CrOS i686 2268.111.0) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11",
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1090.0 Safari/536.6",
            "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/19.77.34.5 Safari/537.1",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.9 Safari/536.5",
            "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.36 Safari/536.5",
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.0 Safari/536.3",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24",
            "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24"
    };
    private static final String api = "https://www.baidu.com/s?wd=";
    private static int i = 0;
    private static int UAlen = USER_AGENT.length;

    public static void main(String[] args) throws Exception {
        Scanner scan = new Scanner(System.in);
        // 输入
        while (true) {
            System.out.println("Please enter an entry you want to search(enter q to quit):");
            if (scan.hasNextLine()) {
                String entry = scan.nextLine();
                if (entry.equals("q"))
                    break;
                HashMap<String, String> mp = get_map(entry);
                for (Map.Entry<String, String> m : mp.entrySet()) {
                    String ur = get_real_url(m.getValue());
                    if (ur == null)
                        ur = m.getValue();
                    System.out.println(m.getKey() + " " + ur);
                }
                System.out.println("");
            }
        }
    }

    // 返回结果集 title - url
    public static HashMap<String, String> get_map(String entry) throws Exception {
        HashMap<String, String> mp = new HashMap<>();
        String url = api + URLEncoder.encode(entry, StandardCharsets.UTF_8);
        // 请求
        Document doc = Jsoup.connect(url).userAgent(USER_AGENT[(i++) % UAlen]).get();

        // xpath解析
        JXDocument jxDocument = new JXDocument(doc);
        List<JXNode> jxNodes = jxDocument.selN("//div[@id='content_left']/div/h3");
        for (JXNode jxNode : jxNodes) {
            List<JXNode> titleNode = jxNode.sel("/a[1]").get(0).sel("/em/text() | /text()");
            StringBuffer buf = new StringBuffer();
            for (JXNode t : titleNode) {
                buf.append(t.toString());
            }
            String title = buf.toString();
            String ur = jxNode.sel("/a[1]/@href").get(0).toString();
            if (!ur.contains("http")) {
                ur = "http://www.baidu.com" + ur;
            }
            mp.put(title, ur);
        }
        return mp;
    }

    public static String get_real_url(String url) throws Exception {
        Thread.sleep(500);
        URLConnection connection = new URL(url).openConnection();
        connection.setRequestProperty("user-agent", USER_AGENT[(i++) % UAlen]);
        connection.connect();
        return connection.getHeaderField("Location");
    }
}
