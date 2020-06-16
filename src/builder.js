const { resolve } = require("path");
const fs = require("fs");
const https = require("https");
const url = "https://elements-prd.classpert.com/8.2.1/svgs/sprites/tags.svg";

https.get(url, res => {
  res.setEncoding("utf8");
  let body = "";
  res.on("data", data => {
    body += data;
  });
  res.on("end", () => {
    fs.writeFile(resolve(process.cwd(), "./dist/sprite.svg"), body, err => {
      if (err) {
        console.log("Could not save file: " + err.message);
      } else {
        console.log("Successfully saved file");
      }
    });
  });
});
