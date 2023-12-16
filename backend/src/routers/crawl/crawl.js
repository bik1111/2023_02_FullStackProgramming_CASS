import express from 'express';
import { crawlstarBucksInfo } from '../../util/crawling.js';

const crawlingRouter = express.Router();

/**
 * @swagger
 * tags:
 *   name: Crawl API
 *   description: 스타벅스 정보를 크롤링하는 API
 */

/**
 * @swagger
 * /api/crawl:
 *   get:
 *     tags: [Crawl API]
 *     summary: 스타벅스 정보 크롤링
 *     description: 스타벅스 매장 정보를 크롤링하여 데이터베이스에 저장합니다.
 *     responses:
 *       '200':
 *         description: 성공
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 ok:
 *                   type: boolean
 *                 message:
 *                   type: string
 *             example:
 *               ok: true
 *               message: "스타벅스 정보 크롤링이 완료되었습니다."
 *       '500':
 *         description: 서버 에러
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 ok:
 *                   type: boolean
 *                 error:
 *                   type: object
 *                   properties:
 *                     message:
 *                       type: string
 *             example:
 *               ok: false
 *               error:
 *                 message: "스타벅스 정보 크롤링 중 에러가 발생했습니다."
 */
crawlingRouter.route('/api/crawl').get(crawlstarBucksInfo);

export default crawlingRouter;