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
    <div
      class="el:amx-Pos(r) el:amx-Pl(0.5em)"
      v-if="course.from_index_tool"
      style="display: inline-flex; align-items: center; flex: 1; height: 1em;"
    >
      <span
        class="el:amx-Pos(a) el:amx-Tt(u) el:amx-C_pr el:amx-Fw(b) el:amx-Fs(0.375em) el:amx-Ml(1.625em) el:amx-Pl(1.375em)"
        style="white-space: nowrap;"
      >
        {{ $t("dictionary.featured_provider") }}
      </span>
      <svg class="el:amx-Pos(a)" width="1em" height="1em">
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
