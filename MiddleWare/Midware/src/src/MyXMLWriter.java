package src;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.jdom2.input.sax.XMLReaders;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Scanner;

public class MyXMLWriter {
    public MyXMLWriter() throws IOException, JDOMException {
        String xmlPath = "src/data/MyStudentInfo.xml";
        Document document = new SAXBuilder(XMLReaders.NONVALIDATING).build(xmlPath);

        Element root = document.getRootElement();

        System.out.println("输入新成员信息：");
        Scanner scanner = new Scanner(System.in);
        System.out.println("stuNo:");
        String stuNo = scanner.nextLine();
        System.out.println("name:");
        String name = scanner.nextLine();
        System.out.println("gender:");
        String gender = scanner.nextLine();
        System.out.println("major:");
        String major = scanner.nextLine();

        Element newElement = new Element("student");
        Element element1 = new Element("stuNo");
        element1.setText(stuNo);
        Element element2 = new Element("name");
        element2.setText(name);
        Element element3 = new Element("gender");
        element3.setText(gender);
        Element element4 = new Element("major");
        element4.setText(major);

        root.addContent(newElement);
        newElement.addContent(element1);
        newElement.addContent(element2);
        newElement.addContent(element3);
        newElement.addContent(element4);

        XMLOutputter output = new XMLOutputter(Format.getPrettyFormat());
        output.output(document, new FileOutputStream(xmlPath));

    }

    public static void main(String[] args) throws IOException, JDOMException {
        new MyXMLWriter();
    }
}
