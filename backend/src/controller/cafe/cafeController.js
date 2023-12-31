// cafeController.js

import { getCafe, addMyFavoriteCafeInfo, getAllCafeInfo } from '../../service/cafe/cafeService.js';
import { pagination } from '../../util/paging.js';

export const getCafeByCafeName =  async (req, res) => {
  try {
    const { cafeName } = req.query;
    const getCafeResult = await getCafe(cafeName);

    return res.status(200).json({
      ok: true,
      msg: "카페 검색 성공",
      data: getCafeResult
    });
  } catch (error) {
    console.log(error);
    return res.status(404).json({
      ok: false,
      msg: "카페 검색 중 에러가 발생했습니다.",
      error
    });
  }
};

export const addMyFavoriteCafe = async (req, res) => {
  try {
    const { cafeId } = req.body;
    const addMyFavoriteCafeResult = await addMyFavoriteCafeInfo(cafeId);

    return res.status(200).json({
      ok: true,
      msg: "카페 추가 성공",
      data: addMyFavoriteCafeResult
    });

  } catch (error) {
    console.log(error);
    return res.status(500).json({
      ok: false,
      msg: "카페 추가 중 에러가 발생했습니다.",
      error
    });
  }
};

export const getAllCafeInformation = async (req, res) => {
  try {
    const getAllCafeInfoResult = await getAllCafeInfo();

    return res.status(200).json({
      ok: true,
      msg: "카페 정보 조회 성공",
      data: getAllCafeInfoResult
    });
  } catch (error) {
    console.log(error);
    return res.status(404).json({
      ok: false,
      msg: "카페 정보 조회 중 에러가 발생했습니다.",
      error
    });
  }
};

export const getAllCafeInformationWithPaging = async (req, res) => {
  try {
    const getAllCafeInfoResult = await getAllCafeInfo();
    console.log(getAllCafeInfoResult);
    const { page } = req.params;
    const getAllCafeInfoResultWithPaging = await pagination(getAllCafeInfoResult, page, 10 ,10);

    return res.status(200).json({
      ok: true,
      msg: "카페 정보 조회 성공",
      data: getAllCafeInfoResultWithPaging
    });
  } catch (error) {
    console.log(error);
    return res.status(404).json({
      ok: false,
      msg: "카페 정보 조회 중 에러가 발생했습니다.",
      error
    });
  }
};