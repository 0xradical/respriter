import Vue from 'vue'
import VueI18n from 'vue-i18n'
import VueCurrencyFilter from 'vue-currency-filter'
import VueJsModal from 'vue-js-modal'
import Vuebar from 'vuebar'
import VueAutosuggest from 'vue-autosuggest'
import tippy from 'tippy.js'
import 'tippy.js/dist/tippy.css'
import marked from 'marked';
import DOMPurify from 'dompurify';
import SearchPage from '../vue/apps/search_page/App.vue'

// tippy
tippy.setDefaults({
  animation: 'fade',
  theme: 'quero',
  arrow: true
});
Object.defineProperty(Vue.prototype, '$tippy', { value: tippy });

// marked && friends
Object.defineProperty(Vue.prototype, '$dompurify', { value: DOMPurify });

marked.setOptions({gfm: true, breaks: true})
Object.defineProperty(Vue.prototype, '$marked', { value: marked });

// vue-based plugins
Vue.use(VueI18n);
Vue.use(VueJsModal);
Vue.use(VueCurrencyFilter, {
  symbol : '$',
  thousandsSeparator: ',',
  fractionCount: 2,
  fractionSeparator: '.',
  symbolPosition: 'front',
  symbolSpacing: true
});
Vue.use(Vuebar);
Vue.use(VueAutosuggest);

// Define namespace to avoid global scope pollution
Object.defineProperty(Vue.prototype, '$classpert', { value: {} });

document.addEventListener('DOMContentLoaded', () => {
  var nodes = document.querySelectorAll('[data-vue-search-app]')
  for(var i = 0; i < nodes.length; ++i) {
    var props = JSON.parse(document.getElementById(nodes[i].getAttribute('data-vue-search-app-props')).innerHTML);
    const messages = JSON.parse(nodes[i].getAttribute('data-vue-search-app-translations'))
    const i18n = new VueI18n({ locale: 'en', messages})
    const app = new Vue({el: nodes[i], i18n, render: h => h(SearchPage, {props: props})})
  }
});
