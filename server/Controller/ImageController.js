const { s3Uploadv3 } = require("../s3Service");
const multer = require("multer");
const User = require("../Models/User");
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-southeast-1" });

module.exports.upload = async (req, res, next) => {
  try {
    const file = req.file;
    const user_id = req.params.id;
    const result = await s3Uploadv3(file, user_id);
    const user = await User.findById(user_id);
    const updateUser = await User.updateOne(
      { _id: user_id, "todayMission.status": { $in: ["Picked", "Pending"] } },
      {
        $set: {
          "todayMission.$.url": result?.Location,
          "todayMission.$.status": "Pending",
        },
      },
      { new: true }
    );
    console.log(result);
    const mission = user?.todayMission?.filter((mission) => {
      return mission.status == "Picked";
    })[0];
    console.log(mission);
    // call SNS aws
    var params = {
      Message: JSON.stringify({
        userId: user._id,
        url: result?.Location,
        mission: mission,
      }),
      TopicArn:
        process.env.IMAGE_CHALLENGE_NOTIFICATION_TOPIC,
    };
    var publishTextPromise = new AWS.SNS({ apiVersion: "2010-03-31" })
      .publish(params)
      .promise();
    publishTextPromise
      .then(function (data) {
        console.log(
          `Message ${params.Message} sent to the topic ${params.TopicArn}`
        );
        console.log("MessageID is " + data.MessageId);
      })
      .catch(function (err) {
        console.error(err, err.stack);
      });
    return res.status(200).json({
      success: true,
      message: "Image uploaded successfully",
      image: result,
      mission: mission,
      params: params,
    });
  } catch (err) {
    console.log(err.message);
  }
};
