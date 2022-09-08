<%@ page contentType="text/HTML;charset=UTF-8"%>
<%
//接受表单数据
String username=request.getParameter("username");
String password=request.getParameter("password");

//把接受到的数据显示到页面上
out.print("您的用户名是："+username+"<br>");
out.print("您的密码是："+password);
%>