const Mission = require("./Models/Mission");
const Storage = require("./Models/Storage");
const User = require("./Models/User");
const mongoose = require("mongoose");
const AWS = require('aws-sdk');

AWS.config.update({ region: "ap-southeast-1" });

const lambda = new AWS.Lambda({ region: "ap-southeast-1" });

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

const generateChallenges = async (user, storage) => {
  // Get 3 last of historyMission
  const last3HistoryMission = storage.historyMission.slice(-3);
  // For each historyMission, replace missionPicked with the index of mission with the same id in givenMissions
  const last3HistoryMissionWithIndex = last3HistoryMission.map((history) => {
    const index = history.givenMissions.findIndex(
      (mission) => mission._id == history.missionPicked
    );
    return {
      ...history,
      missionPicked: index + 1,
    };
  });

  const params = {
    FunctionName: process.env.CHALLENGE_GENERATION_FUNCTION_ARN,
    InvocationType: "RequestResponse",
    Payload: JSON.stringify({
      user_data: user,
      records: storage,
    }),
  }

  const result = await lambda.invoke(params).promise();
  return JSON.parse(result.Payload);
};

const getNewChallenges = async (user, storage) => {
  if (user.usageDay <= 4) {
    return getRandomMission();
  }
  return generateChallenges(user, storage);
};

const createTodayMission = async (event) => {
  try {
    const storages = await Storage.find();
    const users = await User.find();

    for (let i = 0; i < users.length; i++) {
      const user = users[i];

      const storage = storages.filter((storage) => {
        return storage.user == user._id;
      })[0];

      const newMissions = await getNewChallenges(user, storage);

      const user1 = await User.findOneAndUpdate(
        { _id: user._id },
        {
          $set: {
            nextMission: newMissions,
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

module.exports = createTodayMission;

exports.handler = createTodayMission;
