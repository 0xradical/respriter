<template>
  <div
    v-if="course.description"
    class="bdT bdB"
    :class="rootClasses"
  >
    <div class="clspt:course-description" @click.prevent.stop="toggle">
      <div class="d-f jc-sb">
        <a class="c1">{{
          toggled
            ? $t("dictionary.description.hide")
            : $t("dictionary.description.show")
        }}</a>
        <div>
          <icon
            width="1rem"
            height="1rem"
            :transform="`rotate(${toggled ? 180 : 0}deg)`"
            name="arrow-down"
            class="c1"
          ></icon>
        </div>
      </div>
      <transition name="fade">
        <course-description
          :rootClasses="['pT8']"
          v-show="toggled"
          :course="course"
        ></course-description>
      </transition>
    </div>
  </div>
</template>

<script>
  import Icon from "./Icon.vue";
  import CourseDescription from "./CourseDescription.vue";

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
      }
    },
    data() {
      return {
        toggled: false
      };
    },
    methods: {
      toggle() {
        this.toggled = !this.toggled;
      }
    },
    components: {
      icon: Icon,
      courseDescription: CourseDescription
    }
  };
</script>

<style lang="scss" scoped>
  .fade-enter-active,
  .fade-leave-active {
    transition: all 5s;
  }
  .fade-enter {
    position: absolute;
    visibility: hidden;
    display: block;
    height: auto;
  }

  .fade-leave-to {
    position: relative;
    visibility: visible;
    display: none;
    height: 0;
  }
</style>
