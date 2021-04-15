FROM jenkins/jenkins:2.288-alpine


ARG ADMIN_USER
ARG ADMIN_PASS

#ENV JENKINS_USER
#ENV JENKINS_PASS
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# Install plugins needed
COPY plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# Copy initialization groovy scripts
COPY groovy/*.groovy /usr/share/jenkins/ref/init.groovy.d/
# Copy job definitions where the seed job script expects it
RUN mkdir $JENKINS_HOME/job-dsl-scripts/
COPY jobs/*.groovy $JENKINS_HOME/job-dsl-scripts/

# Install required dependencies and compile plugin from source until it is not published
# we cannot rely on Jenkins update center to fetch it
USER root
RUN apk update && \
    apk add maven

RUN cd /tmp && \
    git clone https://github.com/CheckPointSW-Community/jenkins-plugin-cloudguard-shiftleft.git && \
    cd jenkins-plugin-cloudguard-shiftleft && \
    mvn clean package

RUN cp /tmp/jenkins-plugin-cloudguard-shiftleft/target/cloudguard-shiftleft.hpi \
        /usr/share/jenkins/ref/plugins && \
    chgrp jenkins /usr/share/jenkins/ref/plugins/cloudguard-shiftleft.hpi && \
    chmod 644 /usr/share/jenkins/ref/plugins/cloudguard-shiftleft.hpi

# Install Shiftleft
RUN wget https://shiftleft-prod.s3.amazonaws.com/blades/shiftleft/bin/linux/amd64/0.0.29/shiftleft && \
    chmod +x shiftleft && \
    mv shiftleft /usr/local/bin

USER jenkins
