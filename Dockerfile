FROM node:16-alpine

WORKDIR /app

COPY ["package.json", "package-lock.json", "./"]

RUN npm install --silent

COPY backend /app/backend

WORKDIR /app/backend

CMD ["node", "app.js"]

EXPOSE 3000
