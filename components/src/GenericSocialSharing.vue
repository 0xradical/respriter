<template>
  <component
    :is="cpt"
    :url="url"
    :title="title"
    :description="description"
    :quote="quote"
    :hashtags="hashtags"
    twitter-user="classpert"
    :callOut="callOut"
    :callOutClasses="callOutClasses"
    :iconClasses="iconClasses"
    :rootClasses="rootClasses"
    :left="left"
    :linkText="linkText"
    :copiedText="copiedText"
  >
  </component>
</template>

<script>
  import SocialSharing from "./SocialSharing.vue";
  import SocialSharing2 from "./SocialSharing2.vue";

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
        required: false,
        default: ""
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
      callOut: {
        type: String,
        default: undefined
      },
      callOutClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      version: {
        type: String,
        default: ""
      },
      left: {
        type: Boolean,
        default: false
      },
      linkText: {
        type: String,
        required: true
      },
      copiedText: {
        type: String,
        required: true
      }
    },
    computed: {
      cpt() {
        return "social-sharing" + this.version;
      }
    },
    components: {
      "social-sharing": SocialSharing,
      "social-sharing2": SocialSharing2
    }
  };
</script>
