const fs = require("fs");
const { resolveDist, resolveScoped } = require("./resolvers");
let versions = [];

const manifest = fs.readdirSync(resolveDist()).reduce((acc, scope) => {
  versions = [...versions, scope];

  return {
    ...acc,
    [scope]: JSON.parse(
      fs.readFileSync(resolveScoped("dependencies.json")(scope)(), {
        encoding: "utf8",
        flag: "r"
      })
    )
  };
}, {});

manifest.fetch = scope => symbol => {
  try {
    return manifest[scope][symbol] || [];
  } catch (error) {
    return [];
  }
};

manifest.latest =
  versions && versions.length > 0 ? versions.sort().reverse()[0] : undefined;

module.exports = manifest;
