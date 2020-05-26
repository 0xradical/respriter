let en = {};
let es = {};
let ptBr = {};
let ja = {};

import _ from "lodash";
import enBase from "locales/en/rails.yml";
import enDevise from "locales/en/devise.yml";
import enTags from "locales/en/tags.yml";
import enGeneral from "locales/en/web-app.yml";
import esBase from "locales/es/rails.yml";
import esDevise from "locales/es/devise.yml";
import esTags from "locales/es/tags.yml";
import esGeneral from "locales/es/web-app.yml";
import ptBrBase from "locales/pt-BR/rails.yml";
import ptBrDevise from "locales/pt-BR/devise.yml";
import ptBrTags from "locales/pt-BR/tags.yml";
import ptBrGeneral from "locales/pt-BR/web-app.yml";
import jaBase from "locales/ja/rails.yml";
import jaDevise from "locales/ja/devise.yml";
import jaTags from "locales/ja/tags.yml";
import jaGeneral from "locales/ja/web-app.yml";

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
