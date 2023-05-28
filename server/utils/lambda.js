const express = require("express");
const lambda = express();
const bodyParser = require("body-parser");
const cors = require("cors");
const dotenv = require("dotenv");
const mongoose = require("mongoose");
const lambdaRouter = require("../routes/lambda");
dotenv.config();

lambda.use(cors());
lambda.use(bodyParser.json());
lambda.use(bodyParser.urlencoded({ extended: true }));
lambda.use(express.json());

lambda.use("/", lambdaRouter);

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
