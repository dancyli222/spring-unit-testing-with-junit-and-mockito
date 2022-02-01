#指定以openjdk:8-jre-alpine为基础镜像，来构建此镜像
FROM openjdk:8-jdk-alpine
#指定容器的目录，容器启动时执行的命令会在该目录下执行
WORKDIR /
#将应用的jar包复制到容器根目录下
ADD target/*.jar unit-test.jar
#暴露容器端口为50051 Docker镜像告知Docker宿主机应用监听了50051端口
EXPOSE 50051
#容器启动时执行的命令
ENTRYPOINT ["java","-jar","/unit-test.jar"]


