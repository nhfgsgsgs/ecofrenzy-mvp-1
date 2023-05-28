const express = require("express");
const eventBridgeRouter = express.Router();
const EventBridgeController = require("../../Controller/EventBridgeController");

eventBridgeRouter.post("/", EventBridgeController.createTodayMission);

module.exports = eventBridgeRouter;
