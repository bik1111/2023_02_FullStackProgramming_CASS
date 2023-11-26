import pool from "../../config/database.js";
import { createMyCommunityDAO } from "../../dao/community/community.js";

export const createMyCommunity = async (title, hashtags) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const createMyCommunityResult = await createMyCommunityDAO(connection, title, hashtags);
    connection.release();

    return createMyCommunityResult;

}