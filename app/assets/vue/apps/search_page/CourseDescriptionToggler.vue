<template>
  <div v-if='course.description' class='el:amx-Bot_gray el:amx-Bob_gray' :class='rootClasses'>
    <div class='clspt:course-description' @click.prevent.stop="toggle">
      <div class='el:amx-D(f) el:amx-FxJc(sb)'>
        <a class='el:amx-C_blue'>{{ toggled ? $t('dictionary.description.hide') : $t('dictionary.description.show') }}</a>
        <div>
          <icon width='1rem' height='1rem' :transform='`rotate(${toggled ? 180 : 0}deg)`' name='arrow-down'></icon>
        </div>
      </div>
      <transition name="fade">
        <course-description :rootClasses="['el:amx-Pt(0.5em)']" v-show='toggled' :course="course"></course-description>
      </transition>
    </div>
  </div>
</template>

<script>
import Icon from '../../shared/Icon.vue';
import CourseDescription from '../../shared/CourseDescription.vue';

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
    }
  },
  methods: {
    toggle() {
      this.toggled = !this.toggled;
    },
  },
  components: {
    icon: Icon,
    courseDescription: CourseDescription
  }
}
</script>

<style lang="scss" scoped>
.fade-enter-active, .fade-leave-active {
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


