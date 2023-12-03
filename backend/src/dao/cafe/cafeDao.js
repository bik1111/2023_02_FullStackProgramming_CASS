
export const findCafeInfo = async (connection, cafeName) => {

    const getCafeInfoQuery = `SELECT cafe_id, name, address, number FROM cafe WHERE name LIKE '%${cafeName}%';
    `;

    const [getCafeInfoRow] = await connection.query(
        getCafeInfoQuery, [cafeName]
    );

    return getCafeInfoRow;

}

export const addMyFavoriteCafe = async (connection, cafeId) => {

        const addMyFavoriteCafeQuery = `INSERT INTO favorite_cafe (user_id, cafe_id) VALUES (1, ?);`;

        const [addMyFavoriteCafeRow] = await connection.query(
            addMyFavoriteCafeQuery, [cafeId]
        );

        return addMyFavoriteCafeRow;
}

export const getAllCafeInfoDAO = async (connection) => {
        const getAllCafeInfoQuery = `
            SELECT cafe_id, name, address, number, lat, lng FROM cafe;
        `;
        const [getAllCafeInfoRows] = await connection.query(getAllCafeInfoQuery);

        return getAllCafeInfoRows;
}