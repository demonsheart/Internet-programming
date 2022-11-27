import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnectTool {
    private static String URL = "jdbc:mysql://localhost:3306/middle_final?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC";
    private static String DriverClass = "com.mysql.cj.jdbc.Driver";
    private static String UserName = "root";
    private static String PassWord = "rootroot";
    private static Connection connection = null;

    public static Connection getConnection() {
        try {
            Class.forName(DriverClass);
            connection = DriverManager.getConnection(URL, UserName, PassWord);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }

    public static void closeResource() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        connection = DBConnectTool.getConnection();
        if (connection != null) {
            System.out.println("连接成功");
        } else {
            System.out.println("连接失败");
        }
        closeResource();
    }
}
