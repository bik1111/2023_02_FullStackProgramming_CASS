import express from 'express';
import { createReview, getReviewEachCafe, modifyReview, deleteReview } from '../../controller/review/reviewController.js';
const reviewRouter = express.Router();

/**
 * @swagger
 * /api/create/review:
 *   post:
 *     tags: [Review API]
 *     summary: 리뷰 생성
 *     description: 카페에 대한 리뷰를 생성합니다.
 *     requestBody:
 *       description: 리뷰 정보를 전달합니다.
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               cafe_id:
 *                 type: string
 *                 description: "리뷰 대상 카페의 ID"
 *               rating:
 *                 type: string
 *                 description: "평점"
 *               comment:
 *                 type: string
 *                 description: "리뷰 코멘트"
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
 *                 msg:
 *                   type: string
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
 */
reviewRouter.route('/api/create/review').post(createReview);

/**
 * @swagger
 * /api/review/{cafeId}:
 *   get:
 *     tags: [Review API]
 *     summary: 카페별 리뷰 조회
 *     description: 특정 카페에 대한 모든 리뷰를 조회합니다.
 *     parameters:
 *       - in: path
 *         name: cafeId
 *         required: true
 *         description: 리뷰를 조회할 카페의 ID
 *         schema:
 *           type: string
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
 *                 msg:
 *                   type: string
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       review_id:
 *                         type: number
 *                       cafe_id:
 *                         type: number
 *                       rating:
 *                         type: number
 *                       comment:
 *                         type: string
 *             example:
 *               ok: true
 *               msg: "리뷰 조회 성공"
 *               data:
 *                 - review_id: 1
 *                   cafe_id: 1
 *                   rating: 5
 *                   comment: "너무좋아요!~!!"
 *                 - review_id: 2
 *                   cafe_id: 1
 *                   rating: 5
 *                   comment: "여기서 공부하고싶어요 !"
 *                 - review_id: 3
 *                   cafe_id: 1
 *                   rating: 4
 *                   comment: "여기 공부하기 좋아여!~~"
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
 *                 message: "리뷰 조회 중 에러가 발생했습니다."
 */
reviewRouter.route('/api/review/:cafeId').get(getReviewEachCafe);


/**
 * @swagger
 * /api/modify/{reviewId}:
 *   put:
 *     tags: [Review API]
 *     summary: 리뷰 수정
 *     description: 특정 리뷰를 수정합니다.
 *     parameters:
 *       - in: path
 *         name: reviewId
 *         required: true
 *         description: 수정할 리뷰의 ID
 *         schema:
 *           type: number
 *     requestBody:
 *       description: 수정할 리뷰 정보를 전달합니다.
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               rating:
 *                 type: string
 *                 description: "수정할 평점"
 *               comment:
 *                 type: string
 *                 description: "수정할 리뷰 코멘트"
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
 *                 msg:
 *                   type: string
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
 *                 message: "리뷰 수정 중 에러가 발생했습니다."
 */
reviewRouter.route('/api/modify/:reviewId').put(modifyReview);



/**
 * @swagger
 * /api/delete/{reviewId}:
 *   delete:
 *     tags: [Review API]
 *     summary: 리뷰 삭제
 *     description: 특정 리뷰를 삭제합니다.
 *     parameters:
 *       - in: path
 *         name: reviewId
 *         required: true
 *         description: 삭제할 리뷰의 ID
 *         schema:
 *           type: number
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
 *                 msg:
 *                   type: string
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
 *                 message: "리뷰 삭제 중 에러가 발생했습니다."
 */
reviewRouter.route('/api/delete/:reviewId').delete(deleteReview);

export default reviewRouter;