import Vue from "vue";
import VueI18n from "vue-i18n";
import { identity } from "ramda";

Vue.use(VueI18n);

/**
 *
 * @param {String} locale - Default locale for i18n factory
 * @param {Function} f - Transformation function for all messages
 * @param {Function} g - Configuration function for the i18n instance
 *
 * Use transformation function to add / change messages
 */
export function createI18n(locale = "en", f = identity, g = identity) {
  const i18n = new VueI18n({
    locale: locale,
    messages: {}
  });

  g(i18n);

  return i18n;
}
