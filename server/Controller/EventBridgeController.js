const User = require("../Models/User");
const Mission = require("../Models/Mission");
const Storage = require("../Models/Storage");

const EventBridgeController = {
  createTodayMission: async (req, res) => {
    try {
      const storages = await Storage.find();
      const users = await User.find();
      const missions = await Mission.find();

      const randomMissions = [0, 1, 2].map((value) => {
        const randomNumber = Math.floor(Math.random() * missions.length);
        return {
          _id: missions[randomNumber]._id,
          name: missions[randomNumber].name,
          category: missions[randomNumber].category,
          description: missions[randomNumber].description,
          point: missions[randomNumber].point,
          isDone: false,
        };
      });
      const bulkOpsMission = users.map((user) => ({
        updateOne: {
          filter: { _id: user._id },
          update: {
            $set: {
              todayMission: randomMissions,
            },
          },
        },
      }));
      const bulkOpsStorage = await Promise.all(
        storages.map(async (storage) => {
          const user = await User.findById(storage.user, {
            "todayMission.name": 1,
            "todayMission.category": 1,
            "todayMission.description": 1,
            "todayMission.point": 1,
          });
          console.log(user);

          return {
            updateOne: {
              filter: { _id: storage._id },
              update: {
                $push: {
                  historyMission: {
                    $each: user.todayMission,
                  },
                },
              },
            },
          };
        })
      );

      await Storage.bulkWrite(bulkOpsStorage);

      await User.bulkWrite(bulkOpsMission);

      return res.status(200).json({
        message: "Mission updated successfully",
      });
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }
  },
};

module.exports = EventBridgeController;
