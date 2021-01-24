FROM openshift/base-centos7

LABEL maintainer="Jacek Stańczyk <216890@edu.p.lodz.pl>"

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="Platform for microservices developed using gradle and spring boot" \
      io.k8s.display-name="Spring Boot Gradle" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,spring,java,boot,gradle"


RUN yum install -y java-11-openjdk-devel && \
    yum clean all -y

RUN wget https://services.gradle.org/distributions/gradle-6.3-bin.zip -P /tmp && \
    unzip -d /opt /tmp/gradle-6.3-bin.zip && \
    rm /tmp/gradle-6.3-bin.zip && \
    ln -sf /opt/gradle-6.3/bin/gradle /usr/local/bin/gradle

RUN mkdir -p /opt/openshift

ENV PATH=/usr/local/bin/gradle:$PATH

RUN chown -R 1001:1001 /opt/openshift /opt/app-root
RUN chmod -R 777 /opt/openshift /opt/app-root

COPY ./s2i/bin/ /usr/libexec/s2i
RUN chmod -R 777 /usr/libexec/s2i

USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
