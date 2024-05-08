clear
echo -e "\n\n\nWebMultiEgg Installer by _DarkNessYT\n"
echo -e "Очистка папки сервера..."
rm -rf /mnt/server/{*,.*}
mkdir -p /mnt/server
mkdir -p /mnt/server/.eggSystem
echo -e "\n\n\nУспешно.\nОбновление пакетов."
apt-get update
apt-get -y upgrade
echo -e "\n\n\nУспешно.\nУстановка пакетов и зависимостей."
apt-get -y install curl pkg-config libxml2 libxml2-dev
export LIBXML_CFLAGS=$(xml2-config --cflags)
export LIBXML_LIBS=$(xml2-config --libs)
apt-get -y install wget ca-certificates build-essential libzip-dev libtidy-dev libonig-dev
apt-get -y install libpcre3-dev libssl-dev openssl zlib1g-dev libreadline-dev perl libncurses5-dev
apt-get -y install gnupg libbz2-dev libcurl4-openssl-dev sqlite3 libsqlite3-dev
apt-get -y install libjpeg-dev libpng-dev libmcrypt-dev libfreetype6-dev libxslt-dev
apt-get -y install libcppunit-dev g++ librevenge-dev
apt-get -y install libicu-dev gperf
apt-get update
apt-get -y upgrade
chmod -R 777 /mnt/server
echo -e "\n\n\nУстановка завершена.\n"