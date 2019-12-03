<template>
  <search-page></search-page>
</template>

<script>
// this is to allow SSR to pick up
// root component styles as well
import SearchPage from "./SearchPage.vue";

export default {
  components: {
    SearchPage
  }
};
</script>
