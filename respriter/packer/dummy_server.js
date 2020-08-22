// a dummy server without external
// dependencies to allow for
// initial blue / green deployments
var http = require("http");

http
  .createServer(function (req, res) {
    res.writeHead(200, {
      "Content-Type": "text/html",
      "Cache-Control": "no-store, max-age=0, no-cache"
    }); // http header
    res.write(""); //write a response
    res.end(); //end the response
  })
  .listen(8080, "0.0.0.0", function () {
    console.log("server start at port 8080"); //the server object listens on port 3000
  });
