import Vue from 'vue';
import VueI18n from 'vue-i18n';
import i18nLocales from '../packs/locales';

Vue.use(VueI18n);

export function createI18n (locale = 'en') {
  const messages = JSON.parse(i18nLocales);

  return new VueI18n({
    locale: locale,
    messages
  });
}
