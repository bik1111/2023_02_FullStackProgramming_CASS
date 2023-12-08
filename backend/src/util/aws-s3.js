import dotenv from 'dotenv';
dotenv.config();
import multer from 'multer';
import multerS3 from 'multer-s3';
import aws from 'aws-sdk';



const s3 = new aws.S3({
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    },
});

const s3ImageUploader = multerS3({
    s3: s3,
    bucket: "full-stack-programming-cass",
    acl: "public-read",
    contentType: multerS3.AUTO_CONTENT_TYPE,
    key: (req, file, cb) => {
      cb(null, `${Date.now()}_${file.originalname}`);
   },
});


const imgUpload = multer({
  dest: "uploads/community/",
  limits: {
    fileSize: 3000000,
  },
  storage: s3ImageUploader,
});



export default imgUpload;
