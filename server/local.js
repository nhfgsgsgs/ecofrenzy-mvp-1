const express = require("express");
const app = express();
const port = 3000;
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");
const dotenv = require("dotenv");
const appRouter = require("./routes/index");
const moment = require("moment-timezone");
dotenv.config();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
const localTimezone = moment.tz.guess();

app.use("/", appRouter);

app.listen(port);

mongoose
  .connect(process.env.MONGO_URL)
  .then(() => {
    console.log("connected to mongo");
    console.log(localTimezone);
  })
  .catch((err) => {
    console.log(err);
  });

console.log(`listening on http://localhost:${port}`);
