clear
echo -e "\n\n\nWebMultiEgg Installer by _DarkNessYT\n"
echo -e "Очистка папки сервера..."
rm -rf /mnt/server/{*,.*}
mkdir -p /mnt/server
mkdir -p /mnt/server/.eggSystem
echo -e "\n\n\nУспешно.\nОбновление пакетов."
apt-get update
apt-get -y upgrade
chmod -R 777 /mnt/server
echo -e "\n\n\nУстановка завершена.\n"