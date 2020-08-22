const fs = require("fs");

function noCache(res) {
  res.set("Cache-Control", "no-store, max-age=0, no-cache");
}

function svg(symbols, defs) {
  return `<svg xmlns="http://www.w3.org/2000/svg">${
    defs && defs.length ? ["<defs>", ...defs, "</defs>"].join("") : ""
  }${symbols && symbols.join("")}</svg>`;
}

function log(...payload) {
  console.log(...payload);
  return [...payload][0];
}

const dataReadAsync = path => {
  return new Promise((resolve, _reject) => {
    fs.readFile(path, "utf8", (err, data) => {
      if (err) {
        log("ERROR", err);
        resolve("");
      } else {
        resolve(data);
      }
    });
  });
};

module.exports = {
  noCache,
  svg,
  log,
  dataReadAsync
};
