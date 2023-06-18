const { s3Uploadv3 } = require("../s3Service");
const multer = require("multer");
const User = require("../Models/User");
const AWS = require("aws-sdk");
const dotenv = require("dotenv");
dotenv.config();

AWS.config.update({ region: "ap-southeast-1" });

module.exports.upload = async (req, res, next) => {
  try {
    const file = req.file;
    const user_id = req.params.id;
    const result = await s3Uploadv3(file, user_id);
    const user = await User.findById(user_id);
    // const updateUser = await User.updateOne(
    //   { _id: user_id, "todayMission.status": { $in: ["Picked", "Pending"] } },
    //   {
    //     $set: {
    //       "todayMission.$.url": result?.Location,
    //       "todayMission.$.status": "Pending",
    //     },
    //   },
    //   { new: true }
    // );
    // user.todayMission.forEach((mission) => {
    //   if (mission.status == "Picked" || mission.status == "Pending") {
    //     mission.url = result?.Location;
    //     mission.status = "Pending";
    //   }
    // });
    const user1 = await user.findByIdAndUpdate(
      user_id,
      {
        $set: {
          "todayMission.$.url": result?.Location,
          "todayMission.$.status": "Pending",
        },
      },
      { new: true }
    );
    console.log(result);
    console.log(user1);
    const mission = user?.todayMission?.filter((mission) => {
      return mission.status == "Picked" || mission.status == "Pending";
    })[0];
    console.log(mission);
    // call SNS aws
    const sns = new AWS.SNS({ apiVersion: "2010-03-31" });

    sns.createPlatformEndpoint(
      {
        PlatformApplicationArn: process.env.SNS_PLATFORM_APPLICATION,
        Token: req.body.deviceToken,
      },
      function (err, data) {
        if (err) {
          console.log(err.stack);
          return res.status(200).json({
            success: false,
            message: "Image uploaded failed",
            deviceToken: req.body.deviceToken || "no device token",
            PlatformApplicationArn: process.env.SNS_PLATFORM_APPLICATION,
            error: err.stack,
          });
        }

        const endpointArn = data.EndpointArn;
        const params = {
          Message: JSON.stringify({
            userId: user_id,
            url: result?.Location,
            mission: mission,
            endpointArn: endpointArn,
          }),
          TopicArn: process.env.IMAGE_CHALLENGE_NOTIFICATION_TOPIC,
        };
        console.log("endpointArn is " + endpointArn);
        const publishTextPromise = new AWS.SNS({ apiVersion: "2010-03-31" })
          .publish(params)
          .promise();

        publishTextPromise
          .then(function (data) {
            console.log(
              `Message ${params.Message} sent to the topic ${params.TopicArn}`
            );
            console.log("MessageID is " + data.MessageId);
            return res.status(200).json({
              success: true,
              message: "Image uploaded successfully",
              image: result,
              mission: mission,
              params: params,
              endpointArn,
            });
          })
          .catch(function (err) {
            console.error(err, err.stack);
            return res.status(200).json({
              success: false,
              message: "Image uploaded failed",
            });
          });
      }
    );
  } catch (err) {
    console.log(err.message);
  }
};
