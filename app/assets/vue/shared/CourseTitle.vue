<template>
  <div :class='["el:m-text-clipbox",...rootClasses]'>
    <a v-if='hyperlink' class='el:m-text-clipbox__text el:amx-Fw(b)' :class='[...titleBaseClasses, ...titleClasses]' :href='hyperlinkRef' rel='nofollow' target='_blank' :title='course.name'>
      {{ course.name }}
    </a>
    <span v-else class='el:m-text-clipbox__text el:amx-Fw(b)' :class='[...titleBaseClasses, ...titleClasses]'>
      {{ course.name }}
    </span>
  </div>
</template>

<script>
export default {
  props: {
    course: {
      type: Object,
      required: true
    },
    rootClasses: {
      type: Array,
      default() {
        return [];
      }
    },
    titleClasses: {
      type: Array,
      default() {
        return [];
      }
    },
    lines: {
      type: Number,
      default: 2
    },
    hyperlink: {
      type: Boolean,
      default: true
    },
    hyperlinkRef: {
      type: String,
      default() {
        return this.course.gateway_path;
      }
    }
  },
  computed: {
    titleBaseClasses() {
      return [`el:m-text-clipbox__text--${this.lines}-lined`];
    }
  }
}
</script>

