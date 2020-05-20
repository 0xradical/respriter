const history = require("connect-history-api-fallback");
const express = require("express");
const serveStatic = require("serve-static");
const app = express();

app.get("/docs", function(_, res) {
  return res.redirect("/docs/getting-started.html");
});

app.use(history());
app.use(serveStatic(__dirname + "/docs/.vuepress/dist"));
app.use(serveStatic(__dirname + "/dist"));

var port = process.env.PORT || 5000;
app.listen(port);
// eslint-disable-next-line no-console
console.log("server started " + port);
