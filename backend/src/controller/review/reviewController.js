import { createReviewInCafe, getReview, modifyReviewInCafe, deleteReviewInCafe } from '../../service/review/reviewService.js';

export const createReview = async (req, res) => {
try {
    const { cafe_id, rating, comment } = req.body;
    const reviewResult = await createReviewInCafe(cafe_id, rating, comment);

    return res.status(200).json({
        ok: true,
        msg: "리뷰 생성 성공",
        data: reviewResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "리뷰 생성 중 에러가 발생했습니다.",
        error
    })
}
}

export const getReviewEachCafe = async (req, res) => {
try {
    const { cafeId } = req.params;

    const reviewResult = await getReview(cafeId);

    return res.status(200).json({
        ok: true,
        msg: "리뷰 조회 성공",
        data: reviewResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "리뷰 조회 중 에러가 발생했습니다.",
        error
    })
}
}

export const modifyReview = async (req, res) => {
try {
    const { reviewId } = req.params;
    const { rating, comment } = req.body;

    const modifyReviewResult = await modifyReviewInCafe(reviewId, rating, comment);

    return res.status(200).json({
        ok: true,
        msg: "리뷰 수정 성공",
        data: modifyReviewResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "리뷰 수정 중 에러가 발생했습니다.",
        error
    })
}
}

export const deleteReview = async (req, res) => {
try {
    const { reviewId } = req.params;

    const deleteReviewResult = await deleteReviewInCafe(reviewId);

    return res.status(200).json({
        ok: true,
        msg: "리뷰 삭제 성공",
        data: deleteReviewResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "리뷰 삭제 중 에러가 발생했습니다.",
        error
    })
}
}
