<template>
  <div v-if="size">
    <div v-if="tag == 'chess' || tag == 'board-games'" class='el:amx-Mb(0.625em)'>
      <a href='/forward/b7160488-1d75-11e9-981e-22000a9143a5' >
        <img src='images/garry-kasparov-masterclass.png' width='100%' />
      </a>
    </div>
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


