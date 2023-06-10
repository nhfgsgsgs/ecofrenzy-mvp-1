const Mission = require("../Models/Mission");

const MissionController = {
  createMission: async (req, res) => {
    try {
      const missions = await Mission.insertMany(req.body);
      return res.status(201).json({
        success: true,
        message: "Mission created successfully",
        missions: missions,
        body: req.body,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  },

  getMissions: async (req, res) => {
    try {
      const missions = await Mission.find();
      return res.status(200).json({
        success: true,
        message: "Missions retrieved successfully",
        missions: missions,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  },
};

module.exports = MissionController;
