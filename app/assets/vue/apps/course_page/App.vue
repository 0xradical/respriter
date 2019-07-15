<template>
  <div>
    <desktop :course="course"></desktop>
    <mobile :course="course"></mobile>
  </div>
</template>

<script>
import Desktop from './Desktop.vue';
import Mobile from './Mobile.vue';

export default {
  props: {
    course: {
      type: Object,
      required: true
    },
    locale: {
      type: String,
      required: false,
      default: 'en'
    }
  },
  components: {
    desktop: Desktop,
    mobile: Mobile
  }
}
</script>

<style lang="scss" scoped>

</style>
