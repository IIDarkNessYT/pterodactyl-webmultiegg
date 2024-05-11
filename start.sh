
# Функции
download_openresty() { # Скачивание OpenResty
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт скачивание архива OpenResty...\nㅤ"
    OPENRESTY_LATEST=$(curl -s https://openresty.org/en/download.html | grep -o 'openresty-[0-9.]*' | head -n 1)
    wget https://openresty.org/download/$OPENRESTY_LATEST.tar.gz
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mРаспаковка архива OpenResty...\nㅤ"
    tar xzf $OPENRESTY_LATEST.tar.gz
    cd $OPENRESTY_LATEST
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mПодготовка компилятора...\nㅤ"
    ./configure --prefix=/home/container
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНачинается компиляция OpenResty. Сервер может невыдержать нагрузки либо немного подвисать.\nㅤ"
    sleep 5
    make -j$(nproc)
    make install
    cp -f /home/container/nginx/conf/nginx.conf.default /home/container/nginx/conf/nginx.conf
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;32mКомпиляция OpenResty прошла успешно.\nㅤ"
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mОчистка временных файлов...\nㅤ"
    cd ..
    rm -rf $OPENRESTY_LATEST
    rm $OPENRESTY_LATEST.tar.gz
}

download_nginx() { # Скачание Nginx
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт скачивание архива Nginx...\nㅤ"
    wget http://nginx.org/download/nginx-1.26.0.tar.gz
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mРаспаковка архива Nginx...\nㅤ"
    tar xzf nginx-1.26.0.tar.gz
    cd nginx-1.26.0
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mПодготовка компилятора...\nㅤ"
    ./configure --prefix=/home/container/nginx --sbin-path=/home/container/nginx/sbin/nginx --conf-path=/home/container/nginx/conf/nginx.conf --error-log-path=/home/container/nginx/logs/error.log --http-log-path=/home/container/nginx/logs/access.log --pid-path=/home/container/nginx/logs/nginx.pid --http-client-body-temp-path=/home/container/nginx/client_body_temp --http-proxy-temp-path=/home/container/nginx/proxy_temp --http-fastcgi-temp-path=/home/container/nginx/fastcgi_temp --http-scgi-temp-path=/home/container/nginx/scgi_temp --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-file-aio --with-threads --http-uwsgi-temp-path=/home/container/nginx/uwsgi_temp --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-mail --with-mail_ssl_module 
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНачинается компиляция Nginx. Сервер может невыдержать нагрузки либо немного подвисать.\nㅤ"
    sleep 5
    make -j$(nproc)
    make install
    touch /home/container/nginx/logs/access.log
    touch /home/container/nginx/logs/error.log
    mkdir -p /home/container/nginx/client_body_temp
    mkdir -p /home/container/nginx/proxy_temp
    mkdir -p /home/container/nginx/fastcgi_temp
    mkdir -p /home/container/nginx/uwsgi_temp
    mkdir -p /home/container/nginx/scgi_temp
    cp -f /home/container/nginx/conf/nginx.conf.default /home/container/nginx/conf/nginx.conf
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;32mКомпиляция Nginx прошла успешно.\nㅤ"
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mОчистка временных файлов...\nㅤ"
    cd ..
    rm -rf nginx-1.26.0
    rm nginx-1.26.0.tar.gz
}

download_php() { # Скачивание PHP-FPM
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт скачивание архива PHP-FPM...\nㅤ"
    wget https://www.php.net/distributions/php-$1.tar.gz
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mРаспаковка архива PHP-FPM...\nㅤ"
    tar -xvf php-$1.tar.gz
    cd php-$1
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mПодготовка компилятора...\nㅤ"
    ./configure --prefix=/home/container/php --enable-mbstring --with-curl=/usr/include/x86_64-linux-gnu/curl --with-openssl --with-zlib --with-fpm-user=www-data --with-fpm-group=www-data --enable-fpm --with-config-file-path=/home/container/etc/php-fpm/ --with-config-file-scan-dir=/home/container/etc/php-fpm/php-fpm.d/
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНачинается компиляция PHP-FPM. Сервер может невыдержать нагрузки либо немного подвисать.\nㅤ"
    sleep 5
    make -j$(nproc)
    make install
    mv /home/container/php/etc/php-fpm.conf.default /home/container/php/etc/php-fpm.conf
    mv /home/container/php/etc/php-fpm.d/www.conf.default /home/container/php/etc/php-fpm.d/www.conf
    cp php.ini-development /home/container/php/php.ini
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;32mКомпиляция PHP-FPM прошла успешно.\nㅤ"
    echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mОчистка временных файлов...\nㅤ"
    cd ..
    rm -rf php-$1
    rm php-$1.tar.gz
}

configure_php() { # Настройка PHP-FPM. Данная функция применяется только если пользователь выбрал установку веб-сервера с PHP-FPM.
    php_block="location ~ \\\.php\$ { fastcgi_pass unix:/home/container/php-fpm.sock; fastcgi_index index.php; include fastcgi_params; fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name; }"
    searchB="        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000"
    sed -i "/^$searchB/a         $php_block" /home/container/nginx/conf/nginx.conf
    sed -i 's/index  index.html index.htm;/index  index.html index.htm index.php;/' /home/container/nginx/conf/nginx.conf
    sed -i "/^            index  index.html index.htm;/            index  index.html index.htm index.php;" /home/container/nginx/conf/nginx.conf
    sed -i 's/listen = 127.0.0.1:9000/listen = \/home\/container\/php-fpm.sock/' /home/container/php/etc/php-fpm.d/www.conf
}

select_php_version() { # Выбор версии PHP
    echo -en "\n\033[1;33mㅤㅤㅤㅤПожалуйста, выберите версию PHP:\nㅤ"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ1) PHP 8.3.6"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ2) PHP 8.2.18"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ3) PHP 8.1.26"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ4) PHP 8.0.26"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ5) PHP 7.4.33"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ6) PHP 7.3.33"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ7) PHP 7.2.34"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ8) PHP 7.1.33"
    echo -en "\nㅤ\nㅤㅤㅤㅤㅤㅤㅤㅤ9) Выйти"
    echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ\033[36mPowered by _DarkNessYT in 2024y."
    echo -en "\nㅤ"
    read -s phpvers
    case $phpvers in
        1)
            PVER="8.3.6"
            ;;
        2)
            PVER="8.2.18"
            ;;
        3)
            PVER="8.1.26"
            ;;
        4)
            PVER="8.0.26"
            ;;
        5)
            PVER="7.4.33"
            ;;
        6)
            PVER="7.3.33"
            ;;
        7)
            PVER="7.2.34"
            ;;
        8)
            PVER="7.1.33"
            ;;
        9)
            echo -en "\033[32mВыход из среды произведён успешно. Всего доброго!"
            exit 0
            ;;
        *)
            echo -en "\033[1;31mНекорректный выбор. Пожалуйста, попробуйте ещё раз!"
           ;;
    esac
}

