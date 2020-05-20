// this will be conditionally built due to
// alias being different for client and server
import { renderVueComponent, vue } from "~~hypernova";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { identity, curryN, __ } from "ramda";
import { createI18n } from "../../../js/i18n";
import { createStore } from "../../../js/store";
import App from "./App.vue";

vue.component("ValidationObserver", ValidationObserver);
vue.component("ValidationProvider", ValidationProvider);

export const Vue = vue;

export default function render({
  i18nTransformFn = identity,
  i18nConfigFn = identity
} = {}) {
  return renderVueComponent(
    "ContactUs",
    App,
    createStore,
    curryN(3, createI18n)(__, i18nTransformFn, i18nConfigFn)
  );
}
