import Vue from "vue";
import { createI18n } from "./js/i18n";
import App from "./App.vue";

new Vue({
  i18n: createI18n("en"),
  render: h => h(App)
}).$mount("#app");
