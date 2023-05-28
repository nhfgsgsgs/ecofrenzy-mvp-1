const express = require("express");
const UserController = require("../../Controller/UserController");
const userRouter = express.Router();

userRouter.put("/updateToday", UserController.updateTodayMission);

userRouter.get("/getToday", UserController.getTodayMission);
userRouter.post("/", UserController.createUser);

module.exports = userRouter;
