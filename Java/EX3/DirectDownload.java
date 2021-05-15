import java.net.*;
import java.util.*;
import java.io.*;

public class DirectDownload {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String url;
        while (true) {
            System.out.println("please input url(enter q to quit):");
            if (scanner.hasNextLine()) {
                url = scanner.nextLine();
                if (url.equalsIgnoreCase("q")) {
                    break;
                }
                try {
                    URL root = new URL(url);
                    DownloadFile(root);
                } catch (MalformedURLException ex) {
                    System.err.println(url + " is not URL I understand.");
                } catch (Exception ex) {
                    System.err.println(ex);
                }
            }
        }
    }

    private static void DownloadFile(URL ur) throws Exception {
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
            String filename = ur.getFile();
            filename = filename.substring(filename.lastIndexOf('/') + 1);
            // 处理从跟路由进去的html无法匹配到文件名的问题
            if (filename.length() == 0) {
                filename += "." + contentType.substring(contentType.lastIndexOf('/') + 1);
            }
            try (FileOutputStream fout = new FileOutputStream("src/data/" + filename)) {
                fout.write(data);
                fout.flush();
                System.out.println("Saved file " + filename);
            }
        }
    }
}
