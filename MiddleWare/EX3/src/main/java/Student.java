public class Student {
    private String name;
    private int age;
    private String stuNo;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getStuNo() {
        return stuNo;
    }

    public void setStuNo(String stuNo) {
        this.stuNo = stuNo;
    }

    public String toString() {
        if (this.age == 0)
            return this.name + " " + this.stuNo;
        return this.name + " " + this.age;
    }
}
