import express from 'express';
import { createCommunity, getCommunity, getCommunityInfo, createPost, modfiyPost, deletePost } from '../../controller/community/communityController.js';

const communityRouter = express.Router();


communityRouter.route('/api/community/create').post(createCommunity);
communityRouter.route('/api/community').get(getCommunity);
communityRouter.route('/api/community/:id').get(getCommunityInfo);
communityRouter.route('/api/create/post/:communityId').post(createPost);
communityRouter.route('/api/modify/post/:id').put(modfiyPost);
communityRouter.route('/api/delete/post/:id').delete(deletePost);

export default communityRouter;