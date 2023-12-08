import { getCommentInPost, createCommentInPost, modifyCommentInPost, deleteCommentInPost } from "../../service/comment/commentService.js";

export const getComment = async (req, res) => {
    try {
        const { communityId, contentId } = req.params;

        const getCommentResult = await getCommentInPost(communityId, contentId);

        return res.status(200).json({
            ok: true,
            msg: "댓글 조회 성공",
            data: getCommentResult
        })
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            ok: false,
            msg: "댓글 조회 중 에러가 발생했습니다.",
            error
        })
    }
}


export const createComment = async (req, res) => {

try {
    const { communityId, contentId } = req.params;
    const { content } = req.body;

    const createCommentResult = await createCommentInPost(communityId, contentId, content);

    return res.status(200).json({
        ok: true,
        msg: "댓글 생성 성공",
        data: createCommentResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "댓글 생성 중 에러가 발생했습니다.",
        error
    })
}
}


export const modifyComment = async (req, res) => {
try {
    const { communityId, contentId, commentId } = req.params;
    const { content } = req.body;

    const modifyCommentResult = await modifyCommentInPost(communityId, contentId, commentId, content);

    return res.status(200).json({
        ok: true,
        msg: "댓글 수정 성공",
        data: modifyCommentResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "댓글 수정 중 에러가 발생했습니다.",
        error
    })
}
}

export const deleteComment = async (req, res) => {

try {
    const { communityId, contentId, commentId } = req.params;

    const deleteCommentResult = await deleteCommentInPost(communityId, contentId, commentId);

    return res.status(200).json({
        ok: true,
        msg: "댓글 삭제 성공",
        data: deleteCommentResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "댓글 삭제 중 에러가 발생했습니다.",
        error
    })
}
}