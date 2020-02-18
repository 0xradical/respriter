import Vue from "vue";
// common
import { createI18n } from "../js/i18n";
import ContactUs from "../vue/apps/contact_us/App.vue";
import _ from "lodash";

const i18n = createI18n("en");

import {
  install as VeeValidate,
  ValidationProvider,
  ValidationObserver,
  Validator
} from "vee-validate";
import enValidations from "vee-validate/dist/locale/en";
import esValidations from "vee-validate/dist/locale/es";
import ptBrValidations from "vee-validate/dist/locale/pt_BR";
import jaValidations from "vee-validate/dist/locale/ja";

Validator.extend(
  "challenge",
  (value, { first, second } = {}) => {
    return Number(first) + Number(second) === Number(value);
  },
  { paramNames: ["first", "second"] }
);

Vue.use(VeeValidate, {
  i18nRootKey: "validations",
  i18n,
  dictionary: {
    en: enValidations,
    es: esValidations,
    "pt-BR": ptBrValidations,
    ja: jaValidations
  }
});
Vue.component("ValidationProvider", ValidationProvider);
Vue.component("ValidationObserver", ValidationObserver);

document.addEventListener("DOMContentLoaded", () => {
  // loaded by Rails, hydrated by Vue
  // [data-server-rendered="true"]')
  const nodes = Array.prototype.map.call(
    document.querySelectorAll('div[data-hypernova-key="contact_usjs"]'),
    node => {
      let vueNode = node.querySelector('div[data-server-rendered="true"]');
      // if node ssr is offline
      // create a div and inject client-side Vue
      if (vueNode == null) {
        vueNode = document.createElement("div");
        vueNode.dataset["vueContactUs"] = "";
        node.appendChild(vueNode);
      }

      const jsonCdata = document.querySelector(
        `script[data-hypernova-id="${node.dataset["hypernovaId"]}"]`
      ).innerHTML;
      const vueProps = JSON.parse(
        _.unescape(jsonCdata.slice(4, jsonCdata.length - 3))
      );
      return {
        node: vueNode,
        props: vueProps
      };
    }
  );

  for (let i = 0; i < nodes.length; ++i) {
    const { node, props } = nodes[i];
    i18n.locale = props.locale || i18n.locale;

    const app = new Vue({
      i18n: i18n,
      render: h => h(ContactUs, { props: props })
    });

    app.$mount(node);
  }
});
