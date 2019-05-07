import Vue from 'vue'
import VueI18n from 'vue-i18n'
import VueCurrencyFilter from 'vue-currency-filter'
import VueJsModal from 'vue-js-modal'
import Vuebar from 'vuebar'

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

import CourseBundleApp from '../vue/apps/course_bundle/App.vue'

document.addEventListener('DOMContentLoaded', () => {
  var nodes = document.querySelectorAll('[data-vue-course-bundle-app]')
  for(var i = 0; i < nodes.length; ++i) {
    const messages = JSON.parse(nodes[i].getAttribute('data-vue-course-bundle-app-translations'))
    const i18n = new VueI18n({ locale: 'en', messages})
    const app = new Vue({el: nodes[i], i18n, render: h => h(CourseBundleApp)})
  }

});

