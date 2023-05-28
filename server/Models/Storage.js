const mongoose = require("mongoose");

const storageSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
  },
  historyMission: [
    {
      name: {
        type: String,
      },
      category: {
        type: String,
      },
      point: {
        type: Number,
      },
      isDone: {
        type: Boolean,
        default: false,
      },
    },
  ],
});

const Storage = mongoose.model("Storage", storageSchema);
module.exports = Storage;
