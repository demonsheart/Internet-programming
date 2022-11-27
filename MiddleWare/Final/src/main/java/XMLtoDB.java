import java.util.List;
import java.sql.*;

public class XMLtoDB {
    public static void main(String[] args) {
        try {
            MyXMLReader reader = new MyXMLReader();
            List<Student> list = reader.getXML();//获取XML中的所有学生

            if (list != null) {
                //连接数据库
                Connection conn = DBConnectTool.getConnection();
                String sql = "insert ignore into TstudentInfo (stuNo,name,gender,major) values(?,?,?,?)";
                PreparedStatement stmt = conn.prepareStatement(sql);

                //遍历列表中的所有学生
                for (Student student : list) {
                    //获取当前学生的所有信息
                    String stuNo, name, gender, major;
                    stuNo = student.getStuNo();
                    name = student.getName();
                    gender = student.getGender();
                    major = student.getMajor();

                    stmt.setString(1, stuNo);
                    stmt.setString(2, name);
                    stmt.setString(3, gender);
                    stmt.setString(4, major);
                    stmt.executeUpdate();
                    System.out.println("学生信息已上传到数据库");
                }
                stmt.close();
                conn.close();
            } else {
                System.out.println("获取学生信息失败");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
