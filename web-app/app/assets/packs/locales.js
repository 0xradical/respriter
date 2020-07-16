let en = {};
let es = {};
let ptBr = {};
let ja = {};
let de = {};
let fr = {};

import _ from "lodash";
import enRails from "locales/en/rails.yml";
import enDevise from "locales/en/devise.yml";
import enTags from "locales/en/tags.yml";
import enWebApp from "locales/en/web-app.yml";

import esRails from "locales/es/rails.yml";
import esDevise from "locales/es/devise.yml";
import esTags from "locales/es/tags.yml";
import esWebApp from "locales/es/web-app.yml";

import ptBrRails from "locales/pt-BR/rails.yml";
import ptBrDevise from "locales/pt-BR/devise.yml";
import ptBrTags from "locales/pt-BR/tags.yml";
import ptBrWebApp from "locales/pt-BR/web-app.yml";

import jaRails from "locales/ja/rails.yml";
import jaDevise from "locales/ja/devise.yml";
import jaTags from "locales/ja/tags.yml";
import jaWebApp from "locales/ja/web-app.yml";

import deRails from "locales/de/rails.yml";
import deDevise from "locales/de/devise.yml";
import deTags from "locales/de/tags.yml";
import deWebApp from "locales/de/web-app.yml";

import frRails from "locales/fr/rails.yml";
import frDevise from "locales/fr/devise.yml";
import frTags from "locales/fr/tags.yml";
import frWebApp from "locales/fr/web-app.yml";

en = _.merge(en, enRails);
en = _.merge(en, enDevise);
en = _.merge(en, enTags);
en = _.merge(en, enWebApp);

es = _.merge(es, esRails);
es = _.merge(es, esDevise);
es = _.merge(es, esTags);
es = _.merge(es, esWebApp);

ptBr = _.merge(ptBr, ptBrRails);
ptBr = _.merge(ptBr, ptBrDevise);
ptBr = _.merge(ptBr, ptBrTags);
ptBr = _.merge(ptBr, ptBrWebApp);

ja = _.merge(ja, jaRails);
ja = _.merge(ja, jaDevise);
ja = _.merge(ja, jaTags);
ja = _.merge(ja, jaWebApp);

de = _.merge(de, deRails);
de = _.merge(de, deDevise);
de = _.merge(de, deTags);
de = _.merge(de, deWebApp);

fr = _.merge(fr, frRails);
fr = _.merge(fr, frDevise);
fr = _.merge(fr, frTags);
fr = _.merge(fr, frWebApp);

let i18n = Object.assign({}, en, es, ptBr, ja, de, fr);

export default JSON.stringify(i18n);
