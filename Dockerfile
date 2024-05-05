FROM debian:bullseye
LABEL author="_DarkNessYT" maintainer="darknessyt@inbox.ru"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install wget ca-certificates build-essential libpcre3-dev libssl-dev openssl zlib1g-dev libreadline-dev perl libncurses5-dev gnupg curl libxml2-dev libxml2-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libmcrypt-dev libreadline-dev libzip-dev libsqlite3-dev libonig-dev coreutils

RUN useradd -m -d /home/container/ -s /bin/bash container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh