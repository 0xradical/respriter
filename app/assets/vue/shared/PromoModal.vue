<template>
   <modal :adaptive="true" :width='mobileViewport() ? "100%" : "33%"' :height='mobileViewport() ? "100%" : "auto"' :scrollable='false' :name='name' style='z-index:1000!important'>
      <div class='el:amx-Pt(5em) el:amx-Pt(1.875em)@>lg el:amx-Pr(1.875em) el:amx-Pb(1.875em) el:amx-Pl(1.875em) el:amx-Pos(r)'>
        <div class='el:amx-Pos(a)' aria-label="Close" @click='$modal.hide(name)' style='top: 0.875em; right: 0.875em;'>
          <icon name='close' width='1rem' height='1rem' cursor='pointer' class='el:amx-C_blue3'></icon>
        </div>
        <div class='el:amx-Fs(1.5em) el:amx-Lh(1.5) el:amx-Fw(b) el:amx-C_gray5'>
          {{ $t('promo.title') }}
        </div>
        <div class='el:amx-Fs(1em) el:amx-Lh(1.2) el:amx-C_gray3 el:amx-Mt(1em) el:amx-Mt(0.5em)@>lg'
             v-html="$t('promo.subtitle', { benefit: `<span class='el:amx-C_magenta3 el:amx-Fw(b)'>${$t('promo.benefit')}</span>`})">
        </div>
        <div class='el:amx-Fs(0.75em) el:amx-C_gray3 el:amx-Lh(1) el:amx-Mt(1em) el:amx-Mt(0.75em)@>lg'>
          {{ $t('promo.login') }}
        </div>
        <ul class='el:amx-Mt(1.5em) el:amx-Mt(1.125em)@>lg el:amx-Mb(1.5em) el:amx-Mb(1em)@>lg' style='list-style:none;padding:0'>
          <li class='el:amx-Mb(1em) el:amx-Mb(0.5em)@>lg' v-for="provider in ['linkedin', 'github', 'facebook']" :key='provider'>
            <oauth-account
              :provider='provider'
              :authorize-url='`/user_accounts/auth/${provider}?redirect_to=${course.gateway_path}`'
              :connected='false'
              ></oauth-account>
          </li>
        </ul>
        <div class='container'>
          <div class='row'>
            <div class='col-6' style='padding-left: 0'>
              <a :href="signInLink" class='btn btn--medium btn--blue-border btn--block'>
                {{ $t('dictionary.sign_in') }}
              </a>
            </div>
            <div class='col-6' style='padding-right: 0'>
              <a :href="signUpLink" class='btn btn--medium btn--blue-border btn--block'>
                {{ $t('dictionary.sign_up') }}
              </a>
            </div>
          </div>
        </div>
        <div class='el:amx-Mt(4em) el:amx-Mt(2em)@>lg el:amx-Ta(c)'>
          <a target='_blank' :href='course.gateway_path' class='el:amx-Fs(1em) el:amx-Fw(b) el:amx-C_gray3'>
            <span class='el:amx-Lh(1em)'>{{ $t('promo.nologin') }}</span><icon name='arrow-down' transform='rotate(-90deg)' width='0.875em' height='0.875em' cursor='pointer' class='el:amx-Ml(0.25em) el:amx-C_gray3 el:amx-D(ib) el:amx-Va(m)'></icon>
          </a>
        </div>
      </div>
    </modal>
</template>

<script>
import Icon from './Icon.vue';
import OauthAccount from './OauthAccount.vue';

export default {
  props: {
    name: {
      type: String,
      required: true
    },
    course: {
      type: Object,
      required: true
    }
  },
  components: {
    Icon,
    OauthAccount
  },
  methods: {
    mobileViewport: function() {
      try {
        let width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
        return width < parseInt(Elements.breakpoints.lg);
      } catch (_error) {
        return false
      }
    }
  },
  computed: {
    signInLink() {
      try {
        return `${window.env_context.devise.sign_in}?redirect_to=${this.course.gateway_path}`;
      } catch (_error) {
        return null;
      }
    },
    signUpLink() {
      try {
        return `${window.env_context.devise.sign_up}?redirect_to=${this.course.gateway_path}`;
      } catch (_error) {
        return null;
      }
    }
  }
}
</script>