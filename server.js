const express = require("express");
const cors = require("./server/cors");
const { noCache } = require("./server/utils");
const { processor } = require("./server/processor");
const app = express();

app.get("/", function (_req, res) {
  noCache(res);
  res.status(404);
  res.end();
});

app.get("/healthcheck", function (_req, res) {
  noCache(res);
  res.status(200);
  res.end();
});

app.get("/test/:version", function (req, res) {
  const version = req.params.version;
  noCache(res);

  res.send(`
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Test</title>
      <script>
        window.onload = function() {
          fetch('/${version}' + window.location.search).then(function (response) {
            // The API call was successful!
            return response.text();
          }).then(function (html) {

            var sprite = document.getElementById("sprite");
            sprite.innerHTML = html;
          }).catch(function (err) {
            // There was an error
            console.warn('Something went wrong.', err);
          });
        }
      </script>
    </head>
    <body>
      <div style="width:0;height:0" id="sprite"></div>
      <svg>
        <use xlink:href="#tags-computer_science"></use>
      </svg>
      <svg>
        <use xlink:href="#providers-udemy"></use>
      </svg>
    </body>
  </html>
  `);
});

app.get("/:version", cors, function (req, res) {
  const version = req.params.version;
  const cache = req.headers["x-cache-bucket-name"];

  processor(
    version,
    cache
  )(req.query)
    .then(svgPayload => {
      res.contentType("image/svg");
      res.send(svgPayload);
    })
    .catch(error => {
      console.log(error);
      noCache(res);
      res.status(404);
      res.end();
    });
});

app.listen(process.env.NODE_PORT || 8080, "0.0.0.0", function () {});
