package main

import (
	"context"
	"flag"
	"fmt"
	apiv1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
	"path/filepath"
)

const (
	NAMESPACE = "default"
	PodName   = "go-test"
)

// https://xinchen.blog.csdn.net/article/details/113788269 参考
// https://github.com/kubernetes/client-go/tree/master/examples/in-cluster-client-configuration
// https://kubernetes.io/zh-cn/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins 用户身份验证
func main() {

	var kubeConfig *string

	// home是家目录，如果能取得家目录的值，就可以用来做默认值
	if home := homedir.HomeDir(); home != "" {
		// 如果输入了kubeConfig参数，该参数的值就是kubeConfig文件的绝对路径，
		// 如果没有输入kubeConfig参数，就用默认路径~/.kube/config
		kubeConfig = flag.String("kubeConfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeConfig file")
	} else {
		// 如果取不到当前用户的家目录，就没办法设置kubeConfig的默认目录了，只能从入参中取
		kubeConfig = flag.String("kubeConfig", "", "absolute path to the kubeConfig file")
	}

	// 获取用户输入的操作类型，默认是create，还可以输入clean，用于清理所有资源
	operate := flag.String("operate", "create", "operate type : create or clean")

	flag.Parse()

	// 从本机加载kubeConfig配置文件，因此第一个参数为空字符串
	config, err := clientcmd.BuildConfigFromFlags("", *kubeConfig)

	// kubeConfig加载失败就直接退出了
	if err != nil {
		panic(err.Error())
	}

	// 实例化clientSet对象
	clientSet, err := kubernetes.NewForConfig(config)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("operation is %v\n", *operate)

	// 如果要执行清理操作
	if "clean" == *operate {
		clean(clientSet)
	} else {
		// 创建pod
		createPod(clientSet)
	}
}

// 清理本次实战创建的所有资源
func clean(clientSet *kubernetes.Clientset) {
	emptyDeleteOptions := metav1.DeleteOptions{}

	// 删除pod
	if err := clientSet.CoreV1().Pods(NAMESPACE).Delete(context.TODO(), PodName, emptyDeleteOptions); err != nil {
		panic(err.Error())
	}
}

// 新建pod
func createPod(clientSet *kubernetes.Clientset) {
	// 获取podClient操作对象
	podClient := clientSet.CoreV1().Pods(NAMESPACE)
	// 新建一个pod示例 里面包含各种配置参数
	pod := &apiv1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name: PodName,
		},
		Spec: apiv1.PodSpec{
			NodeName: "minikube-m03", // TODO 关联的NodeName 根据HTTP请求传入
			Containers: []apiv1.Container{
				{
					Name:            "tomcat",
					Image:           "tomcat:8.0.18-jre8",
					ImagePullPolicy: "IfNotPresent",
				},
			},
		},
	}
	// 发起一个Create请求
	res, err := podClient.Create(context.TODO(), pod, metav1.CreateOptions{})

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("Create deployment %s \n", res.GetName())
}
