import vue from 'vue';
import { createRenderer } from 'vue-server-renderer';
import hypernova, { serialize, load } from 'hypernova';

export const Vue = vue;

export const renderVue = (name, Component) => hypernova({
  server() {
    return async (propsData) => {
      var context = {};
      let componentProperties = { propsData };

      if(Component.__instanceLevelProperties) {
        Object.assign(componentProperties, Component.__instanceLevelProperties);
      }

      const vm = new Component(componentProperties);

      const renderer = createRenderer();

      const contents = await renderer.renderToString(vm, context).then(html => {
        return `
        ${context.renderStyles()}
        ${html}
        `;
      }).catch(err => {
        console.error(err)
      })

      return serialize(name, contents, propsData);
    };
  },

  client() {
    const payloads = load(name);
    if (payloads) {
      payloads.forEach((payload) => {
        const { node, data: propsData } = payload;

        const vm = new Component({
          propsData,
        });

        vm.$mount(node.children[0]);
      });
    }

    return Component;
  },
});


export const renderVuex = (name, ComponentDefinition, createStore) => hypernova({
  server() {
    return async (propsData) => {
      const store = createStore();

      const Component = Vue.extend({
        ...ComponentDefinition,
        store,
      });

      const vm = new Component({
        propsData,
      });

      const renderer = createRenderer();

      const contents = await renderer.renderToString(vm);

      return serialize(name, contents, { propsData, state: vm.$store.state });
    };
  },

  client() {
    const payloads = load(name);
    if (payloads) {
      payloads.forEach((payload) => {
        const { node, data } = payload;
        const { propsData, state } = data;
        const store = createStore();

        const Component = Vue.extend({
          ...ComponentDefinition,
          store,
        });

        const vm = new Component({
          propsData,
        });

        vm.$store.replaceState(state);

        vm.$mount(node.children[0]);
      });
    }

    return ComponentDefinition;
  },
});
