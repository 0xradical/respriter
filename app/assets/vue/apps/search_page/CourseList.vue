<template>
  <div v-if="size">
    <div class='el:amx-Mb(0.625em)' v-for='course in courses' :key="course.id">
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


