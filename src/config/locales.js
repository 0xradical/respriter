const $ = require("deepmerge");

// en
const enPublic = require("../locales/en/en.yml");
const enBase = require("../locales/en/en.base.yml");
const enUser = require("../locales/en/en.user.yml");
const enTags = require("../locales/en/en.tags.yml");
const en = $.all([enBase, enUser, enTags, enPublic]);

// es
const esPublic = require("../locales/es/es.yml");
const esBase = require("../locales/es/es.base.yml");
const esUser = require("../locales/es/es.user.yml");
const esTags = require("../locales/es/es.tags.yml");
const es = $.all([esBase, esUser, esTags, esPublic]);

// pt-BR
const ptBRPublic = require("../locales/pt-BR/pt-BR.yml");
const ptBRBase = require("../locales/pt-BR/pt-BR.base.yml");
const ptBRUser = require("../locales/pt-BR/pt-BR.user.yml");
const ptBRTags = require("../locales/pt-BR/pt-BR.tags.yml");
const ptBR = $.all([ptBRBase, ptBRUser, ptBRTags, ptBRPublic]);

const all = $.all([en, es, ptBR]);

export default all;
