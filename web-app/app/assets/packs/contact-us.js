import { mergeDeepRight } from "ramda";
import { extend, configure } from "vee-validate";
import { required, min, email } from "vee-validate/dist/rules";

extend("required", required);
extend("min", min);
extend("email", email);
extend("challenge", {
  validate: (value, { first, second } = {}) => {
    return Number(first) + Number(second) === Number(value);
  },
  params: ["first", "second"]
});

const langs = ["en", "es", "pt-BR", "ja", "de", "fr"];

import render from "../vue/apps/contact_us";

render({
  i18nTransformFn: messages => {
    return langs.reduce((messages, lang) => {
      return mergeDeepRight(messages, {
        [lang]: {
          validations: require(`vee-validate/dist/locale/${lang.replace(
            "-",
            "_"
          )}.json`)
        }
      });
    }, messages);
  },
  i18nConfigFn: i18n => {
    configure({
      // Use custom default message handler.
      defaultMessage: (field, values) => {
        values._field_ = i18n.t(`validations.attributes.${field}`);

        return i18n.t(`validations.messages.${values._rule_}`, values);
      }
    });
  }
});
