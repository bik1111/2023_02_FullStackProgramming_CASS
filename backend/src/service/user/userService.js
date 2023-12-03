import pool from "../../config/database.js";
import { createUserDAO, getUserDAO } from "../../dao/user/user.js";

export const createUser = async (username, password) => {

    const connection = await pool.getConnection(async (conn) => conn);
    const createUserResult = await createUserDAO(connection, username, password);
    connection.release();

    return createUserResult;
}

export const getUser = async (username) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const getUserResult = await getUserDAO(connection, username);
    connection.release();

    return getUserResult;
}