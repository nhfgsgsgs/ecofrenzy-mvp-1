const serverlessExpress = require("@vendia/serverless-express");
const eventBridge = require("./utils/eventBridge");

exports.handler = serverlessExpress({ eventBridge });
