package AdManager;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/showBanner")
public class ShowBanner extends HttpServlet{
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws IOException, ServletException {
        try {
            Connection conn = DBConnectTool.getConnection();
            String sql = "select id,link from banner where link!='' and type!='' and file!=''";
            Statement stmt=conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            //Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(sql);
            rs.last();

            Random r=new Random();
            int selectedbanner=Math.abs((r.nextInt())%(rs.getRow()));
            int i=0;
            int id=0;
            String link="";

            rs.absolute(1);
            while (true){
                if(selectedbanner==i++){
                    id=rs.getInt("id");
                    link=rs.getString("link");
                    break;
                }
                rs.next();
            }
            rs.close();
            stmt.close();
            conn.close();
            response.setContentType("text/html;charset=gb2312");
            PrintWriter out=response.getWriter();
            out.println("<a href='"+link+"'><img border=0 src='showImage?id="+id+"'></a>");
        } catch(Exception e){
            e.printStackTrace();
        }
    }
    public void doPost(HttpServletRequest request,
                       HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);
    }
}
