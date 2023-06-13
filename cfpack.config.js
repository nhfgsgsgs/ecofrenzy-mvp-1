module.exports = {
  entry: "cloudformation", // folder with templates
  output: "cloudformation.json", // resulting template file
  verbose: true, // whether or not to display additional details
  silent: false, // whether or not to prevent output from being displayed in stdout
  stack: {
    name: "ecofrenzy-backend-app", // stack name
    region: "ap-southeast-1", // stack region
    params: {
      /**
       * Extra parameters that can be used by API
       * @see: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/CloudFormation.html#createStack-property
       */

      /* uncomment if your CloudFormation template creates IAM roles */
      Capabilities: ["CAPABILITY_AUTO_EXPAND", "CAPABILITY_NAMED_IAM"],

      /* uncomment if your CloudFormation require parameters */
      // Parameters: [
      // 	{
      // 		ParameterKey: 'my-parameter',
      // 		ParameterValue: 'my-value',
      // 	},
      // ],
    },
    artifacts: [
      {
        bucket: "ecofrenzy-sourcecode",
        files: {
          "server.zip": {
            baseDir: "server/",
            path: "**/*",
            compression: "zip",
          },
        },
      },
    ],
  },
};
