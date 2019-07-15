let en   = {};
let es   = {};
let ptBr = {};

import _ from 'lodash';
import enBase from '../../../config/locales/en/en.base.yml';
import enDevise from '../../../config/locales/en/en.devise.yml';
import enTags from '../../../config/locales/en/en.tags.yml';
import enGeneral from '../../../config/locales/en/en.yml';
import esBase from '../../../config/locales/es/es.base.yml';
import esDevise from '../../../config/locales/es/es.devise.yml';
import esTags from '../../../config/locales/es/es.tags.yml';
import esGeneral from '../../../config/locales/es/es.yml';
import ptBrBase from '../../../config/locales/pt-BR/pt-BR.base.yml';
import ptBrDevise from '../../../config/locales/pt-BR/pt-BR.devise.yml';
import ptBrTags from '../../../config/locales/pt-BR/pt-BR.tags.yml';
import ptBrGeneral from '../../../config/locales/pt-BR/pt-BR.yml';

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

let i18n = Object.assign({},en,es,ptBr);

export default JSON.stringify(i18n);
