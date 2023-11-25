import express from 'express';
import { crawlstarBucksInfo } from '../../util/crawling.js';

const crawlingRouter = express.Router();

crawlingRouter.route('/api/crawl').get(crawlstarBucksInfo);


export default crawlingRouter;