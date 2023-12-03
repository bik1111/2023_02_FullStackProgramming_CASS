import redis from "redis";
import dotenv from 'dotenv';
import util from 'util';

dotenv.config();

export const redisClient = redis.createClient({
  legacyMode: true,
  host: 'redis'
});

const redisSetAsync = util.promisify(redisClient.set).bind(redisClient);
const redisGetAsync = util.promisify(redisClient.get).bind(redisClient);

redisClient.on('error', (err) => {
  console.log(`Redis error: ${err}`);
  // Handle the error as needed, but don't close the client here
});

export const set = async (key, value) => {
  try {
    await redisSetAsync(key, JSON.stringify(value));
  } catch (error) {
    console.error('Redis set error:', error);
    // Handle the error as needed, but don't close the client here
  }
};

export const get = async (req, res, next) => {
  let key = req.originalUrl;

  try {
    const data = await redisGetAsync(key);

    if (data !== null) {
      console.log('data from redis!');
      res.status(200).send({
        ok: true,
        data: JSON.parse(data),
      });
    } else {
      next();
    }
  } catch (error) {
    console.error('Redis error:', error);
    res.status(400).send({
      ok: false,
      message: error.message,
    });
  }
};
