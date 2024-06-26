if [ -d "/home/container/.eggSystem" ]; then
    if [ -f "/home/container/.eggSystem/start.sh" ]; then
        rm /home/container/.eggSystem/start.sh
    fi
else
    mkdir -p /home/container/.eggSystem
fi
cd /home/container/.eggSystem
wget -O start.sh https://raw.githubusercontent.com/iidarknessyt/pterodactyl-webmultiegg/main/start.sh -q -o /dev/null && chmod 755 start.sh
cd /home/container
echo -en "\n\033[1;33mWebMultiEgg: \033[22;32mФайлы запуска были успешно скачаны.\033[0m\n"
chmod -R 777 /home/container/
sleep 5
eval ./.eggSystem/start.sh