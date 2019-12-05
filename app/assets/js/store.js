// store.js
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export function createStore() {
  return new Vuex.Store({
    // IMPORTANT: state must be a function so the module can be
    // instantiated multiple times
    state: () => ({
      data: [],
      meta: {}
    }),

    mutations: {
      setData(state, { data = [], meta = {} } = { data, meta }) {
        state.data = data;
        state.meta = meta;
      }
    }
  });
}
