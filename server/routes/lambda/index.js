const express = require("express");
const lambdaRouter = express.Router();

const missionRouter = require("./mission");
const userRouter = require("./user");

lambdaRouter.use("/mission", missionRouter);
lambdaRouter.use("/user", userRouter);

module.exports = lambdaRouter;
