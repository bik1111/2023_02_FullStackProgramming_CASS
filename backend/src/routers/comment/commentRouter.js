import express from 'express';
import { getComment, createComment, modifyComment, deleteComment } from '../../controller/comment/commentController.js';

const commentRouter = express.Router();

commentRouter.route('/api/comment/get/:communityId/:contentId').get(getComment);
commentRouter.route('/api/comment/create/:communityId/:contentId').post(createComment);
commentRouter.route('/api/comment/modify/:communityId/:contentId/:commentId').put(modifyComment);
commentRouter.route('/api/comment/delete/:communityId/:contentId/:commentId').delete(deleteComment);

export default commentRouter;