const fs = require("fs");
const AWS = require("aws-sdk");
const crypto = require("crypto");
const util = require("util");
const { exec } = require("child_process");
const execAsync = util.promisify(exec);
const readFileAsync = util.promisify(fs.readFile);

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
  if (
    fs.existsSync(resolveScope(scope)()) &&
    fs.existsSync(resolveScoped("dependencies.json")(scope)())
  ) {
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
  var serve =
    cache && cache.length ? compose(s3Upload(scope, params, cache), svg) : svg;

  const { files, ...rest } = params;

  const fallBack = `https://your.assets.cdn.com/sprites.svg`;

  return new Promise(function (resolve, reject) {
    //
    if (!assertScope(scope)) {
      return execAsync(
        `${global.rootDir}/bin/build --SPRITE_VERSION=${scope} --SPRITE_FILES=${
          files || fallBack
        }`
      )
        .then(() => resolve(true))
        .catch(err => reject(err));
    } else {
      return resolve(true);
    }
  })
    .then(() =>
      readFileAsync(resolveScoped("dependencies.json")(scope)(), {
        encoding: "utf8",
        flag: "r"
      })
    )
    .then(dependencies => {
      const manifest = JSON.parse(dependencies);

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
    })
    .catch(error => {
      log(error);
      return Promise.reject(error);
    });
};

module.exports = { processor };
