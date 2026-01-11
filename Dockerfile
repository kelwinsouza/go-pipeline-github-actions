# Estágio 1: Build
FROM golang:1.22-alpine AS build

# Instala git para baixar dependências se necessário
RUN apk add --no-cache git

WORKDIR /app

# Aproveita cache das camadas do Docker para dependências
COPY go.mod go.sum ./
RUN go mod download

# Copia o código e compila
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main main.go

# Estágio 2: Produção (Final)
FROM alpine:3.19 AS production

# Certificados para chamadas externas seguras
RUN apk add --no-cache ca-certificates

WORKDIR /app

# Configurações de ambiente
ENV PORT=8080 \
    DB_HOST=postgres \
    DB_USER=root \
    DB_PASSWORD=root \
    DB_NAME=root \
    DB_PORT=5432

# Copia apenas os arquivos estáticos e o binário final
COPY ./assets/ /app/assets/
COPY ./templates/ /app/templates/
COPY --from=build /app/main /app/main

EXPOSE 8080

CMD [ "./main" ]
