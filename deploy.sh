#!/bin/bash

# Пересобираем образ
docker build -t insights-strapi .

# Останавливаем и удаляем старый контейнер
docker stop telegram-bot
docker rm telegram-bot

# Запускаем новый контейнер
docker run -p 1337:1337 insights-strapi
