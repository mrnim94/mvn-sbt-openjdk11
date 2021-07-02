FROM maven:3.6-jdk-11

ENV MAVEN_CONFIG=/home/jenkins/.m2
COPY maven.sh /etc/profile.d/

##Install SBT 1.5.x
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get update
RUN apt-get install sbt

##you need to check groupadd and useradd in your system, if you build images on ci jenkins
##I use the Dockerfile on local
RUN mkdir -p /home/jenkins/.m2 \
    && mkdir -p //.cache \
    && groupadd -g 1102 docker \
    && useradd -g 1102 -u 400 -d /home/jenkins jenkins \
    && chown -R jenkins:docker /home/jenkins /usr/share/maven/ref && apt-get install unzip -y

RUN chmod -Rvc 777 /home/jenkins
RUN chown -R jenkins:docker //.cache
RUN chmod -Rvc 777 //.cache


USER jenkins:docker
WORKDIR /home/jenkins

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]