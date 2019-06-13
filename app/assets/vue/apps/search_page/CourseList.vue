<template>
  <div v-if="size">
    <div class='mx-Mb-0d625' v-for='course in firstHalf' :key="course.id">
      <course :course='course'></course>
    </div>
    <adsense root-class='mx-Mb-0d625 adswrapper'
             data-ad-client='ca-pub-7807822317367529'
             data-ad-slot='2861606178'
             data-ad-format='auto'
             :data-full-width-responsive='true'>
    </adsense>
    <div class='mx-Mb-0d625' v-for='course in secondHalf' :key="course.id">
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
    firstHalf() {
      return this.courses.slice(0, this.size / 2);
    },
    secondHalf() {
      return this.courses.slice(this.size / 2, this.size);
    },
    size() {
      return this.courses.length;
    }
  }
}
</script>

<style lang="scss" scoped>

</style>


