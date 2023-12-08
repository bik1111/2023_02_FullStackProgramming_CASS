import express from 'express';
import { createCommunity, getCommunity, getCommunityInfo, createPost, modfiyPost, deletePost } from '../../controller/community/communityController.js';
import imgUpload from "../../util/aws-s3.js";

const communityRouter = express.Router();

/**
 * @swagger
 * tags:
 *   name: Community API
 *   description: 커뮤니티 관련 API
 */

/**
 * @swagger
 * /api/community/create:
 *   post:
 *     tags: [Community API]
 *     summary: 커뮤니티 생성
 *     description: 새로운 커뮤니티를 생성합니다.
 *     requestBody:
 *       description: 커뮤니티 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 description: "커뮤니티 이름"
 *               hashtags:
 *                 type: string
 *                 description: "커뮤니티 설명"
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
 *                 data:
 *                   type: object
 *                   properties:
 *                     message:
 *                       type: string
 *             example:
 *               ok: true
 *               data:
 *                 message: "커뮤니티가 성공적으로 생성되었습니다."
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
 *                 message: "커뮤니티 생성 중 에러가 발생했습니다."
 */
communityRouter.route('/api/community/create').post(imgUpload.single("img"), createCommunity);

/**
 * @swagger
 * /api/community:
 *   get:
 *     tags: [Community API]
 *     summary: 모든 커뮤니티 조회
 *     description: 모든 커뮤니티의 정보를 조회합니다.
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
 *                       community_id:
 *                         type: number
 *                       content_id:
 *                         type: number
 *                       content_title:
 *                         type: string
 *                       content_detail:
 *                         type: string
 *                       community_title:
 *                         type: string
 *             example:
 *               ok: true
 *               msg: "커뮤니티 조회 성공"
 *               data:
 *                 - community_id: 1
 *                   content_id: 4
 *                   content_title: "오늘 모일 사람!!???!"
 *                   content_detail: "공부하쟝"
 *                   community_title: "사랑"
 *                 - community_id: 1
 *                   content_id: 5
 *                   content_title: "공부하쟈"
 *                   content_detail: "오늘!!?"
 *                   community_title: "사랑"
 *                 - community_id: 1
 *                   content_id: 7
 *                   content_title: "오늘"
 *                   content_detail: "공부하실분!"
 *                   community_title: "사랑"
 *                 - community_id: 1
 *                   content_id: 15
 *                   content_title: "혹시 오늘 카공하실분?"
 *                   content_detail: "혼자하기 심심해요 ㅠ.ㅠ"
 *                   community_title: "사랑"
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
 *                 message: "커뮤니티 정보 조회 중 에러가 발생했습니다."
 */
communityRouter.route('/api/community').get(getCommunity);

/**
 * @swagger
 * /api/community/{id}:
 *   get:
 *     tags: [Community API]
 *     summary: 커뮤니티 정보 조회
 *     description: 특정 커뮤니티의 정보를 조회합니다.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: 조회할 커뮤니티의 ID
 *         schema:
 *           type: integer
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
 *                 data:
 *                   type: object
 *                   properties:
 *                     community_id:
 *                       type: number
 *                     name:
 *                       type: string
 *                     description:
 *                       type: string
 *             example:
 *               ok: true
 *               data:
 *                 community_id: 1
 *                 name: "Programming"
 *                 description: "Discuss programming languages and techniques."
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
 *                 message: "커뮤니티 정보 조회 중 에러가 발생했습니다."
 */
communityRouter.route('/api/community/:id').get(getCommunityInfo);

/**
 * @swagger
 * /api/create/post/{communityId}:
 *   post:
 *     tags: [Community API]
 *     summary: 게시물 생성
 *     description: 특정 커뮤니티에 새로운 게시물을 생성합니다.
 *     parameters:
 *       - in: path
 *         name: communityId
 *         required: true
 *         description: 게시물을 생성할 커뮤니티의 ID
 *         schema:
 *           type: integer
 *     requestBody:
 *       description: 게시물 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 description: "게시물 제목"
 *               content:
 *                 type: string
 *                 description: "게시물 내용"
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
 *                 data:
 *                   type: object
 *                   properties:
 *                     message:
 *                       type: string
 *             example:
 *               ok: true
 *               data:
 *                 message: "게시물이 성공적으로 생성되었습니다."
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
 *                 message: "게시물 생성 중 에러가 발생했습니다."
 */
communityRouter.route('/api/create/post/:communityId').post(createPost);


/**
 * @swagger
 * /api/modify/post/{id}:
 *   put:
 *     tags: [Community API]
 *     summary: 게시물 수정
 *     description: 특정 게시물을 수정합니다.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: 수정할 게시물의 ID
 *         schema:
 *           type: integer
 *     requestBody:
 *       description: 수정된 게시물 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 description: "수정된 게시물 제목"
 *               content:
 *                 type: string
 *                 description: "수정된 게시물 내용"
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
 *                 data:
 *                   type: object
 *                   properties:
 *                     message:
 *                       type: string
 *             example:
 *               ok: true
 *               data:
 *                 message: "게시물이 성공적으로 수정되었습니다."
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
 *                 message: "게시물 수정 중 에러가 발생했습니다."
 */
communityRouter.route('/api/modify/post/:id').put(modfiyPost);


/**
 * @swagger
 * /api/delete/post/{id}:
 *   delete:
 *     tags: [Community API]
 *     summary: 게시물 삭제
 *     description: 특정 게시물을 삭제합니다.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: 삭제할 게시물의 ID
 *         schema:
 *           type: integer
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
 *                 data:
 *                   type: object
 *                   properties:
 *                     message:
 *                       type: string
 *             example:
 *               ok: true
 *               data:
 *                 message: "게시물이 성공적으로 삭제되었습니다."
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
 *                 message: "게시물 삭제 중 에러가 발생했습니다."
 */
communityRouter.route('/api/delete/post/:id').delete(deletePost);

export default communityRouter;