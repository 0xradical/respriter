import * as merge from 'deepmerge'

import es from '../../../../../config/locales/es.yml'
import esBase from '../../../../../config/locales/es.base.yml'
import esTags from '../../../../../config/locales/es.tags.yml'
let esTranslations = merge.all([es,esBase,esTags])

import en from '../../../../../config/locales/en.yml'
import enBase from '../../../../../config/locales/en.base.yml'
import enTags from '../../../../../config/locales/en.tags.yml'
let enTranslations = merge.all([en,enBase,enTags])

import ptBr from '../../../../../config/locales/pt-BR.yml'
import ptBrBase from '../../../../../config/locales/pt-BR.base.yml'
import ptBrTags from '../../../../../config/locales/pt-BR.tags.yml'
let ptBrTranslations = merge.all([ptBr,ptBrBase,ptBrTags])

let i18n = Object.assign({}, enTranslations, ptBrTranslations, esTranslations)

export default i18n
