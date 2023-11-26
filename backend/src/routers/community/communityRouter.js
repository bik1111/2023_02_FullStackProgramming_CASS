import express from 'express';
import { createCommunity } from '../../controller/community/communityController.js';

const communityRouter = express.Router();


communityRouter.route('/api/community/create').post(createCommunity);

export default communityRouter;