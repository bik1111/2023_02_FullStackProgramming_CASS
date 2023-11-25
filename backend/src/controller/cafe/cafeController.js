import { getCafe, addMyFavoriteCafeInfo } from '../../service/cafe/cafeService.js';


export const getCafeByCafeName =  async (req, res) => {
    const { cafeName } = req.query;
    const getCafeResult = await getCafe(cafeName);
    console.log(cafeName);

    return res.status(200).json({
        ok: true,
        msg: "카페 검색 성공",
        data: getCafeResult
    })

}


export const addMyFavoriteCafe = async (req, res) => {
    const { cafeId } = req.body;
    const addMyFavoriteCafeResult = await addMyFavoriteCafeInfo(cafeId);

}