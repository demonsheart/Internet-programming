import cn.wanghaomiao.xpath.model.JXDocument;
import cn.wanghaomiao.xpath.model.JXNode;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DouBanSpider {
    // 十页 十个线程
    public static final String USER_AGENT[] = new String[]{
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
    };
    private static final String Cookie = "ll=\"118282\"; bid=_pAtdo8BJ4E; __gads=ID=325cf67fe67250ff-22386e3ea6c600c9:T=1616467167:RT=1616467167:S=ALNI_Mb6MLyRzZH4muei9AdDB-hD72yk3Q; _vwo_uuid_v2=D977B64A023FAD93FF75D0CD5A963AC9A|d6c6accfcc768f13d589ebd7118e5a2f; __yadk_uid=52cysxOQmtUSX7MUelUfaZslzEL8fM8Q; __utma=30149280.1377641006.1616467167.1616467167.1621578058.2; __utmc=30149280; __utmz=30149280.1621578058.2.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); dbcl2=\"238455111:b5iagDuUM3k\"; ck=o5CE; push_noty_num=0; push_doumail_num=0; __utmv=30149280.23845; __utmb=30149280.13.9.1621578211134; __utmc=223695111; _pk_ref.100001.4cf6=%5B%22%22%2C%22%22%2C1621578237%2C%22https%3A%2F%2Fwww.douban.com%2Fpeople%2F238455111%2F%22%5D; _pk_ses.100001.4cf6=*; __utma=223695111.1540399195.1616467167.1621578237.1621578652.3; __utmb=223695111.0.10.1621578652; __utmz=223695111.1621578652.3.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _pk_id.100001.4cf6=626e55b21cf74b5d.1616467167.2.1621579352.1616467167.";
    public static final String referer = "https://movie.douban.com/top250";
    private static List<String> urls = new ArrayList<>();
    public static int index = 0;
    public static HashMap<String, String> cookieMap;
    public static CountDownLatch latch = new CountDownLatch(250);

    // https://movie.douban.com/top250?start=50&filter=

    public static void main(String[] args) throws Exception {
        cookieMap = convertCookie(Cookie);
        get_urls();
        // 写表头
        BufferedWriter bw = new BufferedWriter(new FileWriter("src/result.csv", StandardCharsets.UTF_8));
        bw.write('\ufeff');
        bw.write("影片, 导演, 编剧, 主演, 类型, 制片国家/地区, 语言, 上映时间, 时长, 别名, IMDb, 豆瓣评分, 评分人数, 剧情简介, 图片链接, 短评");
        bw.close();
        // 建立线程池
        ExecutorService es = Executors.newFixedThreadPool(10);
        for (String ur : urls) {
            Thread.sleep(300);
            es.submit(new OnePageSpider(ur));
        }
        es.shutdown();
        latch.await();
    }

    public static HashMap<String, String> convertCookie(String cookie) {
        HashMap<String, String> cookiesMap = new HashMap<String, String>();
        String[] items = cookie.trim().split(";");
        for (String item : items) cookiesMap.put(item.split("=")[0], item.split("=")[1]);
        return cookiesMap;
    }

    private static void get_urls() throws Exception {
        // xpath
        // //div[@class='hd']/a/@href
        for (int start = 0; start < 250; start += 25) {
            Thread.sleep(300);
            String pageURL = String.format("https://movie.douban.com/top250?start=%d&filter=", start);
            Document doc = Jsoup.connect(pageURL).userAgent(USER_AGENT[(index++) % 10]).referrer(referer).cookies(cookieMap).get();
            JXDocument jxDocument = new JXDocument(doc);
            List<JXNode> jxNodes = jxDocument.selN("//div[@class='hd']/a/@href");
            for (JXNode jxNode : jxNodes) {
                urls.add(jxNode.toString());
            }
        }
    }
}


// 多线程爬取具体信息
// 电影名，导演，主演，年份，产地，电影类型，评分，评分人数，简短评价，电影介绍URL和海报图片
class OnePageSpider implements Runnable {
    private Document doc;
    private JXDocument jxDocument;
    private String no;
    private String movieName; //h1/span[1]/text()
    private String director;
    private String screenwriter;
    private String roles;
    private String type;
    private String location;
    private String language;
    private String releaseTime;
    private String duration;
    private String alias;
    private String IMDb;

    private String score; // //div[@class='rating_self clearfix']/strong
    private String scoreNum;// //div[@class='rating_sum']//span/text()
    private String summary; // //span[@property='v:summary']
    private String imageURL; // //div[@id='mainpic']//img/@src

    private String url; // 参数传入

    private List<String> shortReview; // //div[@id='hot-comments']//span[@class='short']/text()

    OnePageSpider(String url) {
        this.url = url;
    }