if [ ! -f "/home/container/.eggSystem/Config" ]; then # В случае отсутствия этого файла система попросит установить интересующий веб-сервер
    mkdir -p 
    clear
    echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤ\033[1;31mДобро пожаловать.\nㅤㅤㅤㅤВас приветствует мастер установки программного обеспечения для веб-серверов расположенных на серверах Pterodactyl."
    echo -en "\n\033[1;33mㅤㅤㅤㅤПожалуйста, выберите интересующий вас веб-сервер для установки:\nㅤ"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ1) Скачивание и компиляция OpenResty без PHP-FPM"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ2) Скачивание и компиляция OpenResty вместе с PHP-FPM"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ3) Скачивание и компиляция Nginx без PHP-FPM"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ4) Скачивание и компиляция Nginx вместе с PHP-FPM"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ5) Скачивание и компиляция чистого PHP-FPM без его настройки"
    echo -en "\nㅤㅤㅤㅤㅤㅤㅤㅤ6) Выйти"
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
            download_openresty
            download_php $PVER
            configure_php
            echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт настройка конфигураций для OpenResty и PHP...\nㅤ"
            cd .eggSystem
            touch Config
            echo "SERVER_TYPE=\"openresty with php-fpm\"" > Config
            ;;
        3)
            clear
            echo -en "ㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mВы выбрали скачивание и компиляцию Nginx без PHP-FPM."
            download_nginx
            echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт настройка конфигураций для Nginx...\nㅤ"
            cd .eggSystem
            touch Config
            echo "SERVER_TYPE=\"nginx without php-fpm\"" > Config
            ;;
        4)
            clear
            echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤ\033[1;33mТеперь нам нужно выбрать версию PHP."
            select_php_version
            clear
            download_nginx
            download_php $PVER
            configure_php
            echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт настройка конфигураций для Nginx и PHP...\nㅤ"
            cd .eggSystem
            touch Config
            echo "SERVER_TYPE=\"nginx with php-fpm\"" > Config
            ;;
        5)
            clear
            echo -en "\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤ\nㅤㅤㅤㅤ\033[1;33mТеперь нам нужно выбрать версию PHP."
            select_php_version
            clear
            download_php $PVER
            echo -en "\nㅤㅤㅤㅤ\033[1;33mWebMultiEgg: \033[22;37mИдёт настройка конфигураций для PHP...\nㅤ"
            cd .eggSystem
            touch Config
            echo "SERVER_TYPE=\"vanilla php-fpm\"" > Config
            ;;
        6)
            echo -en "\033[32mВыход из среды произведён успешно. Всего доброго!"
            exit 0
            ;;
        *)
            echo -en "\033[1;31mНекорректный выбор. Пожалуйста, попробуйте ещё раз!"
            ;;
    esac
