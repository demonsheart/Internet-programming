import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.XMLOutputter;

public class JDomParse {
    public JDomParse() {
        String xmlpath = "src/main/resources/books.xml";
        SAXBuilder builder = new SAXBuilder(false);// 指定解析器
        int[] a = new int[5];
        int i;
        for (i = 0; i < 5; i++)
            a[i] = i + 1;
        i = 0;
        System.out.println("修改前:");
        try {
            Document doc = builder.build(xmlpath);   //得到Document对象
            Element root = doc.getRootElement();         //获取根元素
            List booklist = root.getChildren("Book");//得到数据项节点的集合，并把这些元素都放到一个List集合中。

            for (Iterator iter = booklist.iterator(); iter.hasNext(); ) //轮循List集合 输出修改前的信息
            {
                System.out.println("下面是第" + a[i++] + "本书的信息：");
                Element book = (Element) iter.next();
                // 依次取得数据项的具体值，并输出
                String BookID = book.getChildTextTrim("BookID");
                System.out.println("BookID:" + BookID);
                String name = book.getChildTextTrim("name");
                System.out.println("name:" + name);
                String price = book.getChildTextTrim("price");
                System.out.println("price:" + price);
                if (name.equals("Lincon"))//修改元素（为最低层元素）的值：
                    book.getChild("price").setText("30.5");
            }

            //添加一本书的信息
            // 创建一个新节点
            Element newElement = new Element("Book");
            // 在新节点下创建子节点
            Element OneElement = new Element("BookID");
            OneElement.setText("5");
            Element TwoElement = new Element("name");
            TwoElement.setText("中间件技术");
            Element ThreeElement = new Element("price");
            ThreeElement.setText("39.0");
            //上一个节点要包含子节点。
            root.addContent(newElement);
            newElement.addContent(OneElement);
            newElement.addContent(TwoElement);
            newElement.addContent(ThreeElement);

            //保存Document的修改到XML文件中
            XMLOutputter outputter = new XMLOutputter();
            outputter.output(doc, new FileOutputStream(xmlpath));
        } catch (JDOMException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println();
        System.out.println("修改后:");
        i = 0;
        try {
            Document doc = builder.build(xmlpath);   //得到Document对象
            Element root = doc.getRootElement();         //获取根元素
            List booklist = root.getChildren("Book");///得到数据项节点的集合，并把这些元素都放到一个List集合中。

            for (Iterator iter = booklist.iterator(); iter.hasNext(); ) //轮循List集合 输出修改后的信息
            {
                System.out.println("下面是第" + a[i++] + "本书的信息：");
                Element book = (Element) iter.next();
                // 依次取得数据项的具体值，并输出
                String BookID = book.getChildTextTrim("BookID");
                System.out.println("BookID:" + BookID);
                String name = book.getChildTextTrim("name");
                System.out.println("name:" + name);
                String price = book.getChildTextTrim("price");
                System.out.println("price:" + price);
            }
        } catch (JDOMException | IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        new JDomParse();
    }
}
