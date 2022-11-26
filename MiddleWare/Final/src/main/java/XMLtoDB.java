import java.util.List;
import java.sql.*;

public class XMLtoDB {
    public static void main(String[] args) {
        try {
            MyXMLReader reader = new MyXMLReader();
            List<Student> list = reader.getXML();//获取XML中的所有学生

            if (list != null) {
                //连接数据库
                //看jdbc版本决定是否注释Class.forName()
                //Class.forName(com.mysql.jdbc.Driver);
                String url = "jdbc:mysql://localhost/test";
                String username = "root";
                String password = "123456";
                Connection conn = DriverManager.getConnection(url, username, password);
                String sql = "insert ignore into TstudentInfo (stuNo,name,gender,major) values(?,?,?,?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);

                //遍历列表中的所有学生
                for (Student student : list) {
                    //获取当前学生的所有信息
                    String stuNo, name, gender, major;
                    stuNo = student.getStuNo();
                    name = student.getName();
                    gender = student.getGender();
                    major = student.getMajor();

                    pstmt.setString(1, stuNo);
                    pstmt.setString(2, name);
                    pstmt.setString(3, gender);
                    pstmt.setString(4, major);
                    pstmt.executeUpdate();
                    System.out.println("学生信息已上传到数据库");
                }
                pstmt.close();
                conn.close();
            } else {
                System.out.println("获取学生信息失败");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
