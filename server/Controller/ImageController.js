const { s3Uploadv3 } = require("../s3Service");
const multer = require("multer");
const User = require("../Models/User");

module.exports.upload = async (req, res, next) => {
  try {
    const file = req.file;
    const id = req.params.id;
    const result = await s3Uploadv3(file);
    const user = await User.findById(id);
    const updateUser = await User.updateOne(
      { _id: id, "todayMission.status": "Picked" },
      {
        $set: {
          "todayMission.$.url": result?.Location,
          "todayMission.$.status": "Pending",
        },
      },
      { new: true }
    );
    console.log(updateUser);
    console.log(result);
    const mission = user?.todayMission?.filter((mission) => {
      return mission.status == "Pending";
    })[0];

    return res.status(200).json({
      success: true,
      message: "Image uploaded successfully",
      image: result,
      mission: mission,
    });
  } catch (err) {
    console.log(err.message);
  }
};
