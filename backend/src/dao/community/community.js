
export const createMyCommunityDAO = async (connection, title, hashtags, img_url) => {
    const createMyCommunityQuery = `
        INSERT INTO community (title, hashtags, community_img, createdAt) VALUES (?, ?, ?, UTC_TIMESTAMP());
    `;
    const createMyCommunityParams = [title, hashtags, img_url];
    const [createMyCommunityRows] = await connection.query(createMyCommunityQuery, createMyCommunityParams);

    return createMyCommunityRows;
}


export const getMyCommunityDAO = async (connection) => {

    const getMyCommunityQuery = `
        select community_id, title, hashtags, createdAt, community_img
        from community
    `;
    const [getMyCommunityRows] = await connection.query(getMyCommunityQuery);

    return getMyCommunityRows;
}

export const getMyCommunityBoardInfoDAO = async (connection, id) => {

    const getMyCommunityBoardInfoQuery = `
        SELECT cb.community_id, cb.content_id, cb.content_title, cb.content_detail, c.title as community_title
        FROM community_board cb
        JOIN community c ON cb.community_id = c.community_id
        WHERE cb.community_id = ?
    `;
    const [getMyCommunityBoardInfoRows] = await connection.query(getMyCommunityBoardInfoQuery, id);

    return getMyCommunityBoardInfoRows;
}

export const createPostInCommunityDAO = async (connection, title, content, communityId) => {
    const createPostInCommunityQuery = `
        INSERT INTO community_board (content_title, content_detail, community_id, createdAt) VALUES (?, ?, ?, UTC_TIMESTAMP());
    `;
    const createPostInCommunityParams = [title, content, communityId];
    const [createPostInCommunityRows] = await connection.query(createPostInCommunityQuery, createPostInCommunityParams);

    return createPostInCommunityRows;
}

export const modifyPostDAO = async (connection, title, content, id) => {
    const modifyPostQuery = `
        UPDATE community_board SET content_title = ?, content_detail = ?, createdAt = UTC_TIMESTAMP() WHERE content_id = ?;
    `;
    const modifyPostParams = [title, content, id];
    const [modifyPostRows] = await connection.query(modifyPostQuery, modifyPostParams);

    return modifyPostRows;
}

export const deletePostDAO = async (connection, id) => {
    const deletePostQuery = `
        DELETE FROM community_board WHERE content_id = ?;
    `;
    const deletePostParams = [id];
    const [deletePostRows] = await connection.query(deletePostQuery, deletePostParams);

    return deletePostRows;
}