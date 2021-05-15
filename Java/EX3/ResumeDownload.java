import java.io.*;
import java.net.*;
import java.util.Scanner;

public class ResumeDownload {
    private static String str;
    private static int contentLength;
    private static String contentType;
    private static String filename;
    //String url = "http://ftp.szu.moe/Aurora/%E5%8D%8F%E4%BC%9A%E5%B7%A5%E4%BD%9C/%E4%B9%B1%E4%B8%83%E5%85%AB%E7%B3%9F/DevOps/JavaScript/%E5%B0%8F%E7%A0%81_Node.js%EF%BC%8C24%E8%8A%82%E5%AE%8C%E6%95%B4/1-20%E8%8A%82/12.express%E6%A0%B8%E5%BF%83%E7%94%A8%E6%B3%95%E5%92%8C%E6%BA%90%E7%A0%81%E8%A7%A3%E8%AF%BB%E3%80%90%E7%91%9E%E5%AE%A2%E8%AE%BA%E5%9D%9B%20%20www.ruike1.com%E3%80%91.mp4";
    //String url = "https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe";


    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.println("please input url(enter q to quit):");
            if (scanner.hasNextLine()) {
                str = scanner.nextLine();
                if (str.equalsIgnoreCase("q")) {
                    break;
                }
                try {
                    URL url = new URL(str);
                    filename = url.getFile();
                    // 处理从跟路由进去的html无法匹配到文件名的问题
                    if (filename.length() == 0) {
                        filename += "." + contentType.substring(contentType.lastIndexOf('/') + 1);
                    } else {
                        filename = filename.substring(filename.lastIndexOf('/') + 1);
                    }
                    if (supportResumeDownload(url)) { // 支持断点续传
                        download(url, true);
                    } else { // 不支持断点续传 直接下载
                        download(url, false);
                    }
                } catch (MalformedURLException ex) {
                    System.err.println(str + " is not URL I understand.");
                } catch (Exception ex) {
                    System.err.println(ex);
                }
            }
        }
    }

    //检测目标文件是否支持断点续传 并保存相关信息
    private static boolean supportResumeDownload(URL url) throws IOException {
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestProperty("Range", "bytes=0-");
        int statusCode;
        while (true) {
            try {
                con.connect();
                contentLength = con.getContentLength();
                contentType = con.getContentType();
                statusCode = con.getResponseCode();
                con.disconnect();
                break;
            } catch (ConnectException e) {
                System.out.println("Retry to connect due to connection problem.");
            }
        }
        if (statusCode == 206) {
            System.out.println("Support resume download");
            return true;
        } else {
            System.out.println("Doesn't support resume download");
            return false;
        }
    }

    // 支持断点续传 获取[startPos, end]流
    private static InputStream getPartOfInputString(URL url, int startPos) throws Exception {
        URLConnection uc = url.openConnection();
        // 设置断点续传的开始位置
        uc.setRequestProperty("RANGE", String.format("bytes=%d-", startPos));
        return uc.getInputStream();
    }

    // flag为true支持断点续传
    private static void download(URL url, boolean flag) throws Exception {
        URLConnection uc = url.openConnection();
        System.out.println("Type: " + contentType + "\t Length: " + contentLength / 1024 + " KB");
        System.out.println("Downloading...");

        if (!flag) { // 不支持断点续传
            try (InputStream raw = uc.getInputStream()) {
                InputStream in = new BufferedInputStream(raw);
                int offset = 0;
                byte[] data = new byte[contentLength];
                while (offset < contentLength) {
                    int bytesRead = in.read(data, offset, data.length - offset);
                    if (bytesRead == -1) break;
                    offset += bytesRead;
                }
                if (offset != contentLength) {
                    throw new IOException("Only read " + offset + " bytes; Expected " + contentLength + " bytes");
                }
                // 写文件
                try (FileOutputStream fout = new FileOutputStream("src/data/" + filename)) {
                    fout.write(data);
                    fout.flush();
                    System.out.println("Successfully saved file " + filename);
                }
            }
        } else { // 支持断点续传
            RandomAccessFile r = new RandomAccessFile(new File("src/data/" + filename), "rw");
            int offset = (int) r.length();
            if (offset == contentLength) {
                System.out.println("No need to download");
                return;
            }
            if (offset != 0) {
                System.out.println("Retry from " + (offset / 1024) + " to end.");
            }
            while (offset < contentLength) {
                try (InputStream raw = getPartOfInputString(url, offset)) {
                    InputStream in = new BufferedInputStream(raw);
                    r.seek(offset);
                    byte[] b = new byte[2048];
                    int len;
                    while ((len = in.read(b, 0, 2048)) != -1) {
                        r.write(b, 0, len);
                        offset += len;
                    }
                }
            }
            if (offset != contentLength) {
                throw new IOException("Only read " + offset + " bytes; Expected " + contentLength + " bytes");
            } else {
                System.out.println("Successfully saved file " + filename);
            }
        }
    }
}
