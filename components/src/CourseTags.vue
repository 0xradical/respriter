<template>
  <div
    :class="rootClasses"
    v-if="course.curated_tags && course.curated_tags.length > 0"
  >
    <a
      :href="`/${tag.replace(/_/g, '-')}`"
      v-for="tag in course.curated_tags"
      :class="[...tagBaseClasses, ...tagClasses]"
      :key="tag"
      v-html="$t(`tags.${tag}`)"
    >
    </a>
  </div>
</template>

<script>
  export default {
    props: {
      course: {
        type: Object,
        required: true
      },
      color: {
        type: String,
        default: "primary-variant"
      },
      rootClasses: {
        type: Array,
        defaut() {
          return [];
        }
      },
      tagClasses: {
        type: Array,
        default() {
          return [];
        }
      }
    },
    computed: {
      tagBaseClasses() {
        return ["el:m-tag", `el:m-tag--${this.color}-flat`, "d-ib", "fs8"];
      }
    }
  };
</script>
<style lang="scss" scoped>
  a:hover {
    color: #ffffff;
  }
</style>
