import { renderVueComponent, vue } from "~~hypernova";
import { createI18n } from "../../../js/i18n";
import { createStore } from "../../../js/store";
import App from "./App.vue";

export const Vue = vue;

export default function render() {
  return renderVueComponent("VideoPreview", App, createStore, createI18n);
}
