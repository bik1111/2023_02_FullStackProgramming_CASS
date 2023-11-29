import pool from "../../config/database.js";
import { createMyCommunityDAO, getMyCommunityDAO, getMyCommunityBoardInfoDAO, createPostInCommunityDAO } from "../../dao/community/community.js";

export const createMyCommunity = async (title, hashtags) => {

    const connection = await pool.getConnection(async (conn) => conn);
    const createMyCommunityResult = await createMyCommunityDAO(connection, title, hashtags);
    connection.release();

    return createMyCommunityResult;

}

export const getMyCommunity = async () => {

    const connection = await pool.getConnection(async (conn) => conn);
    const getMyCommunityResult = await getMyCommunityDAO(connection);
    connection.release();

    return getMyCommunityResult;

}

export const getMyCommunityBoardInfo = async (id) => {

        const connection = await pool.getConnection(async (conn) => conn);
        const getMyCommunityBoardInfoResult = await getMyCommunityBoardInfoDAO(connection, id);
        connection.release();

        return getMyCommunityBoardInfoResult;
}

export const createPostInCommunity = async (title, content, communityId) => {

        const connection = await pool.getConnection(async (conn) => conn);
        const createPostInCommunityResult = await createPostInCommunityDAO(connection, title, content, communityId);
        connection.release();

        return createPostInCommunityResult;

}

