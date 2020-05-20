import { merge } from "lodash";
// Vue
import Vue from "vue";
// Vue Libs
import VueI18n from "vue-i18n";
import Multiselect from "vue-multiselect";
import VCalendar from "v-calendar";
import money from "v-money";
import uuidv4 from "uuid/v4";
import SocialSharing from "vue-social-sharing";

// Vue Loading Overlay
import VueLoading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
Vue.use(VueLoading);
Vue.component("loading", VueLoading);

import {
  extend,
  configure,
  ValidationProvider,
  ValidationObserver
} from "vee-validate";

import {
  required,
  email,
  min,
  max,
  min_value,
  max_value,
  regex
} from "vee-validate/dist/rules";
import enValidations from "vee-validate/dist/locale/en";
import esValidations from "vee-validate/dist/locale/es";
import ptBrValidations from "vee-validate/dist/locale/pt_BR";

// Import router
import router from "./router";

// Import Vuex Store instance
import store from "./store";

// Import Locales
import translations from "./config/locales";

// Import Root Tags (Deprecated)
import rootTags from "./config/root_tags";

// Import Domains
import appDomains from "./config/domains";

// Import XHR clients
import { pgrestApi, railsApi, crossOriginXHR } from "./config/axiosInstances";

// Import Session
import session from "./config/session";

// Global Components
import App from "./components/App.vue";
import Icon from "./components/Icon.vue";
Vue.component("icon", Icon);

Vue.component("multiselect", Multiselect);
Vue.component("ValidationProvider", ValidationProvider);
Vue.component("ValidationObserver", ValidationObserver);

// Hook plugins
Vue.use(VueI18n);

translations.en.validations = merge(
  translations.en.validations || {},
  enValidations
);
translations.es.validations = merge(
  translations.es.validations || {},
  esValidations
);
translations["pt-BR"].validations = merge(
  translations["pt-BR"].validations || {},
  ptBrValidations
);

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
extend("email", email);
extend("min", min);
extend("max", max);
extend("min_value", min_value);
extend("max_value", max_value);
extend("regex", regex);

// Add custom validations
import validations from "./lib/validations";

for (const key in validations) {
  if (Object.prototype.hasOwnProperty.call(validations, key)) {
    extend(key, validations[key](i18n));
  }
}

Vue.use(money, { precision: 2 });
Vue.use(VCalendar);
Vue.use(SocialSharing);

Vue.prototype.$api = pgrestApi;
Vue.prototype.$railsApi = railsApi;
Vue.prototype.$crossOriginXHR = crossOriginXHR;
Vue.prototype.$session = session;
Vue.prototype.$domains = appDomains;
Vue.prototype.$rootTags = rootTags;
Vue.prototype.$uuid = uuidv4;

new Vue({
  i18n,
  router,
  store,
  render: h => h(App)
}).$mount("#app");
