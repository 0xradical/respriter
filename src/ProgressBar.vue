<template>
  <div class='el:m-progress-bar' :class='progressBarStateClass'>
    <template v-if='indeterminate'>
      <div class='el:m-progress-bar__loading'></div>
    </template>
    <template v-else>
      <div class='el:m-progress-bar__total'>
        <div :style="{ width: progressBar + '%' }"
          class='el:m-progress-bar__loaded'></div>
      </div>
      <div class='el:m-progress-bar__feedback'>
        <slot>
          {{ feedback }}
        </slot>
      </div>
    </template>
  </div>
</template>

<script>
  export default {

    props: {
      indeterminate: {
        type: Boolean,
        default: false
      },

      state: {
        type: String,
        default: ''
      },

      progress: {
        type: Number,
        default: 0
      },

      feedback: {
        type: String,
        default: ''
      }

    },

    computed: {

      progressBar () {
        return Math.abs(this.progress) < 100 ? Math.abs(this.progress) : 100
      },

      progressBarStateClass () {
        return {
          'el:m-progress-bar--success': (!this.indeterminate && this.state == 'success'),
          'el:m-progress-bar--error': (!this.indeterminate && this.state == 'error'),
          'el:m-progress-bar--loading': (!this.indeterminate && this.state == 'loading'),
          'el:m-progress-bar--indeterminate': this.indeterminate
        }
      }

    },

    data () {
      return {}
    }
  }
</script>
