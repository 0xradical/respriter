// this will be conditionally built due to
// alias being different for client and server
import { renderVueComponent, vue } from "~~hypernova";
import VueAwesomeSwiper from "~~vue-awesome-swiper";
import "swiper/css/swiper.css";
import { createI18n } from "~~i18n";
import SSRT from "components/SSRT";
import SSRTxt from "components/SSRTxt";
import { createStore } from "../../../js/store";
import App from "./App.vue";

vue.use(VueAwesomeSwiper);
vue.component("ssrt", SSRT);
vue.component("ssrtxt", SSRTxt);

export default function render() {
  return renderVueComponent("CardCarrousel", App, createStore, createI18n);
}
