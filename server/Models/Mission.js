const mongoose = require("mongoose");

const missionSchema = new mongoose.Schema(
  {
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
  { timestamps: true }
);

const Mission = mongoose.model("Mission", missionSchema);
module.exports = Mission;
