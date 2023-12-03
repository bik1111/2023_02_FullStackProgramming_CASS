export const createUserDAO = async (connection, username, password) => {
    const createUserQuery = `
        INSERT INTO User(name, password) VALUES (?, ?);
    `;
    const createUserParams = [username, password];
    const [createUserRows] = await connection.query(createUserQuery, createUserParams);
    return createUserRows;
}

export const getUserDAO = async (connection, username) => {
    const getUserQuery = `
        SELECT * FROM User WHERE name = ?;
    `;
    const getUserParams = [username];
    const [getUserRows] = await connection.query(getUserQuery, getUserParams);
    return getUserRows;
}