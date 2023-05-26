const User = require("../Models/User");
const Mission = require("../Models/Mission");

const UserController = {
  createTodayMission: async (req, res) => {
    try {
      const { id } = req.body;
      const missions = await Mission.aggregate([
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
      ]);
      const user = await User.findOneAndUpdate(
        { _id: id },
        { $set: { todayMission: missions } },
        { new: true }
      );
      return res.status(200).json({
        message: "Mission updated successfully",
        user: user,
        missions: missions,
      });
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }
  },

  updateTodayMission: async (req, res) => {
    try {
      const { id, missionId } = req.body;
      const user = await User.findOneAndUpdate(
        { _id: id, "todayMission._id": missionId },
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
      const { id } = req.body;
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
        todayMission: [],
      });
      return res.status(201).json({
        message: "User created successfully",
        user: user,
      });
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }
  },
};

module.exports = UserController;
