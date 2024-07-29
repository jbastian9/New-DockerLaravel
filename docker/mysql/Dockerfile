# Usa la versión 8.0 de MySQL desde Docker Hub
FROM mysql:8.0

# Ajusta la zona horaria
ENV MYSQL_TIMEZONE=America/Bogota
RUN ln -snf /usr/share/zoneinfo/$MYSQL_TIMEZONE /etc/localtime && echo $MYSQL_TIMEZONE > /etc/timezone

# Copia el archivo de configuración adicional para UTF-8
COPY ./my.cnf /etc/mysql/my.cnf

# Copia el script de inicialización al contenedor
COPY ./init.sql /docker-entrypoint-initdb.d/

# Establece el comando de inicio
CMD ["mysqld"]