# Этап сборки
FROM node:18-slim AS builder

# Установка зависимостей для сборки sharp
RUN apt-get update && apt-get install -y \
    python3 \
    pkg-config \
    build-essential \
    git \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

# Копируем файлы зависимостей и устанавливаем их
COPY package.json package-lock.json ./
RUN npm install --force

# Копируем остальной код приложения
COPY . .

# Сборка приложения
RUN npm run build

# # Удаляем dev-зависимости для уменьшения размера
# RUN npm prune --production

# Этап производства
FROM node:18-slim

WORKDIR /opt/app

# Установка libvips для рантайма
RUN apt-get update && apt-get install -y \
    libvips42 \
    && rm -rf /var/lib/apt/lists/*

# Копируем собранное приложение из предыдущего этапа
COPY --from=builder /opt/app ./

# Устанавливаем права на рабочую директорию
RUN chown -R node:node /opt/app

# Переключаемся на пользователя node
USER node

EXPOSE 1337

# Используем команду для запуска приложения
CMD ["npm", "run", "develop"]