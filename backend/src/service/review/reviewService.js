import pool from "../../config/database.js";
import { createReviewInCafeDAO, getReviewEachCafeDAO,
    modifyReviewInCafeDAO, deleteReviewInCafeDAO } from "../../dao/review/review.js";

export const createReviewInCafe = async (cafe_id, rating, comment) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const createReviewResult = await createReviewInCafeDAO(connection, cafe_id, rating, comment);
    connection.release();

    return createReviewResult;
}

export const getReview = async (cafeId) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const getReviewResult = await getReviewEachCafeDAO(connection, cafeId);
    connection.release();

    return getReviewResult;
}

export const modifyReviewInCafe = async (reviewId, rating, comment) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const modifyReviewResult = await modifyReviewInCafeDAO(connection, reviewId, rating, comment);
    connection.release();

    return modifyReviewResult;

}

export const deleteReviewInCafe = async (reviewId) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const deleteReviewResult = await deleteReviewInCafeDAO(connection, reviewId);
    connection.release();

    return deleteReviewResult;
}