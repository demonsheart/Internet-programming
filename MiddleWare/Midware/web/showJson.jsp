<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="src.Student" %>

<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
    <title>JsonStr</title>
</head>
<body>
<%
    //数据库数据转换为JSON字符串
    String URL = "jdbc:mysql://localhost:3306/middle_final?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC";
    String DriverClass = "com.mysql.cj.jdbc.Driver";
    String UserName = "root";
    String PassWord = "rootroot";

    List<String> jsonStr = new ArrayList<>();
    try {
        Class.forName(DriverClass);
        Connection conn = DriverManager.getConnection(URL, UserName, PassWord);
        if (conn != null) {
            System.out.println("数据库连接成功");
            String query = "select * from tstudentinfo;";
            Statement stmt = conn.createStatement();
            ResultSet result = stmt.executeQuery(query);

            while (result.next()) {
                Student student = new Student();
                student.setStuNo(result.getString("stuNo"));
                student.setName(result.getString("name"));
                student.setGender(result.getString("gender"));
                student.setMajor(result.getString("major"));

                JSONObject jsonObj = JSONObject.fromObject(student);//由java类对象创建Json对象
                String str = jsonObj.toString();//将Json对象转为字符串
                jsonStr.add(str);
            }
        } else
            System.out.println("连接失败！");
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<table class="table table-success table-striped" style="margin:auto;max-width: max-content;">
    <thead>
    <tr>
        <th style="text-align: center">Json String</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (String str : jsonStr) {
            out.print("<tr><td>" + str + "<td></tr>");
        }
    %>
    </tbody>
</table>
</body>

</html>