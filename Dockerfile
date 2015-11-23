FROM debian:stable
MAINTAINER Olivier Sallou <olivier.sallou@irisa.fr>

LABEL description="BioMAJ  is a workflow engine dedicated to data \
 synchronization and processing. \
 The software automates the update cycle and the supervision of the \
 locally mirrored databank repository."

WORKDIR /var/lib/biomaj

RUN apt-get update
RUN apt-get install -y git python-dev libldap2-dev gcc libsasl2-dev
RUN apt-get install -y python-setuptools apt-transport-https wget
RUN apt-get install -y openssl libpython-dev libffi-dev libssl-dev
RUN apt-get install -y libcurl4-openssl-dev

RUN mkdir -p /usr/share/biomaj
RUN cd /usr/share/biomaj && git clone https://github.com/genouest/biomaj.git
RUN easy_install pip
RUN cd /usr/share/biomaj/biomaj && pip install -r requirements.txt
RUN cd /usr/share/biomaj/biomaj && python setup.py install

ENTRYPOINT ["/usr/local/bin/biomaj-cli.py", "--config", "/etc/biomaj/global.properties"]

RUN mkdir -p /etc/biomaj
ADD global.properties /etc/biomaj/
ENV LOGNAME root
