const serverlessExpress = require("@vendia/serverless-express");

const lambda = require("./utils/lambda");

exports.handler = serverlessExpress({ app: lambda });

