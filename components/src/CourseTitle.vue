<template>
  <div :class="['el:m-text-clipbox', ...rootClasses]">
    <a
      v-if="hyperlink"
      class="el:m-text-clipbox__text fw-b"
      @click="e => (clickHandler ? e.preventDefault() || clickHandler() : null)"
      :class="[...titleBaseClasses, ...titleClasses]"
      :href="hyperlinkRef"
      rel="nofollow"
      target="_blank"
      :title="course.name"
    >
      {{ course.name }}
    </a>
    <component
      :is="tag"
      v-else
      class="el:m-text-clipbox__text fw-b"
      :class="[...titleBaseClasses, ...titleClasses]"
    >
      {{ course.name }}
    </component>
  </div>
</template>

<script>
  export default {
    props: {
      course: {
        type: Object,
        required: true
      },
      tag: {
        type: String,
        default: "span"
      },
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      clickHandler: {
        type: Function,
        required: false,
        default: undefined
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
  };
</script>
