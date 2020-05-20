<template>
  <div class="clspt:course-provider el:m-label" :class="rootClasses">
    <icon
      class="el:m-label__icon el:m-label__icon--circled-border clspt:course-provider__logo"
      :class="logoClasses"
      scope="providers"
      :name="logo"
    ></icon>
    <span class="el:m-label__text">
      <span :class="nameClasses">
        {{ name }}
      </span>
    </span>
  </div>
</template>

<script>
  import Icon from "./Icon.vue";

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
  };
</script>

<style lang="scss">
  .clspt\:course-provider {
    box-sizing: border-box;

    &__logo {
      padding: 0;
    }
  }
</style>
