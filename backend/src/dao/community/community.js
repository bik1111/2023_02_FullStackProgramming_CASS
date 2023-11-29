
export const createMyCommunityDAO = async (connection, title, hashtags) => {
    const createMyCommunityQuery = `
        INSERT INTO community (title, hashtags, createdAt) VALUES (?, ?, UTC_TIMESTAMP());
    `;
    const createMyCommunityParams = [title, hashtags];
    const [createMyCommunityRows] = await connection.query(createMyCommunityQuery, createMyCommunityParams);

    return createMyCommunityRows;
}


export const getMyCommunityDAO = async (connection) => {

    const getMyCommunityQuery = `
        select community_id, title, hashtags, createdAt
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