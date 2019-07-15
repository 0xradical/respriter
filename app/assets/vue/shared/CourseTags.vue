<template>
  <div :class='rootClasses' v-if="course.tags && course.tags.length > 1">
    <div v-for="tag in course.tags" :class="[...tagBaseClasses,...tagClasses]" :key="tag" v-html='tag'>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    course: {
      type: Object,
      required: true
    },
    color: {
      type: String,
      default: 'magenta5'
    },
    rootClasses: {
      type: Array,
      defaut() {
        return [];
      }
    },
    tagClasses: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  computed: {
    tagBaseClasses() {
      return [
        'el:m-tag',
        `el:m-tag--${this.color}-flat`
      ];
    }
  }
}
</script>

