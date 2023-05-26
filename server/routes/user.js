const express = require("express");
const userRouter = express.Router();
const UserController = require("../Controller/UserController");

userRouter.put("/updateToday", UserController.updateTodayMission);
userRouter.put("/createToday", UserController.createTodayMission);
userRouter.get("/getToday", UserController.getTodayMission);

userRouter.post("/", UserController.createUser);

module.exports = userRouter;
