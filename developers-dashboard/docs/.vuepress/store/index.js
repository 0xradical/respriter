import Vue from "vue";
import Vuex from "vuex";
import shared from "./modules/shared";
import menu from "./modules/menu";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    shared,
    menu
  },
  strict: process.env.NODE_ENV !== "production"
});
