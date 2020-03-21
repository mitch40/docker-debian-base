FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM xterm-color

# Configuration de la source des paquets et installation des paquets nécessaires.
COPY conf/apt/sources.list /etc/apt/sources.list
RUN echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/15miroir

RUN apt update && apt install -y --no-install-recommends \
	apt-utils \
	curl \
	locales \
	procps \
	supervisor \
	vim

# Configuration système.

ENV TZ Europe/Paris
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
RUN echo 'LANG="fr_FR.UTF-8"'>/etc/default/locale

ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8
ENV LC_CTYPE fr_FR.UTF-8
ENV LC_NUMERIC fr_FR.UTF-8
ENV LC_TIME fr_FR.UTF-8
ENV LC_COLLATE fr_FR.UTF-8
ENV LC_MONETARY fr_FR.UTF-8
ENV LC_MESSAGES fr_FR.UTF-8
ENV LC_PAPER fr_FR.UTF-8
ENV LC_NAME fr_FR.UTF-8
ENV LC_ADDRESS fr_FR.UTF-8
ENV LC_TELEPHONE fr_FR.UTF-8
ENV LC_MEASUREMENT fr_FR.UTF-8
ENV LC_IDENTIFICATION fr_FR.UTF-8
RUN locale-gen fr_FR.UTF-8

RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=fr_FR.UTF-8

RUN mkdir /opt/entrypoint.d/

COPY entrypoint /opt/entrypoint
COPY conf/killme /usr/local/bin/
COPY conf/bashrc /root/.bashrc
COPY conf/bashrc /etc/skel/.bashrc
COPY conf/vimrc /etc/vim/vimrc

RUN chmod 755 /usr/local/bin/*

ENTRYPOINT [ "/bin/bash", "/opt/entrypoint" ]

