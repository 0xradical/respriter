"use strict";
const crypto = require("crypto");

// lambda@edge Origin Request trigger to remove the first path element
// compatible with either Node.js 6.10 or 8.10 Lambda runtime environment

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request; // extract the request object

  // s3 -> get object based on query string and path
  // on fail will request to service (failover)
  if (request.origin.s3 && request.origin.s3.domainName) {
    const orderedQs = request.uri.querystring
      .split("&")
      .map(s => s.split("="))
      .sort()
      .map(p => p[0] + "=" + p[1].split(",").sort().join(","))
      .join("&");
    const key = crypto
      .createHash("md5")
      .update(`${request.uri.path}/${orderedQs}`)
      .digest("hex");

    request.uri = `/${key}`;
    request.headers["host"] = [
      { key: "Host", value: request.origin.s3.domainName }
    ];
  }

  return callback(null, request); // return control to CloudFront
};
