package GrammarAnalysis;

import java.util.*;

public class NaryTreeNode<T> {
    private T val;
    private final List<NaryTreeNode<T>> children;

    public NaryTreeNode(T val) {
        this.val = val;
        children = new ArrayList<NaryTreeNode<T>>();
    }

    public void setVal(T val) {
        this.val = val;
    }

    public NaryTreeNode(T val, List<NaryTreeNode<T>> children) {
        this.val = val;
        if (children != null) this.children = children;
        else this.children = new ArrayList<NaryTreeNode<T>>();
    }

    public T getVal() {
        return val;
    }

    public List<NaryTreeNode<T>> getChildren() {
        return children;
    }

    public boolean isLeaf() {
        return children.isEmpty();
    }

    public boolean addChildNode(NaryTreeNode<T> node) {
        children.add(node);
        return true;
    }

    /**
     * 先序遍历：根左右
     * 利用栈模拟递归调用
     * 将根结点压入栈中，当栈不空时执行：
     * 弹出栈中结点，将其放入结果队列中
     * 将该结点的孩子按照倒序依次放入栈中
     */
    public List<T> preOrder() {
        Stack<NaryTreeNode<T>> stack = new Stack<>();
        LinkedList<T> pre = new LinkedList<>();
        stack.add(this);
        while (!stack.isEmpty()) {
            NaryTreeNode<T> node = stack.pop();
            pre.add(node.val);
            Stack<NaryTreeNode<T>> reChildren = new Stack<>();
            reChildren.addAll(node.children);
            while (!reChildren.isEmpty()) {
                stack.push(reChildren.pop());
            }

        }
        return pre;
    }

    // 先序遍历的叶子结点集合
    public List<T> preOrderLeaves() {
        Stack<NaryTreeNode<T>> stack = new Stack<>();
        LinkedList<T> pre = new LinkedList<>();
        stack.add(this);
        while (!stack.isEmpty()) {
            NaryTreeNode<T> node = stack.pop();
            if (node.isLeaf()) {
                pre.add(node.val);
            }
            Stack<NaryTreeNode<T>> reChildren = new Stack<>();
            reChildren.addAll(node.children);
            while (!reChildren.isEmpty()) {
                stack.push(reChildren.pop());
            }

        }
        return pre;
    }

    /**
     * 后序遍历：左右根
     * 利用栈模拟递归调用
     * 将根结点压入栈中，当栈不空时执行：
     * 弹出栈中结点，将其头插放入结果队列中
     * 将该结点的孩子依次放入栈中
     */

    public List<T> postOrder() {
        Stack<NaryTreeNode<T>> stack = new Stack<>();
        LinkedList<T> post = new LinkedList<>();
        stack.add(this);
        while (!stack.isEmpty()) {
            NaryTreeNode<T> node = stack.pop();
            post.addFirst(node.val);
            stack.addAll(node.children);
        }
        return post;
    }

    /**
     * 层次遍历：
     * 利用队列模拟递归调用
     * 将根结点压入队中，当队不空时执行：
     * 获取当前队列长度，当迭代次数小于当前队列长度时：
     * 弹出当前队头结点，将其放入当前层的结果队列中
     * 将该结点的孩子依次放入队列中
     * 将当前层的结果队列放入结果队列中
     */


    public List<List<T>> levelOrder() {
        List<List<T>> result = new ArrayList<>();
        Queue<NaryTreeNode<T>> queue = new LinkedList<>();
        queue.add(this);
        while (!queue.isEmpty()) {
            List<T> level = new ArrayList<>();
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                NaryTreeNode<T> node = queue.poll();
                level.add(node.val);
                queue.addAll(node.children);
            }
            result.add(level);
        }
        return result;
    }

}