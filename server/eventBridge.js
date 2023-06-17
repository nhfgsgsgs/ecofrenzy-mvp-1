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

const getRandomMission = async () => {
  const missions = await Mission.find();
  const shuffledMissions = shuffle(missions);
  const randomMissions = shuffledMissions.slice(0, 3).map((mission) => {
    return {
      _id: mission._id,
      name: mission.name,
      category: mission.category,
      description: mission.description,
      point: mission.point,
      level: mission.level,
      creativity: mission.creativity,
      verification: mission.verification,
      impact: mission.impact,
    };
  });
  return randomMissions;
};

const createTodayMission = async (event) => {
  try {
    const storages = await Storage.find();
    const users = await User.find();

    // storages.map(async (storage) => {
    //   const user = await User.findById(storage.user);
    //   await Storage.findOneAndUpdate(
    //     { _id: storage._id },
    //     {
    //       $push: {
    //         historyMission: {
    //           $each: user?.todayMission,
    //         },
    //       },
    //     }
    //   );
    // });

    for (let i = 0; i < storages.length; i++) {
      const storage = storages[i];
      const storage1 = await Storage.findOneAndUpdate(
        { _id: storage._id },
        {
          $push: {
            historyMission: {
              $each: users[i]?.todayMission,
            },
          },
        },
        { new: true }
      );
      console.log(storage1);
    }

    // users.map(async (user) => {
    //   const randomMissions = await getRandomMission();
    //   await User.findOneAndUpdate(
    //     { _id: user._id },
    //     {
    //       $set: {
    //         todayMission: randomMissions,
    //       },
    //     }
    //   );
    // });

    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      const randomMissions = await getRandomMission();
      const user1 = await User.findOneAndUpdate(
        { _id: user._id },
        {
          $set: {
            todayMission: randomMissions,
          },
        },
        { new: true }
      );
      console.log(user1);
    }

    console.log("done");
  } catch (error) {
    console.log("An error occurred:", error);
  }
};

exports.handler = createTodayMission;
// createTodayMission();
