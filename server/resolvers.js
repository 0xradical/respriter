const path = require("path");
global.rootDir = path.resolve(__dirname, "..");
const distDir = path.resolve(global.rootDir, "dist");
const resolveDist = (...args) => path.resolve(distDir, ...args);
const resolveScope = scope => (...args) => resolveDist(scope, ...args);
const resolveScoped = name => scope => (...args) =>
  resolveScope(scope)(name, ...args);

const resolveDefs = resolveScoped("defs");
const resolveSymbols = resolveScoped("symbols");

const familyResolvers = { symbols: resolveSymbols, defs: resolveDefs };
const resolveFamily = family => familyResolvers[family];
const resolveEntry = entry => resolveFamily(entry);

module.exports = {
  rootDir: global.rootDir,
  distDir,
  resolveDist,
  resolveScope,
  resolveScoped,
  resolveDefs,
  resolveSymbols,
  resolveFamily,
  resolveEntry
};
