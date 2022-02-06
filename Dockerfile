#指定以openjdk:8-jre-alpine为基础镜像，来构建此镜像
FROM openjdk:8-jdk-alpine
# 默认jar包的名字
ARG JAR_FILE=target/unit-testing-0.0.1-SNAPSHOT.jar
# RUN用于容器内部执行命令
RUN mkdir -p /usr/local/project
# 指定容器的目录，容器启动时执行的命令会在该目录下执行
WORKDIR /usr/local/project
# 将项目jar包复制到/usr/local/project目录下
COPY ${JAR_FILE} ./
# 暴露容器端口为50051 Docker镜像告知Docker宿主机应用监听了50051端口
EXPOSE 50051
#容器启动时执行的命令
CMD java -jar -Dserver.port=50051 ${JAR_FILE}


