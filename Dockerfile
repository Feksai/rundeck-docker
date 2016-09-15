FROM ubuntu:14.04.5


RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV RUNDECK_JARDIR=/opt/rundeck
ENV RUNDECK_BASEDIR=$RUNDECK_JARDIR/basedir


RUN mkdir -p $RUNDECK_JARDIR && \
    mkdir -p $RUNDECK_BASEDIR && \
    apt-get update && \
    apt-get install -y openjdk-7-jre wget

RUN wget -O $RUNDECK_JARDIR/app.jar http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-2.6.9.jar

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && \
    chmod +x /usr/local/bin/dumb-init

RUN useradd -r -u 202 -m -c "rundeck role account" -d ${RUNDECK_BASEDIR} -s /bin/bash rundeck && \
    chown rundeck:rundeck ${RUNDECK_BASEDIR}

COPY  run.sh ${RUNDECK_JARDIR}

VOLUME ${RUNDECK_BASEDIR}

USER rundeck

WORKDIR ${RUNDECK_JARDIR}

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["./run.sh"]


