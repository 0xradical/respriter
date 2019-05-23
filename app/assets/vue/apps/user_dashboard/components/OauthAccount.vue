<template>
  <div>
    <a v-if='!connected' :href='authorizeUrl' :class='btnClass' style='max-width:200px'>  Connect with {{ provider }}</a>
    <a v-else @click="$emit('destroyOauth', provider)" :class='btnClass' style='max-width:200px'>  Connected with {{ provider }}</a>
  </div>
</template>
<script>
  export default {
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
      }

    },

    computed: {

      btnClass () {
        return `btn btn--small btn--${this.provider}`
      },

      label () {
        return this.provider.charAt(0).toUpperCase() + this.provider.slice(1)
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
