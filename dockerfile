FROM ubuntu
MAINTAINER naga <naga5856@gmail.com>
#Let people know how this was built
#COPY Dockerfile /root/Dockerfile
#Add a java repo and java install
RUN apt-get update && apt-get install -y curl wget
COPY jdk-8u191-linux-x64.tar.gz /tmp
WORKDIR /tmp
RUN tar -xvzf jdk-8u191-linux-x64.tar.gz
ENV JAVA_HOME /tmp/jdk1.8.0_191
ENV PATH $PATH:$JAVA_HOME/bin
RUN `mkdir -p /opt/tomcat`
WORKDIR /opt/tomcat
COPY apache-tomcat-8.5.37.tar.gz /opt/tomcat
RUN tar -xvzf /opt/tomcat/apache-tomcat-8.5.37.tar.gz --strip-components=1
EXPOSE 8080
WORKDIR /opt/tomcat/bin
CMD ["./catalina.sh", "run"]
