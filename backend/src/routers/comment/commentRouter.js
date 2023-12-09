import express from 'express';
import { getComment, createComment, modifyComment, deleteComment } from '../../controller/comment/commentController.js';

const commentRouter = express.Router();

/**
 * @swagger
 * /api/comment/get/{communityId}/{contentId}:
 *   get:
 *     tags: [Comment API]
 *     summary: 댓글 조회
 *     description: 특정 커뮤니티 게시물에 대한 댓글을 조회합니다.
 *     parameters:
 *       - in: path
 *         name: communityId
 *         required: true
 *         description: 댓글이 속한 커뮤니티의 ID
 *         schema:
 *           type: integer
 *       - in: path
 *         name: contentId
 *         required: true
 *         description: 댓글이 속한 게시물의 ID
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
 *                 msg:
 *                   type: string
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       comment_id:
 *                         type: number
 *                       user_id:
 *                         type: number
 *                       content:
 *                         type: string
 *                       created_at:
 *                         type: string
 *             example:
 *               ok: true
 *               msg: "댓글 조회 성공"
 *               data:
 *                 - comment_id: 1
 *                   community_id: 1
 *                   user_id: 123
 *                   content_id : 5
 *                   content: "좋아요!"
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
 *                 message: "댓글 정보 조회 중 에러가 발생했습니다."
 */
commentRouter.route('/api/comment/get/:communityId/:contentId').get(getComment);


/**
 * @swagger
 * /api/comment/create/{communityId}/{contentId}:
 *   post:
 *     tags: [Comment API]
 *     summary: 댓글 생성
 *     description: 특정 커뮤니티 게시물에 새로운 댓글을 생성합니다.
 *     parameters:
 *       - in: path
 *         name: communityId
 *         required: true
 *         description: 댓글을 생성할 커뮤니티의 ID
 *         schema:
 *           type: integer
 *       - in: path
 *         name: contentId
 *         required: true
 *         description: 댓글을 생성할 게시물의 ID
 *         schema:
 *           type: integer
 *     requestBody:
 *       description: 댓글 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               user_id:
 *                 type: number
 *                 description: "댓글 작성자의 ID"
 *               content:
 *                 type: string
 *                 description: "댓글 내용"
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
 *                 message: "댓글이 성공적으로 생성되었습니다."
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
 *                 message: "댓글 생성 중 에러가 발생했습니다."
 */
commentRouter.route('/api/comment/create/:communityId/:contentId').post(createComment);



/**
 * @swagger
 * /api/comment/modify/{communityId}/{contentId}/{commentId}:
 *   put:
 *     tags: [Comment API]
 *     summary: 댓글 수정
 *     description: 특정 커뮤니티 게시물의 댓글을 수정합니다.
 *     parameters:
 *       - in: path
 *         name: communityId
 *         required: true
 *         description: 댓글이 속한 커뮤니티의 ID
 *         schema:
 *           type: integer
 *       - in: path
 *         name: contentId
 *         required: true
 *         description: 댓글이 속한 게시물의 ID
 *         schema:
 *           type: integer
 *       - in: path
 *         name: commentId
 *         required: true
 *         description: 수정할 댓글의 ID
 *         schema:
 *           type: integer
 *     requestBody:
 *       description: 수정된 댓글 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               content:
 *                 type: string
 *                 description: "수정된 댓글 내용"
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
 *                 message: "댓글이 성공적으로 수정되었습니다."
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
 *                 message: "댓글 수정 중 에러가 발생했습니다."
 */
commentRouter.route('/api/comment/modify/:communityId/:contentId/:commentId').put(modifyComment);

/**
 * @swagger
 * /api/comment/delete/{communityId}/{contentId}/{commentId}:
 *   delete:
 *     tags: [Comment API]
 *     summary: 댓글 삭제
 *     description: 특정 커뮤니티 게시물의 댓글을 삭제합니다.
 *     parameters:
 *       - in: path
 *         name: communityId
 *         required: true
 *         description: 댓글이 속한 커뮤니티의 ID
 *         schema:
 *           type: integer
 *       - in: path
 *         name: contentId
 *         required: true
 *         description: 댓글이 속한 게시물의 ID
 *         schema:
 *           type: integer
 *       - in: path
 *         name: commentId
 *         required: true
 *         description: 삭제할 댓글의 ID
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
 *                 message: "댓글이 성공적으로 삭제되었습니다."
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
 *                 message: "댓글 삭제 중 에러가 발생했습니다."
 */
commentRouter.route('/api/comment/delete/:communityId/:contentId/:commentId').delete(deleteComment);

export default commentRouter;