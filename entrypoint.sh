#!/bin/bash
cd /home/container

echo -en "\033[1;33mWebMultiEgg: \033[22;37mДобро пожаловать! Идёт скачивание программы.\n\033[1;33mWebMultiEgg: \033[1;31mПожалуйста, подождите немного. Запуск сервера может занимать некоторое время!\033[0m"
mkdir -p /home/container/.eggSystem
if [ -f "/home/container/.eggSystem/updater.sh" ]; then
    rm /home/container/.eggSystem/updater.sh
fi
cd /home/container/.eggSystem
wget -O updater.sh https://raw.githubusercontent.com/iidarknessyt/pterodactyl-webmultiegg/main/updater.sh -q -o /dev/null && chmod 755 updater.sh
cd ..
eval ./.eggSystem/updater.sh