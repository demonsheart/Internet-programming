import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class JSONtoJavaTest {
    //java对象转换为JSON字符串
    public static void javaObjToJSONStr() {
        Student f = new Student();
        f.setName("方依依");
        f.setAge(19);
        JSONObject jsonObj = JSONObject.fromObject(f);
        String jsonStr = jsonObj.toString();
        System.out.println(jsonStr);
    }

    //java数组转换为JSON字符串
    public static void javaArrToJSONStr() {
        List<Student> fs = new ArrayList<>();

        Student f = new Student();
        f.setName("刘万权");
        f.setAge(22);
        f.setStuNo("2019151060");
        fs.add(f);

        Student f1 = new Student();
        f1.setName("黄荣峰");
        f1.setAge(21);
        f.setStuNo("2019151067");
        fs.add(f1);

        Student f2 = new Student();
        f2.setName("张纹彬");
        f2.setAge(21);
        f.setStuNo("2019151066");
        fs.add(f2);

        JSONArray jsonArr = JSONArray.fromObject(fs);
        String jsonStr = jsonArr.toString();
        System.out.println(jsonStr);
    }

    //JSON字符串转换为java对象
    public static void jsonStrToJavaObj() {
        String jsonStr = "{'name':'方依依','age':17}";
        JSONObject jsonObj = JSONObject.fromObject(jsonStr);
        Student student = (Student) JSONObject.toBean(jsonObj, Student.class);
        System.out.println(student);
    }

    //JSON字符串转换为java数组
    public static void jsonStrToJavaArray() {
        String jsonStr = "[{'stuNo':20170031, 'name':'何立立'}, {'stuNo':20170032, 'name':'赵多多'}]";
        JSONArray jsonArr = JSONArray.fromObject(jsonStr);
        List<Student> students = (List<Student>) JSONArray.toCollection(jsonArr, Student.class);
        for (Student f : students) {
            System.out.println(f);
        }
    }

    public static void main(String[] args) {
        javaObjToJSONStr();
        javaArrToJSONStr();
        jsonStrToJavaObj();
        jsonStrToJavaArray();
    }
}
