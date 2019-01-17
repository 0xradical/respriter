<template>
  <div id='account-settings'>

    <div v-if='!account.password_missing'>
      <h4 style='margin-bottom:10px'>
         {{ $t('pages.dashboard_index.html.account_settings_header')  }}
      </h4>
      <form class='c-form'>
        <div class='c-form-ctrl c-form-ctrl--vertical'>
          <label class='c-form-ctrl__label' >E-mail</label>
          <input v-model='account.email' class='c-form-ctrl__input' type='text' />
        </div>
        <br />
        <div class='c-form-ctrl c-form-ctrl--vertical'>
          <label class='c-form-ctrl__label' >Password</label>
          <input class='c-form-ctrl__input' type='text' />
        </div>
        <input type='submit' class='btn btn--gray-flat mx-Mt(10px)'>
      </form>
    </div>

    <section v-if='account.oauths.length > 0' id='oauth-accounts'>
      <h4 style='margin-bottom:10px'>
       {{ $t('pages.dashboard_index.html.connected_oauth_accounts_header')  }}
      </h4>
      <div style='margin-bottom:10px'>
        <ul style='list-style:none;margin:0;padding:0'>
          <li v-for='oauth in account.oauths' style='margin-bottom:10px'>
            <oauth-account @destroyOauth='destroyOauth' :provider='oauth.attributes.provider'
              :connected='true'
              ></oauth-account>
          </li>
        </ul>
      </div>
    </section>

    <h5 style='margin-bottom:10px'>{{ $t('pages.dashboard_index.html.add_oauth_accounts_header')  }}</h5>
    <div>
      <ul style='list-style:none;margin:0;padding:0'>
        <li style='margin-bottom:10px' v-for='provider in otherProviders'>
          <oauth-account 
            :provider='provider'
            :authorize-url='`/user_accounts/auth/${provider}`'
            :connected='false'
            ></oauth-account>
        </li>
      </ul>
    </div>

    <div v-if='account.password_missing' style='margin-top:20px'>
      <h4 style='margin-bottom:10px'>
         {{ $t('pages.dashboard_index.html.secure_your_account_header')  }}
      </h4>

      <form action="/api/user/v1/passwords" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="✓">
        <input type="hidden" name="authenticity_token" :value="formAuthenticityToken">
        <input type="submit" name="commit" value="Create a password" class="btn btn--magenta-border
        btn--small btn--rounded">
      </form>

    </div>

  </div>
</template>

<script>
 import OauthAccount from './OauthAccount.vue'

 export default {

  props: {

    oauthProviders: {
      type: Array,
      default () {
        return ['linkedin', 'github', 'facebook']
      }
    },

    account: {
      type: Object,
      default: function () {
        return {}
      }
    }

  },

  components: {
    OauthAccount
  },

  data () {
    return {}
  },

  computed: {

    formAuthenticityToken () {
      return window.env_context.authenticity_token
    },

    destroyAccountTemplate () {
      return window.env_context.destroyAccountTemplate
    },

    otherProviders() {
      return _.differenceWith(this.oauthProviders, _.map(this.account.oauths, 'attributes.provider'), _.isEqual)
    }
  },

  methods: {

    destroyOauth (provider) {
      var vm = this
      fetch(`/api/user/v1/oauth_accounts/${provider}.json`, { method: 'DELETE' }).then(function (resp) {
        resp.json().then(function (json) {
          vm.account.oauths = json.data
        })
      });
    },

    saveLocalePreferences () {
      var vm = this
      fetch(`/api/user/v1/profile.json`, { 
        headers: { "Content-Type": "application/json; charset=utf-8" },
        method: 'PUT',
        body: JSON.stringify({ preferences: { locale: vm.account.profile.preferences } }) 
      }).then(function (resp) {
        resp.json().then(function (json) {
        })
      });
    }
  }


 }
</script>
