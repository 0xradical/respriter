import render, { Vue } from "../vue/apps/search_page";

import Vuebar from "vuebar";
import VueAutosuggest from "vue-autosuggest";

// vue-based client-only plugins
Vue.use(Vuebar);
Vue.use(VueAutosuggest);

render();
