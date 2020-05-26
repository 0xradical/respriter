<template>
  <generic-social-sharing
    :url="options.url"
    :title="options.title"
    :description="options.description"
    :quote="options.quote"
    :hashtags="options.hashtags"
    :callOutClasses="options.callOutClasses"
    :iconClasses="options.iconClasses"
    :rootClasses="options.rootClasses"
  >
  </generic-social-sharing>
</template>

<script>
  import GenericSocialSharing from "components/GenericSocialSharing.vue";

  export default {
    name: "Sharing",
    props: {
      options: {
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
      GenericSocialSharing
    }
  };
</script>
