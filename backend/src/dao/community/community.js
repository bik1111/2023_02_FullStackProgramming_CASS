
export const createMyCommunityDAO = async (connection, title, hashtags) => {
    const createMyCommunityQuery = `
        insert into community (title, hashtags) values (?, ?);
    `;
    const createMyCommunityParams = [title, hashtags];
    const [createMyCommunityRows] = await connection.query(createMyCommunityQuery, createMyCommunityParams);

    return createMyCommunityRows;
}