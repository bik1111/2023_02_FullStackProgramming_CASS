# 베이스이미지
FROM node:16-alpine

WORKDIR /app

# 프로젝트 파일 복사
COPY ["package.json", "package-lock.json", "./"]

RUN npm install --silent

# 복사할 경로 변경
COPY backend /app/backend

# CMD 경로 변경
CMD ["node", "backend/app.js"]

EXPOSE 3000