else
    source /home/container/.eggSystem/Config # Стартовые команды для серверов
    if [ "$SERVER_TYPE" = "openresty without php-fpm" ]; then
        echo -en "\033[1;33mWebMultiEgg: \033[22;37mOpenResty был успешно запущен. Все логи находятся в папке /nginx/logs.\n\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНе удаляйте папку .eggSystem, поскольку эта папка хранит данные о вашем сервере и она является ядром для этого сервера.\n\033[1;33mWebMultiEgg: \033[22;37m Файлы конфигурации для OpenResty находятся в папке /nginx.\nㅤ"
        ./nginx/sbin/nginx -p '/home/container/nginx/' -g 'daemon off;'
    elif [ "$SERVER_TYPE" = "openresty with php-fpm" ]; then
        echo -en "\033[1;33mWebMultiEgg: \033[22;37mOpenResty и PHP-FPM были успешно запущены. Все логи Nginx находятся в папке /nginx/logs.\n\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНе удаляйте папку .eggSystem, поскольку эта папка хранит данные о вашем сервере и она является ядром для этого сервера.\n\033[1;33mWebMultiEgg: \033[22;37m Файлы конфигурации для OpenResty находятся в папке /nginx.\nㅤ"
        ./php/sbin/php-fpm -c /home/container/etc/php.ini --daemonize
        ./nginx/sbin/nginx -p '/home/container/nginx/' -g 'daemon off;'
    elif [ "$SERVER_TYPE" = "nginx without php-fpm" ]; then
        echo -en "\033[1;33mWebMultiEgg: \033[22;37mNginx был успешно запущен. Все логи находятся в папке /logs.\n\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНе удаляйте папку .eggSystem, поскольку эта папка хранит данные о вашем сервере и она является ядром для этого сервера.\n\033[1;33mWebMultiEgg: \033[22;37m Файлы конфигурации для Nginx находятся в папке /nginx/conf.\nㅤ"
        ./sbin/nginx -p '/home/container/nginx/' -g 'daemon off;'
    elif [ "$SERVER_TYPE" = "nginx with php-fpm" ]; then
        echo -en "\033[1;33mWebMultiEgg: \033[22;37mNginx и PHP-FPM были успешно запущены. Все логи Nginx находятся в папке /logs.\n\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНе удаляйте папку .eggSystem, поскольку эта папка хранит данные о вашем сервере и она является ядром для этого сервера.\n\033[1;33mWebMultiEgg: \033[22;37m Файлы конфигурации для Nginx находятся в папке /nginx/conf.\nㅤ"
        ./php/sbin/php-fpm -c /home/container/php/php.ini --daemonize
        ./nginx/sbin/nginx -p '/home/container/nginx/' -g 'daemon off;'
    elif [ "$SERVER_TYPE" = "vanilla php-fpm" ]; then
        echo -en "\033[1;33mWebMultiEgg: \033[22;37mPHP-FPM были успешно запущен. Все логи PHP-FPM находятся в папке /php/var/log.\n\033[1;33mWebMultiEgg: \033[1;31mВНИМАНИЕ! \033[22;37mНе удаляйте папку .eggSystem, поскольку эта папка хранит данные о вашем сервере и она является ядром для этого сервера.\n\033[1;33mWebMultiEgg: \033[22;37m Файлы конфигурации для PHP-FPM находятся в папке /php/etc.\nㅤ"
        ./php/sbin/php-fpm -c /home/container/php/etc/php.ini
    fi
fi