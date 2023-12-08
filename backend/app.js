
dotenv.config();
import dotenv from 'dotenv';
import bodyParser from 'body-parser';
import express from 'express';
import cors from 'cors';
import crawlingRouter from './src/routers/crawl/crawl.js';
import cafeRouter from './src/routers/cafe/cafeRouter.js';
import communityRouter from './src/routers/community/communityRouter.js';
import userRouter from './src/routers/user/userRouter.js';
import reviewRouter from './src/routers/review/reviewRouter.js';
import commentRouter from './src/routers/comment/commentRouter.js';
import { swaggerUi, specs } from "./src/swagger/swagger.js";


const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/', crawlingRouter);
app.use('/', userRouter);
app.use('/', cafeRouter);
app.use('/', communityRouter);
app.use('/', reviewRouter);
app.use('/', commentRouter);

app.use(cors({
  origin: "http://localhost:3000", // Change this to your specific origin
  credentials: true,
  optionsSuccessStatus: 200,
}));

// Additional headers to handle credentials
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "http://localhost:3000"); // Change this to your specific origin
  res.header("Access-Control-Allow-Credentials", true);
  next();
});

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));

app.get('/', (req, res) => {
  res.send('Hello World!');
});


const PORT = 3000;
const HOST = 'localhost';

const handleListening = () =>
  console.log(`✅ Server listening on http://${HOST}:${PORT} 🚀`);

app.listen(PORT, HOST, handleListening);



export default app;