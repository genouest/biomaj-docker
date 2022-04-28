FROM quay.io/osallou/debian:buster

WORKDIR /root
ENV BIOMAJ_CONFIG=/root/config.yml
ENV prometheus_multiproc_dir=/tmp/biomaj-prometheus-multiproc

RUN rm -rf /tmp/biomaj-prometheus-multiproc
RUN mkdir -p /tmp/biomaj-prometheus-multiproc

RUN apt-get update && apt-get install -y apt-transport-https curl libcurl4-openssl-dev python3-pycurl python3-setuptools python3-pip git unzip bzip2 ca-certificates jq --no-install-recommends

# Install docker to allow docker execution from process-message
RUN buildDeps='gnupg2 dirmngr software-properties-common' \
    && set -x \
    && apt-get install -y $buildDeps --no-install-recommends \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get purge -y --auto-remove $buildDeps

ENV BIOMAJ_RELEASE="shahikorma-v12"

RUN git clone https://github.com/genouest/biomaj-core.git
#RUN easy_install3 pip
RUN pip3 install setuptools --upgrade

RUN git clone https://github.com/genouest/biomaj-zipkin.git

RUN git clone https://github.com/genouest/biomaj-user.git

RUN git clone https://github.com/genouest/biomaj-cli.git

RUN git clone https://github.com/genouest/biomaj-process.git

RUN git clone https://github.com/genouest/biomaj-download.git

RUN git clone  https://github.com/genouest/biomaj.git && echo "Install biomaj"

RUN git clone https://github.com/genouest/biomaj-daemon.git && echo "Install daemon"

RUN git clone https://github.com/genouest/biomaj-watcher.git && echo "Install biomaj-watcher"

RUN git clone https://github.com/genouest/biomaj-ftp.git

RUN git clone https://github.com/genouest/biomaj-release.git

RUN git clone https://github.com/genouest/biomaj-data.git

ENV BIOMAJ_CONFIG=/etc/biomaj/config.yml

RUN mkdir -p /var/log/biomaj

RUN pip3 install gevent==1.4.0
RUN pip3 install graypy
RUN pip3 install pymongo==3.12.3

ENV SUDO_FORCE_REMOVE=yes
RUN buildDeps='gcc python3-dev protobuf-compiler' \
    && set -x \
    && apt-get install -y $buildDeps --no-install-recommends \
    && cd /root/biomaj-core && python3 setup.py install \
    && cd /root/biomaj-zipkin && python3 setup.py install \
    && cd /root/biomaj-user && python3 setup.py install \
    && cd /root/biomaj-cli && python3 setup.py install \
    && cd /root/biomaj-process/biomaj_process/message && protoc --python_out=. procmessage.proto \
    && cd /root/biomaj-process && python3 setup.py install \
    && cd /root/biomaj-download/biomaj_download/message && protoc --python_out=. downmessage.proto \
    && cd /root/biomaj-download && python3 setup.py install \
    && cd /root/biomaj && python3 setup.py install \
    && cd /root/biomaj-daemon && python3 setup.py install \
    && cd /root/biomaj-watcher && python3 setup.py develop \
    && cd /root/biomaj-ftp && python3 setup.py install \
    && cd /root/biomaj-release && python3 setup.py install \
    && cd /root/biomaj-data && python3 setup.py install \
    && pip3 install gunicorn \
    && apt-get install -y wget bzip2 ca-certificates curl git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove $buildDeps



#RUN apt-get update --fix-missing && \
#    apt-get install -y wget bzip2 ca-certificates curl git && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*


#Conda installation and give write permissions to conda folder
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh &&  \
    /opt/conda/bin/conda config --add channels r  && \
    /opt/conda/bin/conda config --add channels bioconda  && \
    /opt/conda/bin/conda upgrade -y conda  && \
    chmod 777 -R /opt/conda/
    


RUN mkdir /data /config

ENV PATH=$PATH:/opt/conda/bin

#RUN conda config --add channels r
#RUN conda config --add channels bioconda
#RUN conda upgrade -y conda

VOLUME ["/data", "/config"]

RUN mkdir -p /var/lib/biomaj/data

COPY biomaj-config/config.yml /etc/biomaj/config.yml
COPY biomaj-config/global.properties /etc/biomaj/global.properties
COPY biomaj-config/production.ini /etc/biomaj/production.ini
COPY biomaj-config/gunicorn_conf.py /etc/biomaj/gunicorn_conf.py
COPY watcher.sh /root/watcher.sh

# Local test configuration
RUN mkdir -p /etc/biomaj/conf.d
RUN mkdir -p /var/log/biomaj
RUN mkdir -p /etc/biomaj/process.d
RUN mkdir -p /var/cache/biomaj
RUN mkdir -p /var/run/biomaj
COPY test-local/etc/biomaj/global_local.properties /etc/biomaj/global_local.properties
COPY test-local/etc/biomaj/conf.d/alu.properties /etc/biomaj/conf.d/alu.properties

# Plugins
RUN cd /var/lib/biomaj && git clone https://github.com/genouest/biomaj-plugins.git plugins

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait
COPY startup.sh /startup.sh
