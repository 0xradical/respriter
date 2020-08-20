<template>
  <div class="el:m-attribute" :class="rootClasses">
    <svg :class="['el:m-attribute__icon', ...logoClasses]">
      <use :xlink:href="'#providers-' + logo" />
    </svg>
    <span class="el:m-attribute__label" :class="labelClasses">
      <span :class="nameClasses">
        {{ name }}
      </span>
    </span>
    <div
      class="po-r pL8"
      v-if="course.provider_featured_on_search"
      style="display: inline-flex; align-items: center; flex: 1; height: 1em;"
    >
      <span
        class="po-a tt-u c1 fw-b fs8 mL24 pL20"
        style="white-space: nowrap;"
      >
        {{ $t("dictionary.featured_provider") }}
      </span>
      <svg class="po-a" width="1em" height="1em">
        <use xlink:href="#icons-featured-badge" />
      </svg>
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
