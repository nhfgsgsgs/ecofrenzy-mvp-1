const express = require("express");
const app = express();
const port = 3000;
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");
const dotenv = require("dotenv");
const appRouter = require("./routes/index");
const moment = require("moment-timezone");
const multer = require("multer");
dotenv.config();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
const localTimezone = moment.tz.guess();

app.use("/", appRouter);

app.listen(port);
app.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        message: "file is too large",
      });
    }

    if (error.code === "LIMIT_FILE_COUNT") {
      return res.status(400).json({
        message: "File limit reached",
      });
    }

    if (error.code === "LIMIT_UNEXPECTED_FILE") {
      return res.status(400).json({
        message: "File must be an image",
      });
    }
  }
});
mongoose
  .connect(process.env.MONGO_URL)
  .then(() => {
    console.log("connected to mongo");
    console.log(localTimezone);
  })
  .catch((err) => {
    console.log(err);
  });

const Mission = require("./Models/Mission");

app.get("/", async (req, res) => {
  const mission = await Mission.find();
  return res.status(200).json({
    success: true,
    data: "Hello World",
    mission,
  });
});

console.log(`listening on http://localhost:${port}`);
