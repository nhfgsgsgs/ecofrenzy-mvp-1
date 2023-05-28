const express = require("express");
const lambda = express();
const bodyParser = require("body-parser");
const cors = require("cors");
const mongoose = require("mongoose");
const lambdaRouter = require("../routes/lambda/index");

lambda.use(cors());
lambda.use(bodyParser.json());
lambda.use(bodyParser.urlencoded({ extended: true }));
lambda.use(express.json());

lambda.use("/api", lambdaRouter);

lambdaRouter.get("/", (req, res) => {
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

module.exports = lambda;
