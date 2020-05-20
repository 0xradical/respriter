import _ from "lodash";
import Vue from "vue";
import VueI18n from "vue-i18n";

let en = {};
let es = {};
let ptBr = {};

import enBase from "i18n/en/en.base.yml";
import enDevise from "i18n/en/en.devise.yml";
import enTags from "i18n/en/en.tags.yml";
import enGeneral from "i18n/en/en.yml";
import esBase from "i18n/es/es.base.yml";
import esDevise from "i18n/es/es.devise.yml";
import esTags from "i18n/es/es.tags.yml";
import esGeneral from "i18n/es/es.yml";
import ptBrBase from "i18n/pt-BR/pt-BR.base.yml";
import ptBrDevise from "i18n/pt-BR/pt-BR.devise.yml";
import ptBrTags from "i18n/pt-BR/pt-BR.tags.yml";
import ptBrGeneral from "i18n/pt-BR/pt-BR.yml";

en = _.merge(en, enBase);
en = _.merge(en, enDevise);
en = _.merge(en, enTags);
en = _.merge(en, enGeneral);

es = _.merge(es, esBase);
es = _.merge(es, esDevise);
es = _.merge(es, esTags);
es = _.merge(es, esGeneral);

ptBr = _.merge(ptBr, ptBrBase);
ptBr = _.merge(ptBr, ptBrDevise);
ptBr = _.merge(ptBr, ptBrTags);
ptBr = _.merge(ptBr, ptBrGeneral);

const locales = Object.assign({}, en, es, ptBr);

Vue.use(VueI18n);

export function createI18n(locale = "en") {
  const messages = locales;

  return new VueI18n({
    locale: locale,
    messages
  });
}
