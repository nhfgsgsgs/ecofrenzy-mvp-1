const express = require("express");
const UserController = require("../../Controller/UserController");
const ImageController = require("../../Controller/ImageController");
const { upload } = require("../../s3Service");
const userRouter = express.Router();

userRouter.put("/updateToday", UserController.updateTodayMission);

userRouter.get("/:id/getToday", UserController.getTodayMission);
userRouter.post("/", UserController.createUser);
userRouter.post("/:id/upload", upload.single("file"), ImageController.upload);

// fdf

module.exports = userRouter;
