const express = require("express");
const appRouter = express.Router();

const lambdaRouter = require("./lambda");
const eventBridgeRouter = require("./eventBridge");

// appRouter.use("/api", lambdaRouter);
// appRouter.use("/eventBridge", eventBridgeRouter);
appRouter.use("/api", lambdaRouter);
appRouter.use("/eventBridge", eventBridgeRouter);

module.exports = appRouter;
