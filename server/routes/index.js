const express = require("express");
const appRouter = express.Router();

const missionRouter = require("./mission");
const userRouter = require("./user");

appRouter.use("/mission", missionRouter);
appRouter.use("/user", userRouter);

module.exports = appRouter;
