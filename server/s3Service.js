// const { Upload } = require("@aws-sdk/lib-storage");
const { PutObjectCommand, S3, S3Client } = require("@aws-sdk/client-s3");
const uuid = require("uuid").v4;
const multer = require("multer");
const path = require("path");

exports.s3Uploadv3 = async (file) => {
  const s3client = new S3Client();

  const param = {
    Bucket: "ecofrenzy-upload-img",
    Key: `ecofrenzy/${uuid()}-${file?.originalname}`,
    Body: file?.buffer,
    ACL: "bucket-owner-full-control",
    ContentType: file?.mimetype,
  };

  const response = await s3client.send(new PutObjectCommand(param));

  return {
    Key: param.Key,
    Location: `https://${param.Bucket}.s3.amazonaws.com/${param.Key}`,
    // param,
    response,
  };
};

const storage = multer.memoryStorage();

const fileFilter = (req, file, cb) => {
  if (file.mimetype.split("/")[0] === "image") {
    cb(null, true);
  } else {
    cb(new multer.MulterError("LIMIT_UNEXPECTED_FILE"), false);
  }
};

// ["image", "jpeg"]

const upload = multer({
  storage,
  fileFilter,
  limits: { fileSize: 1000000000, files: 2 },
});

exports.upload = upload;
