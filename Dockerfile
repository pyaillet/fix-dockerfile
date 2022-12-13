FROM maven:3-openjdk-11

RUN apt-get update && \
    apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV TOMCAT_MAJOR_VERSION 10
ENV TOMCAT_MINOR_VERSION 10.1.4
ENV CATALINA_HOME /tomcat

RUN wget -q https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz
RUN wget -qO- https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.sha512 | sha512sum -c
RUN tar zxf apache-tomcat-*.tar.gz && \
 	rm apache-tomcat-*.tar.gz && \
 	mv apache-tomcat* tomcat

RUN mkdir -p /etc/service/tomcat

ADD . /app
WORKDIR /app

RUN mvn package

RUN cp /app/target/demo-0.0.1-SNAPSHOT.war /tomcat/webapps/demo.war

EXPOSE 8080

CMD ["/tomcat/bin/catalina.sh", "run"]
