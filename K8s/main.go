package main

import (
	"context"
	"flag"
	"fmt"
	"github.com/gin-gonic/gin"
	appsv1 "k8s.io/api/apps/v1"
	apiv1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
	"k8s.io/utils/pointer"
	"net/http"
	"path/filepath"
	"strconv"
)

const (
	NAMESPACE       = "default"
	PodName         = "go-test"
	DEPLOYMENT_NAME = "client-test-deployment"
	SERVICE_NAME    = "client-test-service"
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

	flag.Parse()

	// 从本机加载kubeConfig配置文件，因此第一个参数为空字符串
	config, err := clientcmd.BuildConfigFromFlags("", *kubeConfig)

	// kubeConfig加载失败就直接退出了
	if err != nil {
		fmt.Errorf(err.Error())
	}

	// 实例化clientSet对象
	clientSet, err := kubernetes.NewForConfig(config)

	if err != nil {
		fmt.Errorf(err.Error())
	}

	r := gin.Default()
	r.LoadHTMLGlob("html/*")
	//str, _ := os.Getwd()
	//fmt.Println(str)
	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", nil)
	})
	r.GET("/getnodes", func(c *gin.Context) {
		nodes, err := getNode(clientSet)
		if(err!=nil){
			c.String(http.StatusOK, "Error")
		}
		c.HTML(http.StatusOK, "getnode.html", nodes.Items)
	})
	r.GET("/createpod", func(c *gin.Context) {
		c.HTML(http.StatusOK, "pod.html", nil)
	})
	r.POST("/createpod", func(c *gin.Context) {
		image := c.DefaultPostForm("image", "nginx")
		name := c.DefaultPostForm("name", "test")
		nodeName := c.DefaultPostForm("node", "minikube-m03")
		res, err := createPod(clientSet, nodeName, name, image)
		if err != nil {
			c.String(http.StatusOK, fmt.Sprintf("Create Fail !"))
		} else {
			c.String(http.StatusOK, fmt.Sprintf("Create Pod %s!", res.GetName()))
		}
	})
	r.GET("/getpods", func(c *gin.Context) {
		pods, err := getPod(clientSet)
		if(err!=nil){
			c.String(http.StatusOK, "Error")
		}
		c.HTML(http.StatusOK, "getpod.html", pods.Items)
	})
	r.GET("/createdep", func(c *gin.Context) {
		c.HTML(http.StatusOK, "dep.html", nil)
	})
	r.POST("/createdep", func(c *gin.Context) {
		image := c.DefaultPostForm("image", "nginx")
		name := c.DefaultPostForm("name", "test")
		nodeName := c.DefaultPostForm("node", "minikube-m03")
		replicas,_ := strconv.Atoi(c.DefaultPostForm("replicas","1"));
		res, err := createDeployment(clientSet, nodeName, name, image,int32(replicas))
		if err != nil {
			c.String(http.StatusOK, fmt.Sprintf("Create Fail !"))
		} else {
			c.String(http.StatusOK, fmt.Sprintf("Create Deployment %s!", res.GetName()))
		}
	})
	r.GET("/getdeps", func(c *gin.Context) {
		deployments, err := getDep(clientSet)
		if(err!=nil){
			c.String(http.StatusOK, "Error")
		}
		c.HTML(http.StatusOK, "getdep.html", deployments.Items)
	})
	r.GET("/createsvc", func(c *gin.Context) {
		c.HTML(http.StatusOK, "svc.html", nil)
	})
	r.POST("/createsvc", func(c *gin.Context) {
		name := c.DefaultPostForm("name", "test")
		port, _ := (strconv.Atoi(c.DefaultPostForm("port", "80")))
		targetport, _ := strconv.Atoi(c.DefaultPostForm("targetport", "30080"))
		res,err :=createService(clientSet,name,int32(port),int32(targetport))
		if err != nil {
			c.String(http.StatusOK, fmt.Sprintf("Create Fail !"))
		} else {
			c.String(http.StatusOK, fmt.Sprintf("Create Service %s!", res.GetName()))
		}
	})
	r.GET("/getsvcs", func(c *gin.Context) {
		svcs, err := getService(clientSet)
		if(err!=nil){
			c.String(http.StatusOK, "Error")
		}
		c.HTML(http.StatusOK, "getsvc.html", svcs.Items)
	})
	r.GET("/clean", func(c *gin.Context) {
		clean(clientSet)
		c.String(http.StatusOK, "clean ok!")
	})
	r.Run(":8000")

}

