<template>
  <search-page :tag="tag" :locale="locale"></search-page>
</template>

<script>
// this is to allow SSR to pick up
// root component styles as well
import SearchPage from "./SearchPage.vue";

export default {
  props: {
    tag: {
      type: String,
      default: null
    },
    locale: {
      type: String,
      required: false,
      default: "en"
    }
  },
  components: {
    SearchPage
  }
};
</script>
