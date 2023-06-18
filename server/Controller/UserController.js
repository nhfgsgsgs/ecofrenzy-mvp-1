const User = require("../Models/User");
const Mission = require("../Models/Mission");
const Storage = require("../Models/Storage");
const AWS = require("aws-sdk");
const dotenv = require("dotenv");
dotenv.config();

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
            case "Picked":
              mission.status = "Pending";
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
            case "Picked":
              mission.status = "Pending";
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
      function shuffle(array) {
        for (let i = array.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [array[i], array[j]] = [array[j], array[i]];
        }
        return array;
      }

      const categories = [
        "Energy and Resources",
        "Transportation",
        "Consumption",
        "Waste management",
      ];

      const randomCategories = shuffle(categories).slice(0, 3);

      const randomMissions = [];

      for (let i = 0; i < randomCategories.length; i++) {
        const mission = await Mission.aggregate([
          { $match: { category: randomCategories[i] } },
          { $sample: { size: 1 } },
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
        ]);

        randomMissions.push(mission[0]);
      }
      const user = await User.create({
        todayMission: randomMissions,
      });
      const storage = await Storage.create({
        user: user._id,
        historyMission: [],
      });

      const sns = new AWS.SNS({ apiVersion: "2010-03-31" });

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
