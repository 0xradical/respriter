const fs = require("fs");
const path = require("path");
const express = require("express");
const cors = require("cors");
const { compose, toPairs, map, reduce, join, split } = require("ramda");
const rootDir = path.resolve();
const distDir = path.resolve(rootDir, "dist");
const defsDir = scope => path.resolve(distDir, scope, "defs");
const symbolsDir = scope => path.resolve(distDir, scope, "symbols");
const defsResolve = scope => def => path.resolve(defsDir(scope), def);
const symbolsResolve = scope => symbol =>
  path.resolve(symbolsDir(scope), symbol);

const corsOptions = {};
if (process.env.SPRITE_CORS_ORIGIN) {
  corsOptions.origin = process.env.SPRITE_CORS_ORIGIN;
}

const dependencies = fs
  .readdirSync(path.resolve(distDir))
  .reduce((acc, scopedFolder) => {
    return {
      ...acc,
      [scopedFolder]: JSON.parse(
        fs.readFileSync(
          path.resolve(distDir, scopedFolder, "dependencies.json"),
          {
            encoding: "utf8",
            flag: "r"
          }
        )
      )
    };
  }, {});

console.log(dependencies);

const app = express();
const svg = (symbols, defs) => {
  return `<svg xmlns="http://www.w3.org/2000/svg"><defs>${
    defs && defs.join("")
  }</defs>${symbols && symbols.join("")}</svg>`;
};
const symbolDeps = scope => symbol => {
  return dependencies[scope][symbol] || [];
};
const nodePromise = nodePath => {
  return new Promise((resolve, _reject) => {
    fs.readFile(nodePath, "utf8", (err, data) => {
      if (err) {
        console.log("ERROR", err);
        resolve("");
      } else {
        resolve(data);
      }
    });
  });
};

const log = payload => {
  console.log(payload);
  return payload;
};

const spritePromise = scope => params => {
  try {
    return compose(
      // collect promises
      ({ symbols, defs }) => symbols.then(s => defs.then(d => svg(s, d))),
      // construct promises of symbols and defs
      ({ symbols, defs }) => ({
        symbols: Promise.all(
          map(compose(nodePromise, symbolsResolve(scope)), symbols)
        ),
        defs: Promise.all(map(compose(nodePromise, defsResolve(scope)), defs))
      }),
      // log,
      // add dependencies of symbols
      reduce(
        (acc, s) => ({
          symbols: [...acc.symbols, s],
          defs: [...acc.defs, ...symbolDeps(scope)(s)]
        }),
        { symbols: [], defs: [] }
      ),
      // log,
      // discard keys
      reduce((acc, [_, o]) => [...acc, ...o], []),
      // log,
      // flattenize everyone into sprite format
      map(([k, o]) => [k, map(o => join("-", [k, o]), split(",", o))]),
      // transform globbed scopes
      map(([k, o]) =>
        o === "*"
          ? [
              k,
              fs
                .readdirSync(symbolsDir(scope))
                .reduce((a, s) => {
                  var m = new RegExp(`^${k}-(.*)`).exec(s);
                  return m ? [...a, m[1]] : a;
                }, [])
                .join(",")
            ]
          : [k, o]
      ),
      // log,
      // transform query into object
      toPairs
    )(params);
  } catch (error) {
    console.log(error);
    return Promise.reject("");
  }
};

app.get("/test/:version", function (req, res) {
  const version = req.params.version;

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

app.get("/:version", cors(corsOptions), function (req, res) {
  const version = req.params.version;

  spritePromise(version)(req.query)
    .then(svgPayload => {
      res.contentType("image/svg");
      res.send(svgPayload);
    })
    .catch(() => res.status(500));
});

app.get("/healthcheck", function (req, res) {
  res.status(200);
});

const server = app.listen(8080, function () {});
