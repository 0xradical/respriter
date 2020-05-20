<template>
  <div>
    <a v-if='!connected' :href='authorizeUrl' :class='btnClass'>
      {{ $t('oauth.connect', {provider: providers[provider] || provider }) }}
    </a>
    <a v-else @click="$emit('destroyOauth', provider)" :class='btnClass'>
      {{ $t('oauth.connected', {provider: providers[provider] || provider }) }}
    </a>
  </div>
</template>
<script>
import { switchCase, switchStatement } from '@babel/types';
  export default {
    data() {
      return {
        providers: {
          linkedin: "LinkedIn",
          github: "Github",
          facebook: "Facebook"
        }
      }
    },
    props: {
      provider: {
        type: String,
        required: true
      },
      connected: {
        type: Boolean,
        default: false
      },
      authorizeUrl: {
        type: String,
        required: false
      },
      size: {
        type: String,
        required: false,
        default: 'medium'
      }
    },

    computed: {
      btnClass () {
        return `btn btn--${this.size} btn--${this.provider}`
      }
    }

  }
</script>
<style scoped lang='scss'>
  .provider {
    fill: #243f52;
    &--github {
      fill: #24292e;
    }
    &--facebook {
      fill: #3b579d;
    }
    &--google {
      fill: #cd4637;
    }
    &--linkedin {
      fill: #0077B5;
    }
  }
</style>
