// this will be conditionally built due to
// alias being different for client and server
import { renderVueComponent, vue } from "~~hypernova";
import { createI18n } from "../../../js/i18n";
import { createStore } from "../../../js/store";
import App from "./App.vue";

// external libs
import "vue-slider-component/dist-css/vue-slider-component.css";
import "@classpert/vendor-styling/dist/vue-slider-component/3.0.css";
import VueSlider from "vue-slider-component/dist-css/vue-slider-component.umd.min";

import "@classpert/vendor-styling/dist/vue-js-modal/1.3.css";
import VueJsModal from "vue-js-modal";
import ClientOnly from "vue-client-only";

vue.component("client-only", ClientOnly);
vue.component("vue-slider", VueSlider);
vue.use(VueJsModal);

Object.defineProperty(vue.prototype, "$classpert", { value: {} });

export const Vue = vue;

export default function render() {
  return renderVueComponent("SearchPage", App, createStore, createI18n);
}
