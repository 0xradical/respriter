const fs = require("fs");
const { execSync } = require("child_process");
const {
  assoc,
  __,
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
  resolveDist,
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

const processor = scope => params => {
  try {
    var manifest = {};

    if (!assertScope(scope)) {
      execSync(
        `${global.rootDir}/bin/build --SPRITE_VERSION=${scope} --SPRITE_URL="https://elements-prd.classpert.com/${scope}/svgs/sprites/\{tags,country-flags,brand,i18n,icons,providers\}.svg"`
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
      ({ symbols, defs }) => symbols.then(s => defs.then(d => svg(s, d))),
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
    )(params);
  } catch (error) {
    log(error);
    return Promise.reject("");
  }
};

module.exports = { processor };
