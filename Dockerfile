# 베이스이미지
FROM node:16-alpine

WORKDIR /app

#프로젝트 파일 복사
COPY ["package.json", "package-lock.json", "./"]

RUN npm install --silent

COPY backend /app/backend

CMD ["node", "backend/src/app.js"]

EXPOSE 3000