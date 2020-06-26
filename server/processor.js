const fs = require("fs");
const { compose, toPairs, map, reduce, join, split } = require("ramda");
const { svg, log, dataReadAsync } = require("./utils");
const { resolveEntry, resolveFamily, resolveScope } = require("./resolvers");

function assertScope(scope) {
  if (fs.existsSync(resolveScope(scope)())) {
    return true;
  } else {
    return false;
  }
}

const builder = manifest => scope => params => {
  try {
    if (!assertScope(scope)) {
      throw "Scope does not exist";
    }

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
          defs: [...acc.defs, ...manifest.fetch(scope)(s)]
        }),
        { symbols: [], defs: [] }
      ),
      // log,
      // discard keys
      reduce((acc, [_, o]) => [...acc, ...o], []),
      // log,
      // flattenize everyone into sprite format
      map(([k, o]) => [k, map(o => join("-", [k, o]), split(",", o))]),
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

module.exports = { builder };
