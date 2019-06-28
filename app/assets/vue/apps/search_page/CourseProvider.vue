<template>
  <div class='clspt:course-provider c-label' :class='rootClasses'>
    <icon class='c-label__icon c-label__icon--circled-border clspt:course-provider__logo' :class='logoClasses' scope="providers" :name="logo"></icon>
    <span class='c-label__text'>
      <span class='c-tags c-tags--gray' :class='nameClasses'>
        {{ name }}
      </span>
    </span>
  </div>
</template>

<script>
import Icon from './Icon.vue';

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
    logoClasses: {
      type: Array,
      default() {
        return [];
      }
    },
    nameClasses: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  computed: {
    name() {
      return this.course.provider_name;
    },
    logo() {
      return this.course.provider_slug;
    }
  },
  components: {
    icon: Icon
  }
}
</script>

<style lang="scss" scoped>
.clspt\:course-provider {
  box-sizing: border-box;

  &__logo {
    padding: 0;
  }
}
</style>


