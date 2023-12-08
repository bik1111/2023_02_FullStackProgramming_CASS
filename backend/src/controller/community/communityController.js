import { createMyCommunity, getMyCommunity, getMyCommunityBoardInfo, createPostInCommunity, modifyPost, deleteCommunityPost } from '../../service/community/communityService.js';

export const createCommunity = async (req, res) => {
try {
    console.log(req.file)
    const { title, hashtags } = req.body;
    const img_url = req.file.location;


    const createCommunityResult = await createMyCommunity(title, hashtags, img_url);

    return res.status(200).json({
        ok: true,
        msg: "커뮤니티 생성 성공",
        data: createCommunityResult
    })
}   catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "커뮤니티 생성 중 에러가 발생했습니다.",
        error
    })
}
}


export const getCommunity = async (req, res) => {
try {
    const myCommunityInfo = await getMyCommunity();

    return res.status(200).json({
        ok: true,
        msg: "커뮤니티 조회 성공",
        data: myCommunityInfo
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "커뮤니티 조회 중 에러가 발생했습니다.",
        error
    })
}
}

export const getCommunityInfo = async (req, res) => {
try {
    const { id } = req.params;

    const myCommunityInfo = await getMyCommunityBoardInfo(id);

    return res.status(200).json({
        ok: true,
        msg: "커뮤니티 조회 성공",
        data: myCommunityInfo
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "커뮤니티 조회 중 에러가 발생했습니다.",
        error
    })
}
}




export const createPost = async (req, res) => {
try {
    const { title, content } = req.body;
    const { communityId } = req.params;

    const createPostResult = await createPostInCommunity(title, content, communityId);

    return res.status(200).json({
        ok: true,
        msg: "게시글 생성 성공",
        data: createPostResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "게시글 생성 중 에러가 발생했습니다.",
        error
    })
}
}

export const modfiyPost = async (req, res) => {
try {
    const { title, content } = req.body;
    const { id } = req.params;

    const modifyPostResult = await modifyPost(title, content, id);

    return res.status(200).json({
        ok: true,
        msg: "게시글 수정 성공",
        data: modifyPostResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "게시글 수정 중 에러가 발생했습니다.",
        error
    })
}
}


export const deletePost = async (req, res) => {
try {
    const { id } = req.params;

    const deletePostResult = await deleteCommunityPost(id);

    return res.status(200).json({
        ok: true,
        msg: "게시글 삭제 성공",
        data: deletePostResult
    })
} catch (error) {
    console.log(error);
    return res.status(500).json({
        ok: false,
        msg: "게시글 삭제 중 에러가 발생했습니다.",
        error
    })
}
}