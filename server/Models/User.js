const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    age: {
      type: Number,
    },
    gender: {
      type: String,
      enum: ["Male", "Female", "Other"],
    },
    location: {
      type: String,
      enum: ["Urban", "Suburban", "Rural"],
    },
    usageDay: {
      type: Number,
      default: 0,
    },
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
        caption: {
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
          enum: ["Start", "Picked", "Pending", "Done"],
          default: "Start",
        },
        url: {
          type: String,
          default: "",
        },
        isDone: {
          type: Boolean,
          default: false,
        },
      },
    ],
    nextMission: [
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
          enum: ["Start", "Picked", "Pending", "Done"],
          default: "Start",
        },
        url: {
          type: String,
          default: "",
        },
        isDone: {
          type: Boolean,
          default: false,
        },
      },
    ],
    preferences: [
      {
        type: String,
      },
    ],
    growth_plan: [
      {
        type: String,
      },
    ],
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);
module.exports = User;
