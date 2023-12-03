import express from 'express';
import { createNewUser, login } from '../../controller/user/userController.js';
const userRouter = express.Router();

userRouter.route('/api/user/register').post(createNewUser);
userRouter.route('/api/user/login').post(login);

export default userRouter;