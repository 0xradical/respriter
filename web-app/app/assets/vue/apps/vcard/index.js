import { renderVueComponent, vue } from "~~hypernova";
import { createI18n } from "~~i18n";
import { createStore } from "../../../js/store";
import SSRT from "components/SSRT";
import SSRTxt from "components/SSRTxt";
import App from "./App.vue";

vue.component("ssrt", SSRT);
vue.component("ssrtxt", SSRTxt);

export const Vue = vue;

export default function render() {
  return renderVueComponent("VCard", App, createStore, createI18n);
}
