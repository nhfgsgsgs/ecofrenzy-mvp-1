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

const updateTodayMission = async (event) => {
  try {
    const storages = await Storage.find();
    const users = await User.find();

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

    // Replace todayMission with nextMission
    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      const user1 = await User.findOneAndUpdate(
        { _id: user._id },
        {
          $set: {
            usageDay: user.usageDay + 1,
            todayMission: user.nextMission,
          },
        },
        { new: true }
      );
    }

    console.log("done");
  } catch (error) {
    console.log("An error occurred:", error);
  }
};

module.exports = updateTodayMission;

exports.handler = updateTodayMission;
