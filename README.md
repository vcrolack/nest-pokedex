<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="200" alt="Nest Logo" /></a>
</p>

## Stack usado
+ MongoDB
+ Nest JS

# Ejecutar en desarrollo

1. Clonar el proyecto
2. Ejecutar 
```bash
yarn install
```
3. Tener Nest CLI instalado
```bash
npm i -g @nestjs/cli
```
4. Levantar la base de datos
```
docker-compose up -d
```

5. Clonar el archivo .__evn.template__ y renombrar la copia a __.env__

6. Asignar las variables de entorno definidas en el archivo __.env__

7. Ejecutar la aplicación en dev:

```shell
yarn start:dev
```

8. Reconstruir la base de datos con la seed
```shell
localhost:3000/api/v2/seed
```

# Production Build

1. Configurar el .env.prod
2. Completar las variables de entorno para producción
3. Crear la nueva imagen
```shell
docker-compose -f docker-compose.prod.yaml --env-file .env.prod up --build
```
