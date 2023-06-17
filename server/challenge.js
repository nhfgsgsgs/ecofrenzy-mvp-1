const createTodayMission = require("./challengeGenerate");
const updateTodayMission = require("./challengeUpdate");

exports.handler = async (event) => {
  await createTodayMission();
  await updateTodayMission();
  return {
    event,
  };
};
