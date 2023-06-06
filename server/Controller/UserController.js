const User = require("../Models/User");
const Mission = require("../Models/Mission");
const Storage = require("../Models/Storage");

const UserController = {
  updateTodayMission: async (req, res) => {
    try {
      const { userId, missionId } = req.body;
      const user = await User.findOneAndUpdate(
        { _id: userId, "todayMission._id": missionId },
        { $set: { "todayMission.$.isDone": true } },
        { new: true }
      );
      return res.status(200).json({
        message: "Mission updated successfully",
        user: user,
      });
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }
  },

  getTodayMission: async (req, res) => {
    try {
      const { id } = req.params;
      const user = await User.findById(id);
      return res.status(200).json({
        message: "Mission retrieved successfully",
        mission: user.todayMission,
      });
    } catch (error) {
      return res.status(400).json({ message: error.message });
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
        message: "User created successfully",
        user: user,
        storage: storage,
      });
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }
  },
};

module.exports = UserController;
