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
        },
        category: {
          type: String,
        },
        description: {
          type: String,
        },
        point: {
          type: Number,
        },
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
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);
module.exports = User;
