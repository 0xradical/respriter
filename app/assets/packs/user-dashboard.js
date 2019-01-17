import Vue from 'vue'

// Vendor
import VueRouter from 'vue-router'
import VueI18n from 'vue-i18n'
import Vuelidate from 'vuelidate'
import VueCurrencyFilter from 'vue-currency-filter'

// i18n
import translations from '../vue/apps/user_dashboard/i18n'

// Components
import AccountSettings from '../vue/apps/user_dashboard/components/AccountSettings.vue'
import Interests from '../vue/apps/user_dashboard/components/Interests.vue'
import Profile from '../vue/apps/user_dashboard/components/Profile.vue'

Vue.use(VueRouter)
Vue.use(Vuelidate)
Vue.use(VueI18n)
Vue.use(VueCurrencyFilter, {
  symbol : '$',
  thousandsSeparator: ',',
  fractionCount: 2,
  fractionSeparator: '.',
  symbolPosition: 'front',
  symbolSpacing: true
})

console.log(translations)

const i18n = new VueI18n({ locale: 'en', messages: translations });

const router = new VueRouter({
  routes: [
    { path: '/',                    name: 'settings',   component: AccountSettings },
    { path: '/profile',             name: 'profile',    component: Profile },
    { path: '/areas-of-interest',   name: 'interests',  component: Interests }
  ]
})

// App
import App from '../vue/apps/user_dashboard/App.vue'

document.addEventListener('DOMContentLoaded', () => {
  let nodes = document.querySelectorAll('[data-vue-app]')
  for(var i = 0; i < nodes.length; ++i) {
    let props = JSON.parse(nodes[i].getAttribute('data-vue-props'))
    new Vue({el: nodes[i], router, i18n, render: h => h(App, { props: props } ) })
  }
});
