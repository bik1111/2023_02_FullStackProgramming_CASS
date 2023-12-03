import bcrypt from 'bcrypt';
import { createUser, getUser } from '../../service/user/userService.js';
import { sign } from '../../auth/auth-jwt.js';
import { redisClient } from '../../util/cache.js';


export const createNewUser = async (req, res) => {

try {
    const { username } = req.body;
    let password = req.body.password;
    const salt = await bcrypt.genSalt(10); // 랜덤한 솔트 값 생성
    const hashedPassword = await bcrypt.hash(password, salt);
    password = hashedPassword;

    const newUser = await createUser(username, password);
    console.log("회원가입 성공!", newUser)
    const token = sign(newUser);

    return res.status(200).json({
        ok: true,
        msg: "회원가입 성공",
        data: token
    })

} catch (err) {
    return res.status(400).json({
        ok: false,
        msg: "회원가입 실패",
        data: err.message
    })
  }
}


export const login = async (req, res) => {
    try {
      const { username, password } = req.body;

      const userNameInfo = await getUser(username);

      if (userNameInfo.length === 0) {
        return res.status(400).json({
          ok: false,
          msg: "아이디가 존재하지 않습니다.",
          data: null
        });
      } else {
        const user = userNameInfo[0];
        const chk = await bcrypt.compare(password, userNameInfo[0].password);

        if (chk) {
          const token = sign(user);
          console.log("로그인 성공!", token)
          return res.status(200).json({
            ok: true,
            msg: "로그인 성공",
            data: token
          });
        } else {
          return res.status(400).json({
            ok: false,
            msg: "비밀번호가 일치하지 않습니다.",
            data: null
          });
        }
      }
    } catch (err) {
      return res.status(400).json({
        ok: false,
        msg: "로그인 실패",
        data: err.message
      });
    }
  };
