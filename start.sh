
# Функции
download_openresty() { # Скачивание рести
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт скачивание архива OpenResty...\nㅤ"
    OPENRESTY_VERSION=$(curl -s https://openresty.org/en/download.html | grep -o 'openresty-[0-9.]*' | head -n 1)
    INSTALL_DIR="/home/container"
    wget https://openresty.org/download/$OPENRESTY_VERSION.tar.gz
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mРаспаковка архива OpenResty...\nㅤ"
    tar xzf $OPENRESTY_VERSION.tar.gz
    cd $OPENRESTY_VERSION
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mПодготовка компилятора...\nㅤ"
    ./configure --prefix=$INSTALL_DIR
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНачинается компиляция OpenResty. Сервер может невыдержать нагрузки либо немного подвисать.\nㅤ"
    sleep 5
    make -j$(nproc)
    make install
    cp -f /home/container/nginx/conf/nginx.conf.default /home/container/nginx/conf/nginx.conf
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;32mКомпиляция OpenResty прошла успешно.\nㅤ"
    ldconfig
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mОчистка временных файлов...\nㅤ"
    cd ..
    rm -rf $OPENRESTY_VERSION
    rm $OPENRESTY_VERSION.tar.gz
}

download_php() {
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт скачивание архива PHP-FPM...\nㅤ"
    wget https://www.php.net/distributions/php-$1.tar.gz
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mРаспаковка архива PHP-FPM...\nㅤ"
    tar -xvf php-$1.tar.gz
    cd php-$1
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mПодготовка компилятора...\nㅤ"
    ./configure --prefix=/home/container --with-fpm-user=www-data --with-fpm-group=www-data --enable-fpm --with-config-file-path=/home/container/etc/php-fpm/ --with-config-file-scan-dir=/home/container/etc/php-fpm/php-fpm.d/
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНачинается компиляция PHP-FPM. Сервер может невыдержать нагрузки либо немного подвисать.\nㅤ"
    sleep 5
    make -j$(nproc)
    make install
    mv /home/container/etc/php-fpm.conf.default /home/container/etc/php-fpm.conf
    mv /home/container/etc/php-fpm.d/www.conf.default /home/container/etc/php-fpm.d/www.conf
    cp php.ini-development /home/container/etc/php.ini
    php_block="location ~ \\\.php\$ { fastcgi_pass unix:/home/container/var/run/php-fpm.sock; fastcgi_index index.php; include fastcgi_params; fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name; }"
    searchB="        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000"
    sed -i "/^$searchB/a         $php_block" /home/container/nginx/conf/nginx.conf
    sed -i 's/index  index.html index.htm;/index  index.html index.htm index.php;/' /home/container/nginx/conf/nginx.conf
    sed -i "/^            index  index.html index.htm;/            index  index.html index.htm index.php;" /home/container/nginx/conf/nginx.conf
    sed -i 's/listen = 127.0.0.1:9000/listen = \/home\/container\/var\/run\/php-fpm.sock/' /home/container/etc/php-fpm.d/www.conf
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;32mКомпиляция PHP-FPM прошла успешно.\nㅤ"
    ldconfig
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mОчистка временных файлов...\nㅤ"
    cd ..
    rm -rf php-$1
    rm php-$1.tar.gz
}

select_php_version() {
    echo -en "\n\033[1;33mㅤㅤㅤㅤПожалуйста, выберите версию PHP:\nㅤ"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ1) PHP 5.6.40"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ2) PHP 7.4.33"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ3) PHP 8.3.6"
    echo -en "\nㅤ\nㅤㅤㅤㅤㅤㅤㅤㅤ4) Выйти"
    echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ\033[36mPowered by _DarkNessYT in 2024y."
    echo -en "\nㅤ"
    read -s phpvers
    case $phpvers in
        1)
            PVER="5.6.40"
            ;;
        2)
            PVER="7.4.33"
            ;;
        3)
            PVER="8.3.6"
            ;;
        *)
            echo -en "\033[1;31mНекорректный выбор. Пожалуйста, попробуйте ещё раз!"
           ;;
    esac
}

if [ ! -f "/home/container/.eggSystem/Config" ]; then
    clear
    echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤ\033[1;31mДобро пожаловать.\nㅤㅤㅤㅤВас приветствует мастер установки программного обеспечения для веб-серверов расположенных на серверах Pterodactyl."
    echo -en "\n\033[1;33mㅤㅤㅤㅤПожалуйста, выберите интересующий вас веб-сервер для установки:\nㅤ"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ1) Скачивание и компиляция OpenResty без PHP-FPM"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ2) Скачивание и компиляция OpenResty вместе с PHP-FPM"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ3) Выйти"
    echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ\033[36mPowered by _DarkNessYT in 2024y."
    echo -en "\nㅤ"
    read -s servertype
    case $servertype in
        1)
            clear
            echo -en "ㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mВы выбрали скачивание и компиляцию OpenResty без PHP-FPM."
            download_openresty
            echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт настройка конфигураций для OpenResty...\nㅤ"
            cd .eggSystem
            touch Config
            echo "SERVER_TYPE=\"openresty without php-fpm\"" > Config
            ;;
        2)
            clear
            echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤ\033[1;33mТеперь нам нужно выбрать версию PHP."
            select_php_version
            clear
            ITER=0
            while [ $ITER -ne 55 ]
            do
                echo -en "\nㅤ\033[1;33mWebMultiEgg: \033[22;31mВНИМАНИЕ! ЧЕРЕЗ 10 СЕКУНД НАЧНЁТСЯ УСТАНОВКА OPENRESTY + PHP $PVER"
                ((ITER++))
            done
            sleep 9
            apt-get install -y pkg-config
            download_openresty
            download_php $PVER
            echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт настройка конфигураций для OpenResty и PHP...\nㅤ"
            cd .eggSystem
            touch Config
            echo "SERVER_TYPE=\"openresty with php-fpm\"" > Config
            ;;
        3)
            echo -en "\033[32mВыход из среды произведён успешно. Всего доброго!"
            exit 0
            ;;
        *)
            echo -en "\033[1;31mНекорректный выбор. Пожалуйста, попробуйте ещё раз!"
            ;;
    esac
else
    source /home/container/.eggSystem/Config
    if [ "$SERVER_TYPE" = "openresty without php-fpm" ]; then
        echo -en "\033[1;33mWebMultiEgg: \033[22;37mOpenResty был успешно запущен. Все логи находятся в папке /nginx/logs.\n\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНе удаляйте папку .eggSystem, поскольку эта папка хранит данные о вашем сервере и она является ядром для этого сервера.\n\033[1;33mWebMultiEgg: \033[22;37m Файлы конфигурации для OpenResty находятся в папке /nginx.\nㅤ"
        ./nginx/sbin/nginx -p '/home/container/nginx/' -g 'daemon off;'
    elif [ "$SERVER_TYPE" = "openresty with php-fpm" ]; then
        echo -en "\033[1;33mWebMultiEgg: \033[22;37mOpenResty был успешно запущен. Все логи находятся в папке /nginx/logs.\n\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНе удаляйте папку .eggSystem, поскольку эта папка хранит данные о вашем сервере и она является ядром для этого сервера.\n\033[1;33mWebMultiEgg: \033[22;37m Файлы конфигурации для OpenResty находятся в папке /nginx.\nㅤ"
        ./sbin/php-fpm -c /home/container/etc/php.ini --daemonize
        ./nginx/sbin/nginx -p '/home/container/nginx/' -g 'daemon off;'
    fi
fi