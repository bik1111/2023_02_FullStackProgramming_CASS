
export const createReviewInCafeDAO = async (connection, cafe_id, rating, comment) => {
    const createReviewResultQuery = `INSERT INTO review (cafe_id, rating, comment) VALUES (?, ?, ?);`;
    const createReviewResultParams = [cafe_id, rating, comment];
    const [createReviewResult] = await connection.query(createReviewResultQuery, createReviewResultParams);
    return createReviewResult;

}

export const getReviewEachCafeDAO = async (connection, cafeId) => {
    const getReviewResultQuery = `
        SELECT review_id, cafe_id, rating, comment
        FROM review
        WHERE cafe_id = ?
    `;
    const [getReviewResult] = await connection.query(getReviewResultQuery, cafeId);

    return getReviewResult;
}

export const modifyReviewInCafeDAO = async (connection, reviewId, rating, comment) =>

{
    const modifyReviewResultQuery = `
        UPDATE review SET rating = ?, comment = ? WHERE review_id = ?;
    `;
    const modifyReviewResultParams = [rating, comment, reviewId];
    const [modifyReviewResult] = await connection.query(modifyReviewResultQuery, modifyReviewResultParams);

    return modifyReviewResult;
}

export const deleteReviewInCafeDAO = async (connection, reviewId) => {
    const deleteReviewResultQuery = `
        DELETE FROM review WHERE review_id = ?;
    `;
    const deleteReviewResultParams = [reviewId];
    const [deleteReviewResult] = await connection.query(deleteReviewResultQuery, deleteReviewResultParams);

    return deleteReviewResult;
}