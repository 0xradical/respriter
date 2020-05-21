const $ = require("deepmerge");

const locales = ["en", "es", "pt-BR", "ja"];

const all = $.all(
  locales.map(locale => {
    const _public = require(`../locales/${locale}/web-app.yml`);
    const _base = require(`../locales/${locale}/rails.yml`);
    const _user = require(`../locales/${locale}/user.yml`);
    const _tags = require(`../locales/${locale}/tags.yml`);
    const _dbs = require(`../locales/${locale}/db.yml`);

    return $.all([_base, _user, _tags, _public, _dbs]);
  })
);

export default all;
