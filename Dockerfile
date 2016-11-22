FROM debian:jessie

WORKDIR /root
ENV "BIOMAJ_CONFIG=/root/config.yml"

RUN apt-get update
RUN apt-get install -y curl libcurl4-openssl-dev gcc python3-pycurl python3-dev python3-pip git unzip bzip2 protobuf-compiler

RUN git clone -b develop https://github.com/genouest/biomaj-core.git
RUN pip3 install setuptools --upgrade
RUN cd biomaj-core && python3 setup.py install
RUN git clone https://github.com/genouest/biomaj-user.git
RUN cd biomaj-user && python3 setup.py install

RUN git clone https://github.com/genouest/biomaj-process.git
RUN cd biomaj-process && python3 setup.py install

RUN git clone https://github.com/genouest/biomaj-download.git
RUN cd biomaj-download/biomaj_download/message && protoc --python_out=. message.proto
RUN cd biomaj-download && python3 setup.py install

RUN git clone -b feature_microservice https://github.com/genouest/biomaj.git && echo "Install biomaj again"
RUN cd biomaj && python3 setup.py install

RUN git clone https://github.com/genouest/biomaj-daemon.git && echo "Install daemon"
RUN cd biomaj-daemon && python3 setup.py install


ENV "BIOMAJ_CONFIG=/root/config.yml"

RUN mkdir -p /var/log/biomaj

RUN pip3 install gunicorn

RUN mkdir -p /var/lib/biomaj/data

COPY config.yml /root/config.yml
COPY global.properties /var/lib/biomaj/global.properties
