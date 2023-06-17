const mongoose = require("mongoose");

const storageSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
  },
  historyMission: [
    {
      usageDay: {
        type: Number,
      },
      missionPicked: {
        type: mongoose.Schema.Types.ObjectId,
      },
      isCompleted: {
        type: Boolean,
        default: false,
      },
      givenMissions: [
        {
          _id: {
            type: mongoose.Schema.Types.ObjectId,
          },
          name: {
            type: String,
            required: true,
          },
          point: {
            type: Number,
            default: 50,
          },
          category: {
            type: String,
          },
          impact: {
            type: String,
          },
          description: {
            type: String,
            default: "",
          },
          level: {
            type: String,
            enum: ["Easy", "Intermediate", "Hard"],
          },
          creativity: {
            type: String,
            enum: ["Direct", "Indirect"],
          },
          verification: [
            {
              question: {
                type: String,
              },
              desiredAnswer: {
                type: String,
              },
            },
          ],
        },
      ],
    },
  ],
});

const Storage = mongoose.model("Storage", storageSchema);
module.exports = Storage;
