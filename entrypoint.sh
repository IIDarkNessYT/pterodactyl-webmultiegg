#!/bin/bash
cd /home/container

echo -en "\033[1;33mWebMultiEgg: \033[22;37mДобро пожаловать! Идёт скачивание программы.\n\033[1;33mWebMultiEgg: \033[1;31mПожалуйста, подождите немного. Запуск сервера может занимать некоторое время!\033[0m"
cd /home/container/.eggSystem
if [ ! -d "/home/container/.eggSystem" ]; then
    mkdir -p /home/container/.eggSystem
fi
if [ -f "/home/container/.eggSystem/updater.sh" ]; then
    rm /home/container/.eggSystem/updater.sh
fi
wget -O updater.sh https://raw.githubusercontent.com/iidarknessyt/pterodactyl-webmultiegg/main/updater.sh -q -o /dev/null && chmod 755 updater.sh
cd ..
eval ./.eggSystem/updater.sh