const User = require("../Models/User");
const Mission = require("../Models/Mission");
const Storage = require("../Models/Storage");

const UserController = {
  updateTodayMission: async (req, res) => {
    try {
      const { userId, missionId } = req.body;
      const user = await User.findOne({ _id: userId });
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
            // case "Picked":
            //   mission.status = "Done";
            //   mission.isDone = true;
            //   break;
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
            // case "Picked":
            //   mission.status = "Done";
            //   mission.isDone = true;
            //   break;
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
              category: 1,
              description: 1,
              point: 1,
            },
          },
          {
            $addFields: {
              isDone: false,
            },
          },
        ]),
      });
      const storage = await Storage.create({
        user: user._id,
        historyMission: [],
      });
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