func getNode(clientSet *kubernetes.Clientset)  (*apiv1.NodeList, error){
	nodeClient := clientSet.CoreV1().Nodes()
	nodes, err :=nodeClient.List(context.TODO(),metav1.ListOptions{})
	if(err!=nil){
		fmt.Errorf(err.Error())
	}
	return nodes,err
}

func getDep(clientSet *kubernetes.Clientset)  (*appsv1.DeploymentList, error){
	deploymentClient := clientSet.AppsV1().Deployments(NAMESPACE)
	deployments, err :=deploymentClient.List(context.TODO(),metav1.ListOptions{})
	if(err!=nil){
		fmt.Errorf(err.Error())
	}
	return deployments,err
}

func getPod(clientSet *kubernetes.Clientset)  (*apiv1.PodList, error){
	podClient := clientSet.CoreV1().Pods(NAMESPACE)
	pods, err :=podClient.List(context.TODO(),metav1.ListOptions{})
	if(err!=nil){
		fmt.Errorf(err.Error())
	}
	return pods,err
}

func getService(clientSet *kubernetes.Clientset)  (*apiv1.ServiceList, error){
	svcClient := clientSet.CoreV1().Services(NAMESPACE)
	svcs, err :=svcClient.List(context.TODO(),metav1.ListOptions{})
	if(err!=nil){
		fmt.Errorf(err.Error())
	}
	return svcs,err
}

func clean(clientSet *kubernetes.Clientset) {
	emptyDeleteOptions := metav1.DeleteOptions{}
	if err := clientSet.CoreV1().Pods(NAMESPACE).Delete(context.TODO(), PodName, emptyDeleteOptions); err != nil {
		fmt.Errorf(err.Error())
	}
}

func createPod(clientSet *kubernetes.Clientset, nodeName string, name string, image string) (*apiv1.Pod, error) {
	podClient := clientSet.CoreV1().Pods(NAMESPACE)
	pod := &apiv1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		Spec: apiv1.PodSpec{
			NodeName: nodeName,
			Containers: []apiv1.Container{
				{
					Name:            name,
					Image:           image,
					ImagePullPolicy: "IfNotPresent",
				},
			},
		},
	}
	res, err := podClient.Create(context.TODO(), pod, metav1.CreateOptions{})

	if err != nil {
		fmt.Errorf(err.Error())
	}
	fmt.Printf("Create Pod %s \n", res.GetName())
	return res, err
}

func createDeployment(clientSet *kubernetes.Clientset, nodeName string, name string, image string,replicas int32) (*appsv1.Deployment, error) {
	deploymentClient := clientSet.AppsV1().Deployments(NAMESPACE)
	deployment := &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		Spec: appsv1.DeploymentSpec{
			Replicas: pointer.Int32(1),
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"app": "nginx",
				},
			},
			Template: apiv1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						"app": "nginx",
					},
				},
				Spec: apiv1.PodSpec{
					NodeName: nodeName,
					Containers: []apiv1.Container{
						{
							Name:            name,
							Image:           image,
							ImagePullPolicy: "IfNotPresent",
							Ports: []apiv1.ContainerPort{
								{
									Name:          "http",
									Protocol:      "TCP",
									ContainerPort: 80,
								},
							},
						},
					},
				},
			},
		},
	}
	result, err := deploymentClient.Create(context.TODO(), deployment, metav1.CreateOptions{})
	if err != nil {
		fmt.Errorf(err.Error())
	}
	fmt.Printf("Create Deployment %s \n", result.GetName())
	return result, err
}

func createService(clientset *kubernetes.Clientset, name string, port int32, targetport int32)(*apiv1.Service, error) {
	serviceClient := clientset.CoreV1().Services(NAMESPACE)
	service := &apiv1.Service{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		Spec: apiv1.ServiceSpec{
			Ports: []apiv1.ServicePort{{
				Name:     "http",
				Port:     port,
				NodePort: targetport,
			},
			},
			Selector: map[string]string{
				"app": "nginx",
			},
			Type: apiv1.ServiceTypeNodePort,
		},
	}
	result, err := serviceClient.Create(context.TODO(), service, metav1.CreateOptions{})
	if err != nil {
		fmt.Errorf(err.Error())
	}
	fmt.Printf("Create Service %s \n", result.GetName())
	return result,err
}
