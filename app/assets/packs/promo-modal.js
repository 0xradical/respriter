import Vue from 'vue';
import VueI18n from 'vue-i18n';
import i18nLocales from './locales';
import PromoModal from '../vue/shared/PromoModal';

Vue.use(VueI18n);

Object.defineProperty(Vue.prototype, '$modals', { value: {} });

document.addEventListener('DOMContentLoaded', () => {
  var nodes = document.querySelectorAll('[data-vue-promo-modal]')

  if(window.__vms__ == null) {
    window.__vms__ = {}
  }

  for(var i = 0; i < nodes.length; ++i) {
    var props = JSON.parse(document.getElementById(nodes[i].getAttribute('data-vue-promo-modal-props')).innerHTML);
    const messages = JSON.parse(i18nLocales);
    const i18n = new VueI18n({ locale: (props.locale || 'en'), messages })
    const app = new Vue({el: nodes[i], i18n, render: h => h(PromoModal, {props: props})})

    window.__vms__[props.name] = app;
  }
});
