
dotenv.config();
import dotenv from 'dotenv';
import bodyParser from 'body-parser';
import express from 'express';
import cors from 'cors';
import crawlingRouter from '../backend/src/routers/crawl/crawl.js';
import cafeRouter from '../backend/src/routers/cafe/cafeRouter.js';
import communityRouter from './src/routers/community/communityRouter.js';

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/', crawlingRouter);
app.use('/', cafeRouter);
app.use('/', communityRouter);

app.use(cors({
  origin: ["http://localhost:9101"], // 접근 권한을 부여하는 도메인들의 배열
  credentials: true, // 응답 헤더에 Access-Control-Allow-Credentials 추가
  optionsSuccessStatus: 200, // 응답 상태 200으로 설정
}));


const PORT = 3000;
const HOST = '0.0.0.0';

const handleListening = () =>
  console.log(`✅ Server listening on http://${HOST}:${PORT} 🚀`);

app.listen(PORT, HOST, handleListening);



export default app;