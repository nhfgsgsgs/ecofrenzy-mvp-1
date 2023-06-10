const Mission = require("./Models/Mission");
const Storage = require("./Models/Storage");
const User = require("./Models/User");
const mongoose = require("mongoose");

mongoose
  .connect("mongodb+srv://tungjav:tungjav@cluster0.styzwwu.mongodb.net")
  .then(() => {
    console.log("connected to mongo");
  })
  .catch((err) => {
    console.log(err);
  });

function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

const createTodayMission = async (event) => {
  try {
    const storages = await Storage.find();
    const users = await User.find();
    const missions = await Mission.find();
    const shuffledMissions = shuffle(missions);

    const randomMissions = shuffledMissions.slice(0, 3).map((mission) => {
      return {
        _id: mission._id,
        name: mission.name,
        category: mission.category,
        description: mission.description,
        point: mission.point,
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
    console.log("done");
  } catch (error) {
    console.log("An error occurred:", error);
  }
};

exports.handler = createTodayMission;
