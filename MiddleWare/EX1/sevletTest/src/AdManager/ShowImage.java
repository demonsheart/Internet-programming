package AdManager;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/showImage")
public class ShowImage extends HttpServlet{
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws IOException, ServletException {
        try {
            String id=request.getParameter("id");
            Connection conn = DBConnectTool.getConnection();
            String sql = "select type,file from banner where id="+id;
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(sql);
            InputStream in=null;

            if(rs.next())
                in=rs.getBinaryStream("file");
            response.setContentType(rs.getString("type"));
            ServletOutputStream sout=response.getOutputStream();
            byte b[]=new byte[1024];

            while(in.read(b)!=-1){
                sout.write(b);
            }
            sout.flush();
            sout.close();

            rs.close();
            stmt.close();
            conn.close();
        } catch(Exception e){
            e.printStackTrace();
        }
    }
    public void doPost(HttpServletRequest request,
                       HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);
    }
}
