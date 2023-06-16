const User = require("../Models/User");
const Mission = require("../Models/Mission");
const Storage = require("../Models/Storage");
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-southeast-1" });

const UserController = {
  updateTodayMission: async (req, res) => {
    try {
      const { userId, missionId } = req.body;
      console.log(userId);
      const user = await User.findOne({ _id: userId });
      console.log(user);
      if (user) {
        const missions = user?.todayMission?.filter((mission) => {
          return mission.isDone == false && mission.status != "Start";
        });

        if (missions.length == 1 && missions[0]._id == missionId) {
          let mission = missions[0];
          switch (mission.status) {
            case "Start":
              mission.status = "Picked";
              break;
            case "Pending":
              mission.status = "Done";
              mission.isDone = true;
              break;
          }
          await user.save();
          return res.status(200).json({
            success: true,
            message: "Mission updated successfully",
            user: user,
          });
        } else if (missions.length == 0) {
          let mission = user.todayMission.filter((mission) => {
            return mission._id == missionId;
          })[0];
          switch (mission.status) {
            case "Start":
              mission.status = "Picked";
              break;
            case "Pending":
              mission.status = "Done";
              mission.isDone = true;
              break;
          }
          await user.save();
          return res.status(200).json({
            success: true,
            message: "Mission updated successfully",
            user: user,
          });
        } else {
          return res.status(200).json({
            success: false,
            message: "Mission updated failed",
          });
        }
      }
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  },

  getTodayMission: async (req, res) => {
    try {
      const { id } = req.params;
      const user = await User.findById(id);
      return res.status(200).json({
        success: true,
        message: "Mission retrieved successfully",
        mission: user.todayMission,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  },

  createUser: async (req, res) => {
    try {
      const user = await User.create({
        todayMission: await Mission.aggregate([
          { $sample: { size: 3 } },
          {
            $project: {
              _id: 1,
              name: 1,
              point: 1,
              category: 1,
              impact: 1,
              description: 1,
              level: 1,
              creativity: 1,
              verification: 1,
            },
          },
          {
            $addFields: {
              isDone: false,
              status: "Start",
              url: "",
            },
          },
        ]),
      });
      const storage = await Storage.create({
        user: user._id,
        historyMission: [],
      });

      const sns = new AWS.SNS({ apiVersion: "2010-03-31" });
      // const deviceToken =
      //   "ejOjK-HNSp29VFDQW3o_za:APA91bGu_xPHJ1-qzRtI3EiSngSZ0eTgRM95sG3CPsGQU30iHEROAlQui2EOuxzUwo-hj5Qoq8WPhr3_tD4N7abog-BkMaNK7Cvvd1rxik4pw4r99cjKHHtVlN7gZlypSFOPiYmL0Jvs";
      // const platformApplicationArn =
      //   "arn:aws:sns:ap-southeast-1:885537931206:app/GCM/EcoFrenzy-Android";

      // const topicArn =
      //   "arn:aws:sns:ap-southeast-1:885537931206:endpoint/GCM/EcoFrenzy-Android/3992b70e-5cd0-35db-b05f-0c57b5a75388";

      sns.createPlatformEndpoint(
        {
          PlatformApplicationArn: process.env.SNS_PLATFORM_APPLICATION,
          Token: req.body.deviceToken,
        },
        (err, data) => {
          if (err) {
            console.log("Error creating platform endpoint:", err);
          } else {
            console.log("Platform endpoint created:", data.EndpointArn);
          }
        }
      );

      return res.status(200).json({
        success: true,
        message: "User created successfully",
        user: user,
        storage: storage,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  },
};

module.exports = UserController;
