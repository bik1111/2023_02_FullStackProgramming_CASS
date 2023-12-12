import express from 'express';
import { getCafeByCafeName, addMyFavoriteCafe, getAllCafeInformation, getAllCafeInformationWithPaging } from "../../controller/cafe/cafeController.js"
const cafeRouter = express.Router();

/**
 * @swagger
 * tags:
 *   name: Cafe API
 *   description: 카페 검색 및 관리 API
 */

/**
 * @swagger
 * /api/cafe/search:
 *   get:
 *     tags: [Cafe API]
 *     summary: 카페 검색
 *     description: 지정된 카페 이름으로 카페를 검색합니다.
 *     parameters:
 *       - in: query
 *         name: cafeName
 *         required: true
 *         description: 검색할 카페 이름
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
 *                 data:
 *                   type: object
 *                   properties:
 *                     cafe_id:
 *                       type: string
 *                     name:
 *                       type: string
 *                     address:
 *                      type: string
 *                     number:
 *                      type: number
 *             example:
 *               ok: true
 *               data:
 *                 cafe_id: "218"
 *                 name: "송파나루역DT"
 *                 address: "서울특별시 송파구 오금로 142 (송파동)"
 *                 number: "1522-3222"
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
 *                 message: "카페 검색 중 에러가 발생했습니다."
 */
cafeRouter.route('/api/cafe/search').get(getCafeByCafeName);


/**
 * @swagger
 * /api/cafe/add:
 *   post:
 *     tags: [Cafe API]
 *     summary: 즐겨찾는 카페 추가
 *     description: 사용자가 지정한 카페를 즐겨찾는 카페 목록에 추가합니다.
 *     requestBody:
 *       description: 즐겨찾는 카페 정보
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               cafeName:
 *                 type: string
 *                 description: "즐겨찾는 카페 이름"
 *               cafeLocation:
 *                 type: string
 *                 description: "즐겨찾는 카페 위치"
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
 *             example:
 *               ok: true
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
 *                 message: "즐겨찾는 카페 추가 중 에러가 발생했습니다."
 */
cafeRouter.route('/api/cafe/add').post(addMyFavoriteCafe);
/**
 * @swagger
 * /api/cafe/:
 *   get:
 *     tags: [Cafe API]
 *     summary: 모든 카페 정보 조회
 *     description: 모든 카페의 정보를 조회합니다.
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
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       cafeName:
 *                         type: string
 *                       location:
 *                         type: string
 *             example:
 *               ok: true
 *               data:
 *                 - cafe_id: 1
 *                   name: "역삼아레나빌딩"
 *                   address: "서울특별시 강남구 언주로 425(역삼동)1522-3232"
 *                   number: "1522-3232"
 *                   lat: "37.501087"
 *                   lng: "127.043069"
 *                 - cafe_id: 2
 *                   name: "논현역사거리"
 *                   address: "서울특별시 강남구 강남대로 538 (논현동)1522-3232"
 *                   number: "1522-3232"
 *                   lat: "37.510178"
 *                   lng: "127.022223"
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
 *                 message: "카페 정보 조회 중 에러가 발생했습니다."
 */
cafeRouter.route('/api/cafe/').get(getAllCafeInformation)



/**
 * @swagger
 * /api/cafe/{page}:
 *   get:
 *     tags: [Cafe API]
 *     summary: 모든 카페 정보 조회 (페이징)
 *     description: 페이징을 적용하여 모든 카페의 정보를 조회합니다.
 *     parameters:
 *       - in: path
 *         name: page
 *         required: true
 *         description: 페이지 번호
 *         schema:
 *           type: integer
 *           minimum: 1
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
 *                   type: object
 *                   properties:
 *                     startPage:
 *                       type: integer
 *                     endPage:
 *                       type: integer
 *                     totalPage:
 *                       type: integer
 *                     currPage:
 *                       type: string
 *                     myresult:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           cafe_id:
 *                             type: integer
 *                           name:
 *                             type: string
 *                           address:
 *                             type: string
 *                           number:
 *                             type: string
 *                           lat:
 *                             type: string
 *                           lng:
 *                             type: string
 *             example:
 *               ok: true
 *               msg: "카페 정보 조회 성공"
 *               data:
 *                 startPage: 1
 *                 endPage: 10
 *                 totalPage: 61
 *                 currPage: "1"
 *                 myresult:
 *                   - cafe_id: 1
 *                     name: "역삼아레나빌딩"
 *                     address: "서울특별시 강남구 언주로 425 (역삼동)1522-3232"
 *                     number: "1522-3232"
 *                     lat: "37.501087"
 *                     lng: "127.043069"
 *                   - cafe_id: 2
 *                     name: "논현역사거리"
 *                     address: "서울특별시 강남구 강남대로 538 (논현동)1522-3232"
 *                     number: "1522-3232"
 *                     lat: "37.510178"
 *                     lng: "127.022223"
 *                   # ... (additional cafe entries)
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
 *                 message: "카페 정보 조회 중 에러가 발생했습니다."
 */
cafeRouter.route('/api/cafe/:page/').get(getAllCafeInformationWithPaging);


export default cafeRouter;