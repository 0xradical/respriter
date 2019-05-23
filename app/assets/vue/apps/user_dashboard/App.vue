<template>
<div class='container'>
  <div class='row logged'>
    <div class='col-3' style='border-right: 1px solid #DEE7ED;height:100%;'>
      <div class='mx-Mt-1' style="margin-bottom:40px;display:flex;flex-direction:column;align-items:center;">
        <img v-if="account.profile.attributes.avatar" :src="account.profile.attributes.avatar"
        width='76px' style='border-radius:50%;border:1px solid #eee'>
        <svg v-else width='76px' height='76px'>
          <use xlink:href='#icons-avatar'></use>
        </svg>
        <button class='btn btn--blue-flat btn--tiny' style='margin-top:10px' id="pick-avatar">
          {{ $t('pages.dashboard_index.html.upload_image_button') }}
        </button>
        <avatar-cropper
          @uploaded="handleUploaded"
          :labels='{"cancel": "Cancel", "submit": "Submit"}'
          trigger="#pick-avatar"
          upload-url="/api/user/v1/images.json" />
      </div>

      <div style='margin-top:10px' v-if='account.profile.name'>
        <h5 style='margin-top:20px'>Name</h5>
        <span>{{ account.profile.name }}</span>
      </div>

      <div class='mx-Mt(20px) mx-Mb(20px)'>
        <h5>E-mail</h5>
        <span>{{ account.email }}</span>
      </div>

      <hr />

      <ul style='list-style:none;margin:0;padding:0'>
        <li>
          <router-link :to="{name: 'settings'}">
            {{ $t('pages.dashboard_index.html.account_settings_link') }}
          </router-link>
        </li>
        <li>
          <router-link :to="{name: 'interests'}">
            {{ $t('pages.dashboard_index.html.interests_link') }}
          </router-link>
        </li>
      </ul>

      <div class='mx-Mt(20px)'>
        <a data-method='delete' href='/user_accounts/sign_out'>
          {{ $t('dictionary.sign_out') }}
        </a>
      </div>

    </div>
    <div class='col-9'>
      <div class='mx-Mt-1'>
        <router-view @removeTag='removeTagFromInterests' :account='account' :prefs='account.profile.attributes.interests'></router-view>
      </div>
    </div>
  </div>
</div>
</template>

<script>
  import _ from 'lodash';
  import AvatarCropper from "vue-avatar-cropper"

  export default {

    props: {
      locale: {
        type: String,
        default: 'en'
      }
    },

    components: {
      AvatarCropper
    },

    data () {
      return {
        userAvatar: undefined,
        account: {
          profile: {
            attributes: {
              avatar: '',
              preferences: [],
              interests: []
            }
          },
          oauths: [],
          email: ''
        }
      }
    },

    mounted () {

      this.$i18n.locale = this.locale
      var vm = this

      fetch('/api/user/v1/account.json?include=profile',
        {
          method: 'GET',
          headers: { 'Content-Type': 'application/vnd.api+json'}
        }).then(function (resp) {
        resp.json().then(function (json) {
          vm.account.email            = json.data.attributes.email
          vm.account.password_missing = json.data.attributes.password_missing
          vm.account.profile          = _.filter(json.included, { type: 'profile' })[0]
          vm.account.oauths           = _.filter(json.included, { type: 'oauth_account' })
        })
      });

    },

    methods: {

      handleUploaded(json) {
        this.account.profile.attributes.avatar = json.data.attributes.file.sm.url
      },

      removeTagFromInterests (tag) {
        var vm = this
        fetch(`/api/user/v1/interests/${tag}.json`, { method: 'DELETE' }).then(function (resp) {
          resp.json().then(function (json) {
            vm.account.profile.attributes.interests = json.length > 0 ? json : []
          })
        });
      }

    }

  }

</script>

<style scoped lang='scss'>
hr {
  border: 0px;
  border-bottom: 1px solid #DEE7ED;
}
</style>
