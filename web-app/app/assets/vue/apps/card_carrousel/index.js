// this will be conditionally built due to
// alias being different for client and server
import { renderVueComponent, vue } from "~~hypernova";
import VueAwesomeSwiper from "~~vue-awesome-swiper";
import "swiper/dist/css/swiper.css";
import ClientOnly from "vue-client-only";
import { createI18n } from "../../../js/i18n";
import { createStore } from "../../../js/store";
import App from "./App.vue";

vue.use(VueAwesomeSwiper);
vue.component("client-only", ClientOnly);

export default function render() {
  return renderVueComponent("CardCarrousel", App, createStore, createI18n);
}
