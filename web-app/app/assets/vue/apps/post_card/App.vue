<template>
  <post-card :post="post"> </post-card>
</template>

<script>
  import PostCard from "components/PostCard.vue";

  export default {
    props: {
      post: {
        type: Object,
        required: true
      },
      locale: {
        type: String,
        required: false,
        default: "en"
      }
    },
    components: {
      PostCard
    }
  };
</script>
