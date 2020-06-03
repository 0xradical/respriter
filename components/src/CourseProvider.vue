<template>
  <div class="el:m-attribute" :class="rootClasses">
    <svg
      :class="[
        'el:m-attribute__icon el:m-attribute__icon--bordered',
        ...logoClasses
      ]"
    >
      <use :xlink:href="'#providers-' + logo" />
    </svg>
    <span class="el:m-attribute__label" :class="labelClasses">
      <span :class="nameClasses">
        {{ name }}
      </span>
    </span>
  </div>
</template>

<script>
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
      labelClasses: {
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
    }
  };
</script>
