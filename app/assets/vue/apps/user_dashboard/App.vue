<template>
<div class='container'>
  <div class='row el:amx-D(n)@>lg'>
    <div class='col-12'>
      <div class='el:amx-Mt(1.25em)' style="display:flex;flex-direction:column;align-items:center;">
        <img v-if="account.profile.attributes.avatar" :src="account.profile.attributes.avatar"
        width='76px' style='border-radius:50%;border:1px solid #eee'>
        <svg v-else width='76px' height='76px'>
          <use xlink:href='#icons-avatar'></use>
        </svg>
        <button class='btn btn--blue-flat btn--small' style='margin-top:10px' id="pick-avatar">
          {{ $t('pages.dashboard_index.html.upload_image_button') }}
        </button>
        <avatar-cropper
          @uploaded="handleUploaded"
          :labels='{"cancel": "Cancel", "submit": "Submit"}'
          trigger="#pick-avatar"
          upload-url="/api/user/v1/images.json" />
      </div>

      <div style='display:flex;flex-direction:column;align-items:center;'>
        <div style='el:amx-Mt(0.625em)' v-if='account.profile.name'>
          <h5 style='margin-top:20px'>Name</h5>
          <span>{{ account.profile.name }}</span>
        </div>

        <div class='el:amx-Mt(0.625em) el:amx-Mb(0.625em)'>
          <h5 style='margin-top:20px;text-align:center;'>E-mail</h5>
          <span class='email'>{{ account.email }}</span>
        </div>
      </div>
    </div>
  </div>

  <div class='row el:amx-D(n)@>lg'>
    <div style='padding-top:2em;width:100%;'>
      <ul class="nav nav-tabs">
        <li class="nav-item" style='width:50%;text-align:center;'>
          <router-link :to="{name: 'settings'}" style='border-right:none;' class="nav-link el:amx-Pt(1em) el:amx-Pb(1em) el:amx-C_blue2" exact-active-class="active el:amx-Fw(b)">
            {{ $t('pages.dashboard_index.html.account_settings_link') }}
          </router-link>
        </li>
        <li class="nav-item" style='width:50%;text-align:center;'>
          <router-link :to="{name: 'interests'}" class="nav-link el:amx-Pt(1em) el:amx-Pb(1em) el:amx-C_blue2" exact-active-class="active el:amx-Fw(b)">
            {{ $t('pages.dashboard_index.html.interests_link') }}
          </router-link>
        </li>
      </ul>
    </div>
  </div>

  <div class='row logged'>
    <div class='col-3 el:amx-D(n)@<sm' style='border-right: 1px solid #DEE7ED;height:100%;'>
      <div class='el:amx-Mt(1.25em)' style="margin-bottom:40px;display:flex;flex-direction:column;align-items:center;">
        <img v-if="account.profile.attributes.avatar" :src="account.profile.attributes.avatar"
        width='76px' style='border-radius:50%;border:1px solid #eee'>
        <svg v-else width='76px' height='76px'>
          <use xlink:href='#icons-avatar'></use>
        </svg>
        <button class='btn btn--blue-flat btn--small' style='margin-top:10px' id="pick-avatar">
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

      <div class='el:amx-Mt(1.25em) el:amx-Mb(1.25em)'>
        <h5>E-mail</h5>
        <span class='email'>{{ account.email }}</span>
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

      <div class='el:amx-Mt(1.25em)'>
        <a data-method='delete' href='/user_accounts/sign_out'>
          {{ $t('dictionary.sign_out') }}
        </a>
      </div>


    </div>
    <div class='col-12 col-lg-9'>
      <div class='el:amx-Mt(1.25em)'>
        <router-view @removeTag='removeTagFromInterests' :account='account' :prefs='account.profile.attributes.interests'></router-view>
      </div>
    </div>
  </div>

  <div class='row el:amx-D(n)@>lg' style='border-top: 1px solid #DEE7ED;padding:2em;margin-top:1em;text-align:center;'>
    <div class='col-12'>
      <a class='el:amx-C_blue2' data-method='delete' href='/user_accounts/sign_out'>
        {{ $t('dictionary.sign_out') }}
      </a>
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
@import '~elements/src/scss/config/variables.scss';
@import '~elements/src/scss/config/functions.scss';

hr {
  border: 0px;
  border-bottom: 1px solid #DEE7ED;
}
.email {
  overflow: hidden;
  display: inline-block;
  max-width: 100%;
  text-overflow: ellipsis;
}
.nav-tabs {
  border-bottom: 1px solid get-color("gray",2);

  .nav-link {
    border-color: get-color("gray",2);
    border-radius: 0;

    &.active {
      border-bottom-color: white;
    }
  }
}
</style>
