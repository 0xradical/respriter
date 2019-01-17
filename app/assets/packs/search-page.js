import Vue from 'vue'
import VueI18n from 'vue-i18n'
import VueCurrencyFilter from 'vue-currency-filter'
import VueJsModal from 'vue-js-modal'

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

import SearchPage from '../vue/apps/search_page/App.vue'

document.addEventListener('DOMContentLoaded', () => {
  var nodes = document.querySelectorAll('[data-vue-search-app]')
  for(var i = 0; i < nodes.length; ++i) {
    var props = JSON.parse(document.getElementById(nodes[i].getAttribute('data-vue-search-app-props')).innerHTML);
    const messages = JSON.parse(nodes[i].getAttribute('data-vue-search-app-translations'))
    const i18n = new VueI18n({ locale: 'en', messages})
    const app = new Vue({el: nodes[i], i18n, render: h => h(SearchPage, {props: props})})
  }

});
