<template>
  <div v-if="size">
    <div class='mB10' v-for='course in courses' :key="course.id">
      <course :course='course'></course>
    </div>
  </div>
</template>

<script>
import Course from './Course.vue';

export default {
  props: {
    courses: {
      type: Array,
      required: true,
      default() {
        return [];
      }
    },
    tag: {
      type: String,
      required: false
    }
  },
  components: {
    course: Course
  },
  computed: {
    size() {
      return this.courses.length;
    }
  }
}
</script>


