"use strict";

// lambda@edge Origin Request trigger to remove the first path element
// compatible with either Node.js 6.10 or 8.10 Lambda runtime environment

const AWS = require("aws-sdk");
const s3 = new AWS.S3();
const crypto = require("crypto");

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request; // extract the request object
  const response = event.Records[0].cf.response; // extract the response object

  // if came from service ... send object to s3
  if (
    request.origin.custom &&
    response.statusDescription === "OK" &&
    request.origin.custom.customHeaders["x-cache-bucket-name"] &&
    request.origin.custom.customHeaders["x-cache-bucket-name"][0].value
  ) {
    const orderedQs = request.querystring
      .split("&")
      .filter(s => s.match(/=/))
      .map(s => s.split("="))
      .sort()
      .map(p => p[0] + "=" + p[1].split(",").sort().join(","))
      .join("&");
    const key = crypto
      .createHash("md5")
      .update(`${request.uri}/${orderedQs}`)
      .digest("hex");

    s3.putObject({
      Bucket:
        request.origin.custom.customHeaders["x-cache-bucket-name"][0].value,
      Key: key,
      Body: response.body,
      ContentType: "image/svg"
    });
  }

  return callback(null, response); // return control to CloudFront
};
