<template>
  <div :class="rootClasses">
    <a
      target="_blank"
      :href="course.gateway_path"
      @click="e => (clickHandler ? e.preventDefault() || clickHandler() : null)"
      class="el:m-button el:m-button--rounded el:m-button--primary-flat"
      :class="buttonClasses"
      rel="nofollow"
    >
      {{ $t("dictionary.go_to_course") }}
    </a>
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
      clickHandler: {
        type: Function,
        required: false,
        default: undefined
      },
      buttonClasses: {
        type: Array,
        default() {
          return [];
        }
      }
    }
  };
</script>
