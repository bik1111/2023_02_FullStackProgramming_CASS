import express from 'express';
import { getCafeByCafeName, addMyFavoriteCafe } from "../../controller/cafe/cafeController.js"
const cafeRouter = express.Router();

cafeRouter.route('/api/cafe/search').get(getCafeByCafeName);
cafeRouter.route('/api/cafe/add').post(addMyFavoriteCafe);


export default cafeRouter;