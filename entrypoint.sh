#!/bin/bash
cd /home/container

echo -en "\033[1;33mWebMultiEgg: \033[22;37mДобро пожаловать! Идёт скачивание программы.\n\033[1;33mWebMultiEgg: \033[1;31mПожалуйста, подождите немного. Запуск сервера может занимать некоторое время!\033[0m"
cd /home/container/.eggSystem
if [ -f "/home/container/.eggSystem/updater.sh" ]; then
    rm /home/container/.eggSystem/updater.sh
fi
wget -O updater.sh https://cdn.splash-bot.ru/webmultiegg/updater.sh -q -o /dev/null && chmod 755 updater.sh
cd ..
eval ./.eggSystem/updater.sh