import express from 'express';
import { getCafeByCafeName, addMyFavoriteCafe, getAllCafeInformation } from "../../controller/cafe/cafeController.js"
const cafeRouter = express.Router();

cafeRouter.route('/api/cafe/search').get(getCafeByCafeName);
cafeRouter.route('/api/cafe/add').post(addMyFavoriteCafe);
cafeRouter.route('/api/cafe/').get(getAllCafeInformation)


export default cafeRouter;