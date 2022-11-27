### 中间件大作业

1. 创建和编辑XML文件：将源数据文件（数据库系统成绩登记表.xlsx）中的学号、姓名、性别和主修专业数据信息存储在一个名为MySudentInfo.xml的xml文件中，并将你们项目组成员的相应信息也添加进去。
2. 创建和编写JSON数据文件：将源数据文件（数据库系统成绩登记表.xlsx）中的学号、姓名、性别和主修专业数据信息存储在一个名为MySudentInfo.json的JSON文件中。
3. 定义java对象数据类型：用java编写一个Student类，用于保存和描述学生对象，含学号、姓名、性别和主修专业属性信息及其操作。
4. 解析和修改XML文件：用java编写一个MyXMLReader类从MySudentInfo.xml读出信息，编写一个MyXMLWriter类向MySudentInfo.xml添加写入项目组所有成员的学号、姓名、性别和主修专业信息。必要时可以借助Student类对象。
5. XML->DB数据转换：关系数据库（可自行选用MySQL等数据库都可以）中创建一个空表名TstudentInfo，数据库名自行创建。编写一个XMLtoDB数据转换类，负责使用MyXMLReader类从MySudentInfo.xml中读出所有学生数据信息，写入数据库TstudentInfo中。必要时可以借助Student类对象。
6. DB->JSON数据转换：创建JSP页面，在JSP页面中显示出从TstudentInfo数据库表中读出的学生信息，学生信息数据在网页上以JSON字符串的方式显示。必要时可以借助Student类对象，根据需要选择是否创建和使用js或servlet。自行选择使用应用服务器中间件部署
