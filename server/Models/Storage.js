const mongoose = require("mongoose");

const storageSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
  },
  historyMission: [],
});

const Storage = mongoose.model("Storage", storageSchema);
module.exports = Storage;
