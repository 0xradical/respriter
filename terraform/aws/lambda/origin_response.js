"use strict";

// lambda@edge Origin Request trigger to remove the first path element
// compatible with either Node.js 6.10 or 8.10 Lambda runtime environment

exports.handler = (event, context, callback) => {
  const response = event.Records[0].cf.response; // extract the response object

  return callback(null, response); // return control to CloudFront
};
