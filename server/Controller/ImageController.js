const { s3Uploadv3 } = require("../s3Service");

module.exports.upload = async (req, res, next) => {
  try {
    const file = req.file;
    const result = await s3Uploadv3(file);
    res.status(200).json({
      success: true,
      message: "Image uploaded successfully",
      image: result,
    });
  } catch (err) {
    console.log(err.message);
  }
};
