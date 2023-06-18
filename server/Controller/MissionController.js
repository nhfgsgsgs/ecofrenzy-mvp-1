const Mission = require("../Models/Mission");
const User = require("../Models/User");

function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

const getRandomMission = async () => {
  const missions = await Mission.find();
  const shuffledMissions = shuffle(missions);
  const categories = [
    "Energy and Resources",
    "Transportation",
    "Consumption",
    // "Forestry",
    // "Awareness and Innovation",
    "Waste management",
  ];
  const randomCategories = shuffle(categories).slice(0, 3);
  const mission1 = missions.filter((mission) => {
    return mission.category == randomCategories[0];
  });
  const mission2 = missions.filter((mission) => {
    return mission.category == randomCategories[1];
  });
  const mission3 = missions.filter((mission) => {
    return mission.category == randomCategories[2];
  });
  const randomMissions = [
    {
      ...mission1[Math.floor(Math.random() * (mission1.length + 1))],
      status: "Start",
      isDone: false,
      url: "",
    },
    {
      ...mission2[Math.floor(Math.random() * (mission1.length + 1))],
      status: "Start",
      isDone: false,
      url: "",
    },
    {
      ...mission3[Math.floor(Math.random() * (mission1.length + 1))],
      status: "Start",
      isDone: false,
      url: "",
    },
  ];
  return randomMissions;
};

const MissionController = {
  createMission: async (req, res) => {
    try {
      const users = await User.find();
      // 1. Lấy ra danh sách các category từ collection 'Mission'.
      const categories = [
        "Energy and Resources",
        "Transportation",
        "Consumption",
        "Waste management",
      ];
      async function getRandomMission() {
        const randomCategories = shuffle(categories).slice(0, 3);

        // 3. Với mỗi category được chọn, tìm một mission ngẫu nhiên thuộc category đó.
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
        return randomMissions;
      }
      // Cập nhật thông tin user.
      for (let i = 0; i < users.length; i++) {
        const user = users[i];
        await User.findByIdAndUpdate(
          { _id: user._id },
          {
            $set: {
              todayMission: randomMissions,
            },
          }
        );
      }

      return res.status(201).json({
        success: true,
        message: "Mission created successfully",

        // missions: { ...missions[0], status: "Start", isDone: false, url: "" },
        // body: req.body,
        // user: user,
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
