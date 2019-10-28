<template>
  <div v-if='showModal' class='container'>
    <div class='row'>
      <modal :name='name' @close='showModal = false' :wrapperClasses="['col-12 col-md-6 col-lg-4']">
        <template #body>
          <div class='el:amx-Pos(r)'>
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
                  :authorize-url='`/user_accounts/auth/${provider}`'
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
              <a target='_blank' href='/promo' class='el:amx-Fs(1em) el:amx-Fw(b) el:amx-C_blue3'>
                <span class='el:amx-Lh(1em)'>{{ $t('promo.read_instructions') }}</span>
              </a>
            </div>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import Icon from './Icon.vue';
import OauthAccount from './OauthAccount.vue';
import Modal from 'elements/src/vue-components/Modal.vue';

export default {
  data() {
    return {
      showModal: false
    }
  },
  props: {
    name: {
      type: String,
      required: true
    },
    locale: {
      type: String,
      required: false,
      default: 'en'
    },
    devise: {
      type: Object,
      required: true
    }
  },
  components: {
    Icon,
    OauthAccount,
    Modal
  },
  methods: {
    open() {
      this.showModal = true;
    }
  },
  created() {
    this.$modals[this.name] = this;
  },
  computed: {
    signInLink() {
      try {
        return this.devise.sign_in;
      } catch (_error) {
        return null;
      }
    },
    signUpLink() {
      try {
        return this.devise.sign_up;
      } catch (_error) {
        return null;
      }
    }
  }
}
</script>