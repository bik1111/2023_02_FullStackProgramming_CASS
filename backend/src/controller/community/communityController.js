import { createMyCommunity, getMyCommunity, getMyCommunityBoardInfo, createPostInCommunity } from '../../service/community/communityService.js';

export const createCommunity = async (req, res) => {
    const { title, hashtags } = req.body;

    const createCommunityResult = await createMyCommunity(title, hashtags);

    return res.status(200).json({
        ok: true,
        msg: "커뮤니티 생성 성공",
        data: createCommunityResult
    })
}


export const getCommunity = async (req, res) => {

    const myCommunityInfo = await getMyCommunity();

    return res.status(200).json({
        ok: true,
        msg: "커뮤니티 조회 성공",
        data: myCommunityInfo
    })

}

export const getCommunityInfo = async (req, res) => {
    const { id } = req.params;

    const myCommunityInfo = await getMyCommunityBoardInfo(id);

    return res.status(200).json({
        ok: true,
        msg: "커뮤니티 조회 성공",
        data: myCommunityInfo
    })
}



export const createPost = async (req, res) => {
    const { title, content } = req.body;
    const { communityId } = req.params;

    const createPostResult = await createPostInCommunity(title, content, communityId);

    return res.status(200).json({
        ok: true,
        msg: "게시글 생성 성공",
        data: createPostResult
    })
}