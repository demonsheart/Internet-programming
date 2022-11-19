package jni;

public class Main {

    public static void main(String[] args) {
        System.load("/Users/aicoin/code/github/Study-Code/MiddleWare/EX4/src/jni/libDemo.dylib");

        Demo demo = new Demo();
        demo.sayHello(2, 3);
    }
}
