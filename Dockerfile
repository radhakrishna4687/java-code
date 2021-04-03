FROM ubuntu:20.10
LABEL maintainer="krishna4687@gmail.com"
ENV TOMCAT_VERSION=8.5.50
USER root

# Install OpenJDK-8
RUN apt-get update &&  apt-get upgrade -y &&\
    apt-get install -y apt-file && \
    apt-file update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y wget && \
    apt-get install -y maven && \
    apt-get install -y git && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Setup JAVA_HOME -- useful for docker commandline
ENV M2_HOME /usr/share/maven/
RUN export M2_HOME

#Make dir in /usr/local/tomcat
RUN mkdir -pv /usr/local/tomcat/
CMD [ "chmod ugo+rwx /usr/local/tomcat/" ]
#Install tomcat8
RUN wget --quiet --no-cookies https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz
#wget curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz -O /tmp/tomcat.tar.gz
#http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz -O /tmp/tomcat.tar.gz 
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.50/* /usr/local/tomcat/
# Add admin/admin user
#ADD tomcat-users.xml /usr/local/tomcat/conf/

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
#VOLUME "/opt/tomcat/webapps"
WORKDIR  /usr/local/tomcat
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run"] 
#/usr/local/tomcat/bin/catalina.sh run
#CMD ["/bin/bash"]

# Download the code form github 
RUN apt-get update && \ 
    mkdir -pv /home/samplecode && \
    cd /home/samplecode && \
    git clone https://github.com/radhakrishna4687/java-code.git
WORKDIR /home/samplecode    

# maven pacakage for war file
RUN java -version
WORKDIR /home/samplecode/java-code/
RUN mvn --version
RUN mvn clean 
RUN mvn package

#Afetr crating the package deployed into tomcat server
COPY /home/samplecode/java-code/target/*.war /usr/local/tomcat/webapps