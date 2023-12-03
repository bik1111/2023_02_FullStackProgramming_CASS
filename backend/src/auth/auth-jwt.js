import dotenv from 'dotenv';
dotenv.config();
import jwt from "jsonwebtoken";
import { redisClient } from "../util/cache.js"
import { promisify } from "util";


export const sign = (user) => {
  const payload = {
    id: user.user_id,
  };


  return jwt.sign(payload, process.env.JWT_SECRET, {
    algorithm: 'HS256',
    expiresIn: '1h',
    issuer: 'cass',
  });
};

export const verify = (token) => {
  let decoded = null;

  try {
    decoded = jwt.verify(token, process.env.JWT_SECRET);

    return {
      ok: true,
      id: decoded.id,

    };
  } catch (err) {
    return {
      ok: false,
      message: err.message,
    };
  }
};

export const refresh = () => {
  return jwt.sign({}, process.env.JWT_SECRET, {
    algorithm: 'HS256',
    expiresIn: '30m',
    issuer: 'cass',
  });
};

export const refreshVerify = async (token, email) => {
  const getAsync = promisify(redisClient.get).bind(redisClient);
  try {
    const data = await getAsync(email);
    if (token === data) {
      return {
        ok: true,
      };
    } else {
      return {
        ok: false,
      };
    }
  } catch (err) {
    return {
      ok: false,
    };
  }
};
