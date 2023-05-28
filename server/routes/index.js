const express = require("express");
const appRouter = express.Router();

const lambdaRouter = require("./lambda");

appRouter.use("/api", lambdaRouter);

module.exports = appRouter;
