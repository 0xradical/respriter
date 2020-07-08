<template>
  <search-page :tag="tag" :locale="locale" :provider="provider"></search-page>
</template>

<script>
  // this is to allow SSR to pick up
  // root component styles as well
  import SearchPage from "./SearchPage.vue";

  export default {
    props: {
      tag: {
        type: String,
        default: undefined
      },
      locale: {
        type: String,
        required: false,
        default: "en"
      },
      provider: {
        type: String,
        default: undefined
      }
    },
    components: {
      SearchPage
    }
  };
</script>
