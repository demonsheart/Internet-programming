import cn.wanghaomiao.xpath.model.JXDocument;
import cn.wanghaomiao.xpath.model.JXNode;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;


public class Spider {
    private static final String USER_AGENT = "User-Agent:Mozilla/5.0 (Windows; U; Windows NT 6.1; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50";
    private static final String api = "https://www.baidu.com/s?wd=";

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
        Document doc = Jsoup.connect(url).userAgent(USER_AGENT).get();

        // xpath解析
        JXDocument jxDocument = new JXDocument(doc);
        List<JXNode> jxNodes = jxDocument.selN("//h3");
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
        URLConnection connection = new URL(url).openConnection();
        return connection.getHeaderField("Location");
    }
}
