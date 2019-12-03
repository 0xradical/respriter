import Vue from "vue";
import { createRenderer } from "vue-server-renderer";
import hypernova, { serialize } from "hypernova";

export const vue = Vue;

export const renderVueComponent = (
  name,
  ComponentDefinition,
  createStore,
  createI18n
) => {
  return hypernova({
    client() {
      throw new Error("Use hypernova/server.js version");
    },
    server() {
      return async data => {
        let context = {};
        const { propsData, state, locale } = data;

        const store = createStore();
        const i18n = createI18n(locale || "en");

        const Component = Vue.extend({
          store,
          i18n,
          ...ComponentDefinition
        });

        const vm = new Component({ propsData });

        vm.$store.commit("setData", state);

        const renderer = createRenderer();

        const contents = await renderer
          .renderToString(vm, context)
          .then(html => {
            return `
          ${context.renderStyles()}
          ${html}
          `;
          })
          .catch(err => {
            console.error(err);

            return ``;
          });

        return serialize(name, contents, { propsData, state: vm.$store.state });
      };
    }
  });
};
