// this will be conditionally built due to
// alias being different for client and server
import { renderVueComponent, vue } from "hypernova-renderer";
import { createI18n } from "../../../js/i18n";
import { createStore } from "../../../js/store";
import App from "./App.vue";

// external libs
import VueSlider from "vue-slider-component/dist-css/vue-slider-component.umd.min";
import VueNumberInput from "@chenfengyuan/vue-number-input/src/number-input.vue";
import VueJsModal from "vue-js-modal";
import ClientOnly from "vue-client-only";

vue.component("client-only", ClientOnly);
vue.component("vue-slider", VueSlider);
vue.component("number-input", VueNumberInput);
vue.use(VueJsModal);

Object.defineProperty(vue.prototype, "$classpert", { value: {} });

export const Vue = vue;

export default function render() {
  return renderVueComponent("SearchPage", App, createStore, createI18n);
}
