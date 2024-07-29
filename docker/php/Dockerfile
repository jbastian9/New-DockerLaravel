# Usa la versión 8.2 de PHP-FPM desde Docker Hub basado en Alpine
FROM php:8.2-fpm-alpine

# Argumentos de construcción para UID y GID personalizados
ARG UID
ARG GID

# Instalación de dependencias y herramientas necesarias
RUN apk update && apk add --no-cache \
    libzip-dev \
    git \
    unzip \
    nodejs \
    npm \
    shadow \
    dos2unix \
    && docker-php-ext-install pdo_mysql zip

# Instala Composer en el contenedor
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Cambia el UID y GID de www-data para que coincidan con los argumentos de construcción
RUN deluser www-data && \
    addgroup -g ${GID} www-data && \
    adduser -u ${UID} -G www-data -D www-data

# Copia el script de inicialización en el contenedor
COPY init.sh /init.sh

# Da permisos de ejecución al script
RUN chmod +x /init.sh

# Convierte el script de inicialización a formato LF
RUN dos2unix /init.sh

# Establece el script como el comando de inicio
CMD ["/init.sh"]