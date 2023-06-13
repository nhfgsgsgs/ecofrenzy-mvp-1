const { s3Uploadv3 } = require("../s3Service");
const multer = require("multer");
const User = require("../Models/User");
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-southeast-1" });

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
    // call SNS aws
    var params = {
      Message: `${result.Location}` /* required */,
      TopicArn:
        "arn:aws:sns:ap-southeast-1:885537931206:ImageChallengeNotificationTopic",
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
    });
  } catch (err) {
    console.log(err.message);
  }
};
