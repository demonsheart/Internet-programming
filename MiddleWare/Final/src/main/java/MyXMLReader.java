import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.jdom2.input.sax.XMLReaders;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MyXMLReader {
    public List<Student> getXML() {
        String xmlPath = "src/main/data/MyStudentInfo.xml";
        SAXBuilder builder = new SAXBuilder(XMLReaders.NONVALIDATING);

        try {
            Document document = builder.build(xmlPath);
            Element root = document.getRootElement();

            List<Element> students = root.getChildren("student");
            List<Student> result = new ArrayList<>();
            for (Element stu : students) {
                Student node = new Student();

                String id = stu.getChildTextTrim("stuNo");
                node.setStuNo(id);

                String name = stu.getChildTextTrim("name");
                node.setName(name);

                String gender = stu.getChildTextTrim("gender");
                node.setGender(gender);

                String major = stu.getChildTextTrim("major");
                node.setMajor(major);

                result.add(node);
            }
            return result;
        } catch (JDOMException | IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {

        MyXMLReader reader = new MyXMLReader();
        List<Student> list = reader.getXML();

        for (Student student : list) {
            //获取当前学生的所有信息
            String stuNo, name, gender, major;
            stuNo = student.getStuNo();
            name = student.getName();
            gender = student.getGender();
            major = student.getMajor();

            System.out.println(stuNo + " " + name + " " + gender + " " + major);
        }
    }
}
