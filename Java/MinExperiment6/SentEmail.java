import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

public class SentEmail {
    public static void main(String[] args) throws Exception {
        // 服务器地址:
        String smtp = "smtp.163.com";
        // 登录用户名:
        String username = "";
        // 登录口令:
        String password = ""; // 163

        // 仅限163邮箱
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.println("Please enter your 163 email");
            if (scanner.hasNext("[\\w'.%+-]+@163\\.com")) {
                username = scanner.next();
                break;
            } else {
                System.out.println("Invalid email, please try again");
                scanner.nextLine();
            }
        }
        System.out.println("Please enter your authorization code");
        if (scanner.hasNext()) {
            password = scanner.next();
        }

        System.out.println();
        System.out.println("Try to login...");
        Mail mail = new Mail(smtp, username, password);
        // 尝试连接
        mail.connect();
        System.out.println("Login successfully!");

        String target = null, theme = null, content;
        while (true) {
            System.out.println("please enter target email:");
            if (scanner.hasNext("[\\w'.%+-]+@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,4}")) {
                target = scanner.next();
                break;
            } else {
                System.out.println("Invalid email, please try again");
                scanner.nextLine();
            }
        }
        System.out.println("please enter theme:");
        if (scanner.hasNext()) {
            theme = scanner.next();
        }
        StringBuffer sb = new StringBuffer();
        System.out.println("Please enter content(The last line ends with q):");
        while (true) {
            if (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.equals("q")) {
                    break;
                }
                sb.append(line);
            }
        }
        content = sb.toString();
        mail.sent_text(target, theme, content);
        System.out.println("Successfully!");
    }
}

class Mail {
    private String smtp;
    private String username;
    private String password;
    private Session session;

    Mail(String smtp, String username, String password) {
        this.smtp = smtp;
        this.username = username;
        this.password = password;
    }

    public void connect() {
        // 连接到SMTP服务器25端口:
        Properties props = new Properties();
        props.put("mail.smtp.host", smtp); // SMTP主机名
        props.put("mail.smtp.port", "25"); // 主机端口号
        props.put("mail.smtp.auth", "true"); // 是否需要用户认证
        props.put("mail.smtp.starttls.enable", "true"); // 启用TLS加密
        // 获取Session实例:
        session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        // 设置debug模式便于调试:
//        session.setDebug(true);
    }

    public void sent_text(String target, String theme, String content) throws Exception {
        MimeMessage message = new MimeMessage(session);
        // 设置发送方地址:
        message.setFrom(new InternetAddress(username));
        // 设置接收方地址:
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(target));
        // 设置邮件主题:
        message.setSubject(theme, "UTF-8");
        // 设置邮件正文:
        message.setText(content, "UTF-8");
        // 发送:
        Transport.send(message);
    }
}
