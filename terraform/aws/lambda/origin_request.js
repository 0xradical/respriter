"use strict";

// lambda@edge Origin Request trigger to remove the first path element
// compatible with either Node.js 6.10 or 8.10 Lambda runtime environment

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request; // extract the request object

  if (request.origin.s3 && request.origin.s3.domainName) {
    request.uri = request.uri + "/svgs/sprites/all.svg"; // modify the URI
    request.headers["host"] = [
      { key: "Host", value: request.origin.s3.domainName }
    ];
  }

  return callback(null, request); // return control to CloudFront
};
