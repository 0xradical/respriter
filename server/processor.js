const fs = require("fs");
const AWS = require("aws-sdk");
const crypto = require("crypto");
const { execSync } = require("child_process");
const {
  flatten,
  compose,
  toPairs,
  map,
  reduce,
  join,
  split
} = require("ramda");
const { svg, log, dataReadAsync } = require("./utils");
const {
  resolveEntry,
  resolveFamily,
  resolveScope,
  resolveScoped
} = require("./resolvers");

function assertScope(scope) {
  if (fs.existsSync(resolveScope(scope)())) {
    return true;
  } else {
    return false;
  }
}

const s3 = new AWS.S3();

const s3Upload = (scope, params, cache) => {
  const orderedQs = toPairs(params)
    .filter(p => p[1] && p[1].length)
    .sort()
    .map(p => p[0] + "=" + p[1].split(",").sort().join(","))
    .join("&");

  const key = crypto
    .createHash("md5")
    .update(`/${scope}/${orderedQs}`)
    .digest("hex");

  return body => {
    s3.upload(
      {
        Bucket: cache,
        Key: key,
        Body: body,
        ContentType: "image/svg"
      },
      function (err, _res) {
        if (err) log("Error while uploading sprite to s3: " + err);
        else log("Sprite successfully uploaded");
      }
    );

    return body;
  };
};

const processor = (scope, cache) => params => {
  try {
    var manifest = {};
    const serve =
      cache && cache.length
        ? compose(s3Upload(scope, params, cache), svg)
        : svg;

    const { files, ...rest } = params;

    const fallBack = `https://elements-prd.classpert.com/${scope}/svgs/sprites/all.svg`;

    if (!assertScope(scope)) {
      execSync(
        `${global.rootDir}/bin/build --SPRITE_VERSION=${scope} --SPRITE_FILES=${
          files || fallBack
        }`
      );
    }

    manifest = JSON.parse(
      fs.readFileSync(resolveScoped("dependencies.json")(scope)(), {
        encoding: "utf8",
        flag: "r"
      })
    );

    return compose(
      // collect promises
      ({ symbols, defs }) => symbols.then(s => defs.then(d => serve(s, d))),
      // construct promises of symbols and defs
      ({ symbols, defs }) => ({
        symbols: Promise.all(
          map(compose(dataReadAsync, resolveEntry("symbols")(scope)), symbols)
        ),
        defs: Promise.all(
          map(compose(dataReadAsync, resolveEntry("defs")(scope)), defs)
        )
      }),
      // log,
      // add dependencies of symbols
      reduce(
        (acc, s) => ({
          symbols: [...acc.symbols, s],
          defs: [...acc.defs, ...(manifest[s] || [])]
        }),
        { symbols: [], defs: [] }
      ),
      // log,
      flatten,
      // flattenize everyone into sprite format
      map(([k, o]) => map(o => join("-", [k, o]), split(",", o))),
      // log,
      // transform globbed scopes
      map(([k, o]) =>
        o === "*"
          ? [
              k,
              fs
                .readdirSync(resolveFamily("symbols")(scope)())
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
    )(rest);
  } catch (error) {
    log(error);
    return Promise.reject("");
  }
};

module.exports = { processor };
