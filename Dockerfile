# Install dependencies only when needed -> imagen unicament con las dependencias de mi aplicación. Nada más
# Puedo mantener en caché todas esas depndencias, y solo si cambian, se descargan esos cambios solamente
FROM node:18-alpine3.15 AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Build the app with cache dependencies
# Otra imagen que empieza de cero, que copia lo de dependencias y lo pegua en los modulos de node
# de este nuevo contenedor
# luego de copiar todo lo de dsp, se copia todo lo que está en el directorio donde está el dockerfile
# y lo pega en el working directory (. .)
# Y se construye el build de construcción
FROM node:18-alpine3.15 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build


# Production image, copy all the files and run next
# Esta imagen corre la aplicación propiamente
# El working directory es el directorio app
# copia,os el package y yarn lock en el contendor
# se instala las dependencias de producción
#  luego de builder copiamos la carpeta de distribución
FROM node:18-alpine3.15 AS runner

# Set working directory
WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install --prod

COPY --from=builder /app/dist ./dist

# # Copiar el directorio y su contenido
# RUN mkdir -p ./pokedex

# COPY --from=builder ./app/dist/ ./app
# COPY ./.env ./app/.env

# # Dar permiso para ejecutar la applicación
# RUN adduser --disabled-password pokeuser
# RUN chown -R pokeuser:pokeuser ./pokedex
# USER pokeuser

# EXPOSE 3000

CMD [ "node","dist/main" ]