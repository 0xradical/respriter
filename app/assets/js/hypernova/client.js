import Vue from "vue";
import hypernova, { load } from "hypernova";

export const vue = Vue;

export const hydrateComponent = (Component, parentNode, data) => {
  const key = name.replace(/\W/g, "");
  const node = parentNode.querySelector('div[data-server-rendered="true"]');

  if (data) {
    const { propsData, state, locale } = data;
    const vm = new Component({ propsData });

    vm.$store.replaceState(state);

    if (node) {
      vm.$mount(node);
    } else {
      parentNode.appendChild(document.createElement("div"));
      vm.$mount(parentNode.children[0]);
    }

    return vm;
  }

  return null;
};

export const renderVueComponent = (
  name,
  ComponentDefinition,
  createStore,
  createI18n
) => {
  return hypernova({
    client() {
      const payloads = load(name);

      if (payloads) {
        payloads.forEach(payload => {
          const { node, data } = payload;
          const { propsData, state, locale } = data;

          const store = createStore();
          const i18n = createI18n(locale || "en");

          const Component = Vue.extend({
            store,
            i18n,
            ...ComponentDefinition
          });

          hydrateComponent(Component, node, data);
        });
      }

      return ComponentDefinition;
    },

    server() {
      throw new Error("Use hypernova/client.js version");
    }
  });
};
