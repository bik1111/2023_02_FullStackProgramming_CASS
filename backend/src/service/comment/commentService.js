import pool from "../../config/database.js";
import { createCommentInPostDAO, modifyCommentInPostDAO, deleteCommentInPostDAO, getCommentInPostDAO } from "../../dao/comment/comment.js";

export const getCommentInPost = async (communityId, contentId) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const getCommentResult = await getCommentInPostDAO(connection, communityId, contentId);
    connection.release();

    return getCommentResult;

}

export const createCommentInPost = async (communityId, contentId, content) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const createCommentResult = await createCommentInPostDAO(connection, communityId,contentId, content);
    connection.release();

    return createCommentResult;
}

export const modifyCommentInPost = async (communityId, contentId, commentId, content) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const modifyCommentResult = await modifyCommentInPostDAO(connection, communityId, contentId, commentId, content);
    connection.release();

    return modifyCommentResult;
}

export const deleteCommentInPost = async (communityId, contentId, commentId) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const deleteCommentResult = await deleteCommentInPostDAO(connection, communityId, contentId, commentId);
    connection.release();

    return deleteCommentResult;
}