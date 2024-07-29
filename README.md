# New-DockerLaravel

## Entorno Local Docker para Laravel
Este repositorio trae la configuración de un entorno local para desarrollar aplicaciones Laravel utilizando Docker con los servicios de Nginx, PHP y MySQL.

### Estructura del Proyecto
LaravelDocker/
- ├── docker/
- │ ├── nginx/
- │ │ └── Dockerfile
- │ │ └── default.conf
- │ ├── php/
- │ │ └── Dockerfile
- │ │ └── init.sh
- │ ├── mysql/
- │ │ └── data/
- │ │ └── Dockerfile
- │ │ └── init.sql (opcional)
- │ │ └── my.cnf
- ├── docroot/
- │ └── (Archivos de la aplicación Laravel)
- ├── .env
- └── docker-compose.ym


### Datos Generales

- **`docker-compose.yml`**: Define y configura los servicios de Docker.
- **`default.conf`** en `./docker/nginx/`: Configura Nginx.
- **`init.sql`** en `./docker/mysql/`: Script opcional para inicializar la base de datos MySQL.

### Configuración del Entorno

1. **Edita el archivo `.env`** en la raíz del proyecto con las siguientes variables:

    ```env
    DB_CONNECTION=mysql
    DB_HOST=mysql
    DB_PORT=3306
    DB_DATABASE=laravel
    DB_USERNAME=user
    DB_PASSWORD=password
    ```

2. **Construye las imágenes** de Docker para los servicios especificados en el archivo `docker-compose.yml`:

    ```sh
    docker-compose build --no-cache
    ```

3. **Inicia los contenedores** y la red especificados en el archivo `docker-compose.yml`:

    ```sh
    docker-compose up --detach --build --remove-orphans
    ```

4. **Verifica el Entorno**: Abre tu navegador y dirígete a `http://localhost`. Deberías ver la página de inicio de Laravel.
