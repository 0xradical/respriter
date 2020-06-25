"use strict";

// lambda@edge Origin Request trigger to remove the first path element
// compatible with either Node.js 6.10 or 8.10 Lambda runtime environment

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request; // extract the request object
  const response = event.Records[0].cf.response; // extract the response object

  if (request.origin.s3) {
    response.headers["cache-control"] = [
      { key: "Cache-Control", value: "no-store, max-age=0, no-cache" }
    ];
  }

  return callback(null, response); // return control to CloudFront
};
