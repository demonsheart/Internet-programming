package AdManager;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/addBanner")
public class AddBanner extends HttpServlet {
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws IOException, ServletException {
        //response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=gb2312");

        PrintWriter out = response.getWriter();
        try {
            ParseRequest pf = new ParseRequest();
            Vector v = pf.getFormData(request);
            FormData fd;
            String link = "";
            String contentType = "";
            byte[] image = null;

            Enumeration e = v.elements();
            while (e.hasMoreElements()) {
                fd = (FormData) e.nextElement();
                if (fd.name.equals("link")) {
                    link = fd.value;
                    continue;
                } else if (fd.name.equals("image")) {
                    contentType = fd.contentType;
                    image = fd.file;
                }
            }
            if (!link.equals("") && !contentType.equals("") && image != null)
            {
                Connection conn = DBConnectTool.getConnection();
                String sql = "insert into banner(link,type,file) values(?,?,?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, link);
                pstmt.setString(2, contentType);
                pstmt.setBytes(3, image);
                pstmt.executeUpdate();
                pstmt.close();
                conn.close();
                out.println("连接和图片已记录数据库");
            } else {
                out.println("数据不完整，请重新输入");
            }
        } catch (NullPointerException npe){
        }catch(Exception e){
            System.err.println(e);
            e.printStackTrace();
        }
        out.println("<html>");
        out.println("<body>");
        out.println("<head>");
        out.println("</head>");
        out.println("<body bgcolor=\"white\">");
        out.println("<h3>上传图片</h3>");
        out.print("<form action=");
        out.print("addBanner");
        out.println(" method=POST enctype='multipart/form-data'>");
        out.println("连接");
        out.println("<input type=text size=20 name=link>");
        out.println("<br>");
        out.println("图片");
        out.println("<input type=file size=20 name=image>");
        out.println("<br>");
        out.println("<input type=submit value='提交'>");
        out.println("</form>");
        out.println("</body>");
        out.println("</html>");
    }
    public void doPost(HttpServletRequest request,
                       HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);
    }
}

