
dotenv.config();
import dotenv from 'dotenv';
import bodyParser from 'body-parser';
import express from 'express';
import cors from 'cors';
import crawlingRouter from '../backend/src/routers/crawl/crawl.js';
import cafeRouter from '../backend/src/routers/cafe/cafeRouter.js';
import communityRouter from './src/routers/community/communityRouter.js';
import userRouter from './src/routers/user/userRouter.js';

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/', crawlingRouter);
app.use('/', userRouter);
app.use('/', cafeRouter);
app.use('/', communityRouter);

app.use(cors({
  origin: "*", // Allow requests from any origin
  credentials: true, // Include Access-Control-Allow-Credentials in the response headers
  optionsSuccessStatus: 200, // Set response status to 200 for preflight requests
}));

// Additional headers to handle credentials
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", req.headers.origin);
  res.header("Access-Control-Allow-Credentials", true);
  next();
});


const PORT = 3000;
const HOST = '0.0.0.0';

const handleListening = () =>
  console.log(`✅ Server listening on http://${HOST}:${PORT} 🚀`);

app.listen(PORT, HOST, handleListening);



export default app;