    private String getStringFromXpath(String xpath) throws Exception {
        String res;
        StringBuffer sb = new StringBuffer();
        List<JXNode> jxNodes = jxDocument.selN(xpath);
        for (JXNode jxNode : jxNodes) {
            sb.append(" ");
            sb.append(jxNode.toString());
        }
        res = sb.toString();
//        System.out.println(res);
        return res;
    }

    private void getShortReview(String xpath) throws Exception {
        shortReview = new ArrayList<>();
        List<JXNode> jxNodes = jxDocument.selN(xpath);
        for (JXNode jxNode : jxNodes) {
            shortReview.add(jxNode.toString());
//            System.out.println(jxNode.toString());
        }
    }

    // 以排名和电影名命名保存 1-肖申克的救赎.webp
    private void downloadImage(URL ur) throws Exception {
        URLConnection uc = ur.openConnection();
        int contentLength = uc.getContentLength();
        String contentType = uc.getContentType();
        if (contentLength == -1) {
            throw new Exception("Fail!");
        }

        System.out.println("Type: " + contentType + "\t Length: " + contentLength / 1024 + " KB");
        try (InputStream raw = uc.getInputStream()) {
            InputStream in = new BufferedInputStream(raw);
            byte[] data = new byte[contentLength];
            int offset = 0;
            while (offset < contentLength) {
                int bytesRead = in.read(data, offset, data.length - offset);
                if (bytesRead == -1) break;
                offset += bytesRead;
            }
            if (offset != contentLength) {
                throw new IOException("Only read " + offset + " bytes; Expected " + contentLength + " bytes");
            }

            String filename = no + "-" + movieName + ".webp";
            try (FileOutputStream f = new FileOutputStream("src/images/" + filename)) {
                f.write(data);
                f.flush();
                System.out.println("Saved file " + filename);
            }
        }
    }

    synchronized private void saveInFile() throws IOException {
        BufferedWriter bw = new BufferedWriter(new FileWriter("src/result.csv", true));
        String line = movieName + ", " + director + ", " + screenwriter + ", " + roles + ", " + type + ", " + location + ", " + language + ", " + releaseTime + ", " + duration + ", " + alias + ", " + IMDb + ", " + score + ", " + scoreNum + ", " + summary + ", " + imageURL + ", " + shortReview.get(0);
//        System.out.println(line);
        bw.write("\n" + line);
        bw.close();
    }

    // 正则匹配返回group(1)
    private String myRegex(String rule, String data) {
        Pattern pattern = Pattern.compile(rule);
        Matcher matcher = pattern.matcher(data);
        if (matcher.find())
            return matcher.group(1);
        return null;
    }

    // 剩下的必须通过正则
    private void getRemain() throws Exception {
        String st = jxDocument.selN("//div[@id='info']//text()").get(0).toString();
        // 关键在":"
        alias = myRegex("又名:(.*)IMDb", st);
        IMDb = myRegex("IMDb:(.*)", st);
        location = myRegex("制片国家/地区:(.*)语言", st);
        language = myRegex("语言:(.*)上映日期", st);
    }

    @Override
    public void run() {
        try {
            doc = Jsoup.connect(this.url).userAgent(DouBanSpider.USER_AGENT[(DouBanSpider.index++) % 10])
                    .referrer(DouBanSpider.referer).cookies(DouBanSpider.cookieMap).get();
            jxDocument = new JXDocument(doc);
            no = getStringFromXpath("//span[@class='top250-no']/text()");
            movieName = getStringFromXpath("//h1/span[1]/text()");
            System.out.println("Processing" + movieName);
            score = getStringFromXpath("//div[@class='rating_self clearfix']/strong/text()");
            scoreNum = getStringFromXpath("//div[@class='rating_sum']//span/text()");
            summary = getStringFromXpath("//span[@property='v:summary']/text()");
            imageURL = getStringFromXpath("//div[@id='mainpic']//img/@src");
            getShortReview("//div[@id='hot-comments']//span[@class='short']/text()");
            director = getStringFromXpath("//div[@id='info']/span[1]//a/text()");
            screenwriter = getStringFromXpath("//div[@id='info']/span[2]//a/text()");
            roles = getStringFromXpath("//div[@id='info']/span[3]//a/text()");
            type = getStringFromXpath("//div[@id='info']/span[@property='v:genre']/text()");
            releaseTime = getStringFromXpath("//div[@id='info']/span[@property='v:initialReleaseDate']/text()");
            duration = getStringFromXpath("//div[@id='info']/span[@property='v:runtime']/text()");
            getRemain();
            saveInFile();
            downloadImage(new URL(imageURL));
            System.out.println("Successfully processed " + movieName);
        } catch (Exception e) {
            System.out.println("something wrong.");
        } finally {
            DouBanSpider.latch.countDown();
        }
    }
}