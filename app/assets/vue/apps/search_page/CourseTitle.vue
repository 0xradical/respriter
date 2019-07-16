<template>
  <div class='el:m-text-clipbox' :class='rootClasses'>
    <a v-if='href' class='el:m-text-clipbox__text el:amx-Fw(b)' :class='titleClasses' :href='course.gateway_path' rel='nofollow' target='_blank' :title='course.name'>
      {{ course.name }}
    </a>
    <span v-else class='el:m-text-clipbox__text el:amx-Fw(b)' :class='titleClasses'>
      {{ course.name }}
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
    titleClasses: {
      type: Array,
      default() {
        return [];
      }
    },
    href: {
      type: Boolean,
      default: true
    }
  }
}
</script>

