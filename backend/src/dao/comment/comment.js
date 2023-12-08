export const getCommentInPostDAO = async (connection, communityId, contentId) => {
    const getCommentQuery = `
        SELECT comment_id, content, content_id, community_id
        FROM comment
        WHERE community_id = ? AND content_id = ?;
    `;
    const getCommentParams = [communityId, contentId];
    const [getCommentRows] = await connection.query(getCommentQuery, getCommentParams);

    return getCommentRows;

}

export const createCommentInPostDAO = async (connection, communityId, contentId,  content) => {
    const createCommentQuery = `
        INSERT INTO comment(content_id, community_id, content)
        VALUES (?, ?, ?);
    `;
    const createCommentParams = [contentId, communityId, content];
    const [createCommentRows] = await connection.query(createCommentQuery, createCommentParams);

    return createCommentRows;
}

export const modifyCommentInPostDAO = async (connection, communityId, contentId, commentId,  content) => {
    const modifyCommentQuery = `
        UPDATE comment
        SET content = ?
        WHERE community_id = ? AND content_id = ? AND comment_id = ?;
    `;
    const modifyCommentParams = [content, communityId, contentId, commentId];
    const [modifyCommentRows] = await connection.query(modifyCommentQuery, modifyCommentParams);

    return modifyCommentRows;
}

export const deleteCommentInPostDAO = async (connection, communityId, contentId, commentId) => {
    const deleteCommentQuery = `
        DELETE FROM comment
        WHERE community_id = ? AND content_id = ? AND comment_id = ?;
    `;

    const deleteCommentParams = [communityId, contentId, commentId];
    const [deleteCommentRows] = await connection.query(deleteCommentQuery, deleteCommentParams);

    return deleteCommentRows;
}