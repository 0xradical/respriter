import _ from "lodash";

// Vue
import Vue from "vue";

// Vue HighlightJS
import VueHighlightJS from "vue-highlight.js";
import xml from "highlight.js/lib/languages/xml";
import dns from "highlight.js/lib/languages/dns";
import json from "highlight.js/lib/languages/json";
import "highlight.js/styles/github.css";
import "highlight.js/styles/monokai-sublime.css";
Vue.use(VueHighlightJS, {
  languages: { dns, xml, json }
});

// Vue Clipboard
import VueClipboard from "vue-clipboard2";
Vue.use(VueClipboard);

// Vue Tooltip
import VTooltip from "v-tooltip";
Vue.use(VTooltip);

// Vue Multiselect
import Multiselect from "vue-multiselect";
Vue.component("multiselect", Multiselect);

// Vue I18n
import VueI18n from "vue-i18n";
Vue.use(VueI18n);

// Vue Loading Overlay
import VueLoading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
Vue.use(VueLoading);
Vue.component("loading", VueLoading);

import uuidv4 from "uuid/v4";

import { extend, configure, ValidationProvider, ValidationObserver } from "vee-validate";

import { required, max, regex } from "vee-validate/dist/rules";
import enValidations from "vee-validate/dist/locale/en";

// > Fontawesome
import { library } from "@fortawesome/fontawesome-svg-core";
import {
  faCogs,
  faBug,
  faBook,
  faExclamationTriangle,
  faExclamationCircle,
  faInfoCircle
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
library.add(faCogs);
library.add(faBug);
library.add(faBook);
library.add(faExclamationTriangle);
library.add(faExclamationCircle);
library.add(faInfoCircle);

// Import router
import router from "./router";

// Import Vuex Store instance
import store from "~store";

// Import Locales
import translations from "./config/locales";

// Import Domains
import appDomains from "./config/domains";

// Import XHR clients
import { pgrestApi, logDrainApi, crossOriginXHR } from "./config/axiosInstances";

// Import Session
import session from "./config/session";

// Import Env
import env from "./config/environment";

// Global Components
import App from "./components/App.vue";
Vue.component("ValidationProvider", ValidationProvider);
Vue.component("ValidationObserver", ValidationObserver);
Vue.component("font-awesome-icon", FontAwesomeIcon);

translations.en.validations = _.merge(translations.en.validations || {}, enValidations);

const i18n = new VueI18n({
  locale: "en",
  messages: translations
});

configure({
  // Use custom default message handler.
  defaultMessage: (field, values) => {
    values._field_ = i18n.t(`validations.attributes.${field}`);

    return i18n.t(`validations.messages.${values._rule_}`, values);
  }
});

// Add validation rules
extend("required", required);
extend("regex", regex);
extend("max", max);

// Add custom validations
import validations from "./lib/validations";

for (const key in validations) {
  if (Object.prototype.hasOwnProperty.call(validations, key)) {
    extend(key, validations[key](i18n));
  }
}

Vue.prototype.$api = pgrestApi;
Vue.prototype.$logs = logDrainApi;
Vue.prototype.$crossOriginXHR = crossOriginXHR;
Vue.prototype.$session = session;
Vue.prototype.$domains = appDomains;
Vue.prototype.$uuid = uuidv4;
Vue.prototype.$envs = env;

new Vue({
  i18n,
  router,
  store,
  render: h => h(App)
}).$mount("#app");
