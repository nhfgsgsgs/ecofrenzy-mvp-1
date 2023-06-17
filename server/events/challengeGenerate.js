const Mission = require('../Models/Mission');
const Storage = require('../Models/Storage');
const User = require('../Models/User');
const mongoose = require('mongoose');

mongoose
  .connect('mongodb+srv://tungjav:tungjav@cluster0.styzwwu.mongodb.net')
  .then(() => {
    console.log('connected to mongo');
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

const generateChallenge = async (user) => {
  return getRandomMission();
};

const createTodayMission = async (event) => {
  try {
    const storages = await Storage.find();
    const users = await User.find();

    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      const newMissions = await generateChallenge(user);

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
    console.log('done');
  } catch (error) {
    console.log('An error occurred:', error);
  }
};

exports.handler = createTodayMission;
