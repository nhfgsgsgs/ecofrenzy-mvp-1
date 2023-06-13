const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    todayMission: [
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
        status: {
          type: String,
          enum: ["Start", "Picked", "Done"],
          default: "Start",
        },
        isDone: {
          type: Boolean,
          default: false,
        },
      },
    ],
    preferences: {
      // category: {
      // }
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);
module.exports = User;
