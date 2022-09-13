import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
@WebServlet("/servletTest")
public class servletTest extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws IOException, ServletException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=gb2312");

        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<body>");
        out.println("<head>");
        out.println("<title>Servlet 示例</title>");
        out.println("</head>");
        out.println("<body bgcolor=\"white\">");
        out.println("<h3>Servlet 示例</h3>");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username != null) {
            username = new String(username.getBytes("8859_1"), "gb2312");
        }
        out.println("<br>");
        if (username != null || password != null) {
            out.println("你的姓名是：");
            out.println(username + "<br>");
            out.println("你的密码是:");
            out.println(password);
        }
        out.print("<form action=");
        out.print("servletTest");
        out.println(" method=POST>");
        out.println("姓名");
        out.println("<input type=text size=20 name=username>");
        out.println("<br>");
        out.println("密码");
        out.println("<input type=password size=20 name=password>");
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