<template>
  <social-sharing
    :url="url"
    :title="title"
    :description="description"
    :quote="quote"
    :hashtags="hashtags"
    twitter-user="classpert"
    :callOutClasses="callOutClasses"
    :iconClasses="iconClasses"
    :rootClasses="rootClasses"
  >
  </social-sharing>
</template>

<script>
  import SocialSharing from "./SocialSharing.vue";

  export default {
    props: {
      url: {
        type: String,
        required: false
      },
      title: {
        type: String,
        required: false
      },
      description: {
        type: String,
        required: false
      },
      quote: {
        type: String,
        required: false
      },
      hashtags: {
        type: String,
        required: false
      },
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      iconClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      callOutClasses: {
        type: Array,
        default() {
          return [];
        }
      }
    },
    components: {
      socialSharing: SocialSharing
    }
  };
</script>
