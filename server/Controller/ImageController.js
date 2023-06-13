const { s3Uploadv3 } = require("../s3Service");
const multer = require("multer");
const User = require("../Models/User");

module.exports.upload = async (req, res, next) => {
  try {
    const file = req.file;
    const id = req.params.id;
    const result = await s3Uploadv3(file);
    const user = await User.findById(id);
    const mission = user.todayMission.filter((mission) => {
      return mission.status === "Picked";
    })[0];
    return res.status(200).json({
      success: true,
      message: "Image uploaded successfully",
      image: result,
      mission,
    });
  } catch (err) {
    console.log(err.message);
  }
};
