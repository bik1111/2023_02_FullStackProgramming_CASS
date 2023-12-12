import pool from "../../config/database.js"
import { findCafeInfo, addMyFavoriteCafe, getAllCafeInfoDAO } from "../../dao/cafe/cafeDao.js";

export const getCafe = async (cafeName) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const searchCafeRes = await findCafeInfo(connection, cafeName);
    connection.release();

    return searchCafeRes;

}

export const addMyFavoriteCafeInfo = async (cafeId) => {
    const connection = await pool.getConnection(async (conn) => conn);
    const addMyFavoriteCafeRes = await addMyFavoriteCafe(connection, cafeId);
    connection.release();

    return addMyFavoriteCafeRes;

}

export const getAllCafeInfo = async () => {
    const connection = await pool.getConnection(async (conn) => conn);
    const getAllCafeInfoRes = await getAllCafeInfoDAO(connection);
    connection.release();

    return getAllCafeInfoRes;
}

