// this will be conditionally built due to
// alias being different for client and server
import { renderVueComponent } from "hypernova-renderer";
import { createI18n } from "../../../js/i18n";
import { createStore } from "../../../js/store";
import CoursePage from "./App.vue";

export default renderVueComponent(
  "CoursePage",
  CoursePage,
  createStore,
  createI18n
);
