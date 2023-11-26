import { createMyCommunity } from '../../service/community/communityService.js';

export const createCommunity = async (req, res) => {
    const { title, hashtags } = req.body;

    const createCommunityResult = await createMyCommunity(title, hashtags);

    return res.status(200).json({
        ok: true,
        msg: "커뮤니티 생성 성공",
        data: createCommunityResult
    })
}