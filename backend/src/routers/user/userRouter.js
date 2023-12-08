import express from 'express';
import { createNewUser, login } from '../../controller/user/userController.js';
const userRouter = express.Router();

/**
 * @swagger
 * tags:
 *   name: User API
 *   description: 사용자 등록 및 로그인 API
 */

/**
 * @swagger
 * /api/user/register:
 *   post:
 *     tags: [User API]
 *     summary: 사용자 등록
 *     description: 새로운 사용자를 등록합니다. 이메일, 비밀번호, 연락처, 연령대를 전달합니다.
 *     requestBody:
 *       description: 사용자 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               username:
 *                 type: string
 *                 description: "사용자 이름"
 *               password:
 *                 type: string
 *                 description: "비밀번호"
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
 *                     token:
 *                       type: string
 *             example:
 *               ok: true
 *               data:
 *                 token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzAxODI4NjkzLCJleHAiOjE3MDE4MzIyOTMsImlzcyI6ImNhc3MifQ.MSIWTuZgdd3dbe_W9EHrtS1n4aiuCl3QGeeqWNTOSo8"
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
 *                 message: "사용자 등록 중 에러가 발생했습니다."
 */

userRouter.route('/api/user/register').post(createNewUser);

/**
 * @swagger
 * /api/user/login:
 *   post:
 *     tags: [User API]
 *     summary: 사용자 로그인
 *     description: 등록된 사용자를 로그인합니다. 사용자 이름과 비밀번호를 전달합니다.
 *     requestBody:
 *       description: 사용자 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               usernam:
 *                 type: string
 *                 description: "사용자 이름"
 *               password:
 *                 type: string
 *                 description: "비밀번호"
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
 *                     token:
 *                       type: string
 *             example:
 *               ok: true
 *               data:
 *                 token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzAxODI4NjkzLCJleHAiOjE3MDE4MzIyOTMsImlzcyI6ImNhc3MifQ.MSIWTuZgdd3dbe_W9EHrtS1n4aiuCl3QGeeqWNTOSo8"
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
 *                 message: "사용자 로그인 중 에러가 발생했습니다."
 */
userRouter.route('/api/user/login').post(login);

export default userRouter;