FROM ubuntu:14.04.5

ENV BUILD_PACKAGES \
  debconf \
  debconf-utils \
  wget

RUN apt-get update \
    && apt-get install -y $BUILD_PACKAGES

# Reconfigure locales
RUN locale-gen en_US.UTF-8 && \
    echo "locales locales/locales_to_be_generated  multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale  select en_US.UTF-8" | debconf-set-selections && \
    dpkg-reconfigure --frontend noninteractive locales

# Set default locale vars | Fill /etc/default/locale
RUN update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN apt-get install -y openjdk-7-jre && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV RUNDECK_JARDIR=/opt/rundeck
ENV RUNDECK_BASEDIR=$RUNDECK_JARDIR/basedir

RUN mkdir -p $RUNDECK_JARDIR && \
    mkdir -p $RUNDECK_BASEDIR && \
    wget -O $RUNDECK_JARDIR/app.jar http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-2.7.1.jar && \
    wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init

RUN useradd -r -u 202 -m -c "rundeck role account" -d ${RUNDECK_BASEDIR} -s /bin/bash rundeck && \
    chown rundeck:rundeck ${RUNDECK_BASEDIR}

COPY  run.sh ${RUNDECK_JARDIR}

VOLUME ${RUNDECK_BASEDIR}

USER rundeck

WORKDIR ${RUNDECK_JARDIR}

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["./run.sh"]


