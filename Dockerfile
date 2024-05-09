FROM debian:bullseye
LABEL author="_DarkNessYT" maintainer="darknessyt@inbox.ru"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install curl python3 python pkg-config python-dev python2.7 \
    && apt-get -y install wget ca-certificates build-essential libzip-dev libtidy-dev libonig-dev \
    && apt-get -y install libpcre3-dev libssl-dev openssl zlib1g-dev libreadline-dev perl libncurses5-dev \
    && apt-get -y install gnupg libbz2-dev libcurl4-openssl-dev sqlite3 libsqlite3-dev \
    && apt-get -y install libjpeg-dev libpng-dev libmcrypt-dev libfreetype6-dev libxslt-dev \
    && apt-get -y install libcppunit-dev g++ librevenge-dev \
    && apt-get -y install libicu-dev gperf coreutils \
    && apt-get update \
    && apt-get -y upgrade

RUN useradd -m -d /home/container/ -s /bin/bash container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh