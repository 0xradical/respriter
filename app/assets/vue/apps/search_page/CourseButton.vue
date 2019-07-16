<template>
  <div :class='rootClasses'>
    <a target='_blank' :href='course.gateway_path' class='btn btn--rounded btn--blue-flat' :class='buttonClasses' rel='nofollow'>
      {{ $t('dictionary.go_to_course') }}
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
    buttonClasses: {
      type: Array,
      default() {
        return [];
      }
    }
  }
}
</script>
