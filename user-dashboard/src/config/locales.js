const $ = require("deepmerge");

// en
const enPublic = require("../locales/en/web-app.yml");
const enBase = require("../locales/en/rails.yml");
const enUser = require("../locales/en/user.yml");
const enTags = require("../locales/en/tags.yml");
const enDbs = require("../locales/en/db.yml");
const en = $.all([enBase, enUser, enTags, enPublic, enDbs]);

// es
const esPublic = require("../locales/es/web-app.yml");
const esBase = require("../locales/es/rails.yml");
const esUser = require("../locales/es/user.yml");
const esTags = require("../locales/es/tags.yml");
const esDbs = require("../locales/es/db.yml");
const es = $.all([esBase, esUser, esTags, esPublic, esDbs]);

// pt-BR
const ptBRPublic = require("../locales/pt-BR/web-app.yml");
const ptBRBase = require("../locales/pt-BR/rails.yml");
const ptBRUser = require("../locales/pt-BR/user.yml");
const ptBRTags = require("../locales/pt-BR/tags.yml");
const ptBRTDbs = require("../locales/pt-BR/db.yml");
const ptBR = $.all([ptBRBase, ptBRUser, ptBRTags, ptBRPublic, ptBRTDbs]);

const all = $.all([en, es, ptBR]);

export default all;
