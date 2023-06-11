const express = require("express");
const UserController = require("../../Controller/UserController");
const ImageController = require("../../Controller/ImageController");
const userRouter = express.Router();

userRouter.put("/updateToday", UserController.updateTodayMission);

userRouter.get("/:id/   ", UserController.getTodayMission);
userRouter.post("/", UserController.createUser);
userRouter.post("/upload", ImageController.upload);

// fdf

module.exports = userRouter;
