FROM haskell:9.4.3
MAINTAINER finlay@dragonfly.co.nz

ENV DEBIAN_FRONTEND noninteractive

# Set New Zealand mirrors and set timezone to Auckland
RUN sed -i 's/archive/nz.archive/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y tzdata
RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Set the locale to New Zealand
RUN apt-get -y install locales
RUN locale-gen en_NZ.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get update && \
    apt upgrade --yes && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG en_NZ.UTF-8
ENV LANGUAGE en_NZ:en

RUN curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v1.2.280/quarto-1.2.280-linux-amd64.deb
RUN dpkg -i quarto-1.2.280-linux-amd64.deb

RUN apt-get update && \
    apt-get install texlive-full --yes && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
