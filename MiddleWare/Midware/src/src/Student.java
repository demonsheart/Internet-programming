package src;

public class Student {
    String StuNo;
    String name;
    String gender;
    String major;

    public void setStuNo(String stuNo) {
        this.StuNo = stuNo;
    }

    public String getStuNo() {
        return StuNo;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getGender() {
        return gender;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getMajor() {
        return major;
    }

    public String toString() {
        return this.StuNo + " " + this.name + " " + this.gender + " " + this.major;
    }

    public static void main(String[] args) {

    }

}

