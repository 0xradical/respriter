// this will be conditionally built due to
// alias being different for client and server
import { renderVueComponent, vue } from "~~hypernova";
import { createI18n } from "../../../js/i18n";
import { createStore } from "../../../js/store";
import App from "./App.vue";

export const Vue = vue;

export default function render() {
  return renderVueComponent("CoursePage", App, createStore, createI18n);
}
