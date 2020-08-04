<template>
  <component :is="cpt" :post="post" />
</template>

<script>
  import PostCard from "components/PostCard.vue";
  import PostCardV2 from "components/PostCardV2.vue";

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
      },
      version: {
        type: String,
        default: undefined
      }
    },
    computed: {
      cpt() {
        return "PostCard" + (this.version ? `V${this.version}` : "");
      }
    },
    components: {
      PostCard,
      PostCardV2
    }
  };
</script>
