# 베이스이미지
FROM node:16-alpine

WORKDIR /app

COPY ["package.json", "package-lock.json", "./"]

RUN npm install --silent

COPY backend /app/backend

CMD ["node", "backend/app.js"]

EXPOSE 3000
