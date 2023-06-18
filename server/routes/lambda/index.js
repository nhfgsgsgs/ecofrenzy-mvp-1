const express = require("express");
const lambdaRouter = express.Router();
const Mission = require("../../Models/Mission");
const Storage = require("../../Models/Storage");
const User = require("../../Models/User");
const mongoose = require("mongoose");
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-southeast-1" });

const lambda = new AWS.Lambda({ region: "ap-southeast-1" });

const missionRouter = require("./mission");
const userRouter = require("./user");

lambdaRouter.use("/mission", missionRouter);
lambdaRouter.use("/user", userRouter);

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
  const categories = [
    "Energy and Resources",
    "Transportation",
    "Consumption",
    "Forestry",
    "Awareness and Innovation",
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
    mission1[Math.floor(Math.random() * (mission1.length + 1))],
    mission2[Math.floor(Math.random() * (mission1.length + 1))],
    mission3[Math.floor(Math.random() * (mission1.length + 1))],
  ];
  return randomMissions;
};

const generateChallenges = async (user, storage) => {
  // Get 3 last of historyMission
  const last3HistoryMission = storage.historyMission.slice(-3);
  const last3HistoryMissionWithIndex = last3HistoryMission?.map((history) => {
    const index = history?.givenMissions?.findIndex(
      (mission) => mission._id == history.missionPicked
    );
    return {
      ...history,
      missionPicked: index + 1,
    };
  });

  const params = {
    // FunctionName: process.env.CHALLENGE_GENERATION_FUNCTION_ARN,
    FunctionName:
      "arn:aws:lambda:ap-southeast-1:885537931206:function:ChallengeGenerationFunction",
    InvocationType: "RequestResponse",
    Payload: JSON.stringify({
      user_data: user,
      records: storage,
    }),
  };

  const result = await lambda.invoke(params).promise();
  return JSON.parse(result.Payload);
};

const getNewChallenges = async (user, storage) => {
  if (user.usageDay <= 4) {
    return getRandomMission();
  }
  return generateChallenges(user, storage);
};

lambdaRouter.get("/challenge", async (req, res) => {
  try {
    const storages = await Storage.find();
    const users = await User.find();

    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      const storage = storages[i];

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
      console.log({ user1 });
    }

    for (let i = 0; i < storages.length; i++) {
      const storage = storages[i];
      let mission = users[i].todayMission.filter(
        (mission) => mission.status !== "Start"
      );
      let mission_id = null;
      if (mission.length > 0) {
        mission_id = mission[0]._id;
        const storage1 = await Storage.findOneAndUpdate(
          { _id: storage._id },
          {
            $push: {
              historyMission: {
                $each: [
                  {
                    usageDay: users[i].usageDay,
                    missionPicked: mission_id,
                    isCompleted: false,
                    givenMissions: users[i].todayMission,
                  },
                ],
              },
            },
          },
          { new: true }
        );
        console.log({ storage1 });
      }
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
    return res.status(200).json({ message: "done" });
  } catch (error) {
    console.log("An error occurred:", error);
  }
});

module.exports = lambdaRouter;
