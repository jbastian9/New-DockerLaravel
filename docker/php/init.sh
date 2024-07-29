#!/bin/sh

# Directorio donde se instalará Laravel
DOCROOT=/var/www/html

# Verifica si la carpeta docroot está vacía
if [ ! "$(ls -A $DOCROOT)" ]; then
    echo "Directorio docroot vacío. Creando un nuevo proyecto Laravel..."
    composer create-project --prefer-dist laravel/laravel $DOCROOT
else
  echo "La carpeta docroot no está vacía. Continuando con el inicio del contenedor..."
fi

# Copiar el archivo .env.example y crear el archivo .env con las variables de entorno
cp /var/www/html/.env.example /var/www/html/.env

# Configurar el archivo .env con las variables de entorno
sed -i "s/^DB_CONNECTION=sqlite/DB_CONNECTION=mysql/" $DOCROOT/.env
sed -i "s/^# DB_HOST=127.0.0.1/DB_HOST=mysql/" $DOCROOT/.env
sed -i "s/^# DB_PORT=3306/DB_PORT=3306/" $DOCROOT/.env
sed -i "s/^# DB_DATABASE=laravel/DB_DATABASE=${DB_DATABASE}/" $DOCROOT/.env
sed -i "s/^# DB_USERNAME=root/DB_USERNAME=${MYSQL_USER}/" $DOCROOT/.env
sed -i "s/^# DB_PASSWORD=/DB_PASSWORD=${MYSQL_PASSWORD}/" $DOCROOT/.env

#Instalar dependencias de PHP:
cd $DOCROOT
composer install --no-dev --optimize-autoloader
#Instalar dependencias de JavaScript:
npm install --prefix 

# Configurar permisos
chgrp -R www-data $DOCROOT/bootstrap $DOCROOT/storage $DOCROOT/storage/logs
chmod -R g+w $DOCROOT/bootstrap $DOCROOT/storage $DOCROOT/storage/logs
find $DOCROOT/bootstrap -type d -exec chmod g+s {} +
find $DOCROOT/storage -type d -exec chmod g+s {} +
find $DOCROOT/storage/logs -type d -exec chmod g+s {} +

# Verificar si las variables de entorno están disponibles
if [ -z "$DB_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "Error: Las variables de entorno DB_DATABASE, MYSQL_USER o MYSQL_PASSWORD no están definidas."
    exit 1
fi

# Ejecutar migraciones de Laravel
echo "Ejecutando migraciones de Laravel..."
php /var/www/html/artisan migrate

# Configurar el entorno de Laravel
php artisan key:generate
php artisan storage:link
php artisan clear-compiled
php artisan config:cache
php artisan route:clear
php artisan optimize

# Mostrar versiones y realizar auditoría de npm
echo "Node version:"
node -v

echo "NPM version:"
npm -v

echo "PHP version:"
php -v

echo "Laravel version:"
php artisan --version

echo "Composer version:"
composer --version

echo "Running npm audit:"
npm audit

# Iniciar PHP-FPM
php-fpm