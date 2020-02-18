let en = {};
let es = {};
let ptBr = {};
let ja = {};

import _ from "lodash";
import enBase from "locales/en/en.base.yml";
import enDevise from "locales/en/en.devise.yml";
import enTags from "locales/en/en.tags.yml";
import enGeneral from "locales/en/en.yml";
import esBase from "locales/es/es.base.yml";
import esDevise from "locales/es/es.devise.yml";
import esTags from "locales/es/es.tags.yml";
import esGeneral from "locales/es/es.yml";
import ptBrBase from "locales/pt-BR/pt-BR.base.yml";
import ptBrDevise from "locales/pt-BR/pt-BR.devise.yml";
import ptBrTags from "locales/pt-BR/pt-BR.tags.yml";
import ptBrGeneral from "locales/pt-BR/pt-BR.yml";
import jaBase from "locales/ja/ja.base.yml";
import jaDevise from "locales/ja/ja.devise.yml";
import jaTags from "locales/ja/ja.tags.yml";
import jaGeneral from "locales/ja/ja.yml";

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

ja = _.merge(ja, jaBase);
ja = _.merge(ja, jaDevise);
ja = _.merge(ja, jaTags);
ja = _.merge(ja, jaGeneral);

let i18n = Object.assign({}, en, es, ptBr, ja);

export default JSON.stringify(i18n);
