const express = require("express");
const eventBridge = express();
const bodyParser = require("body-parser");
const cors = require("cors");
const mongoose = require("mongoose");
const eventBridgeRouter = require("../routes/eventBridge");

eventBridge.use(cors());
eventBridge.use(bodyParser.json());
eventBridge.use(bodyParser.urlencoded({ extended: true }));
eventBridge.use(express.json());

eventBridge.use("/eventBridge", eventBridgeRouter);

eventBridgeRouter.get("/", (req, res) => {
  res.json({ message: "Hello World" });
});

mongoose
  .connect("mongodb+srv://tungjav:tungjav@cluster0.styzwwu.mongodb.net")
  .then(() => {
    console.log("connected to mongo");
  })
  .catch((err) => {
    console.log(err);
  });

module.exports = eventBridge;
