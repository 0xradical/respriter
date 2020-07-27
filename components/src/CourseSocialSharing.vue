<template>
  <generic-social-sharing
    :version="version"
    :url="courseUrl"
    :title="title"
    :quote="quote"
    :hashtags="hashtags"
    :callOut="callOut"
    :callOutClasses="callOutClasses"
    :iconClasses="iconClasses"
    :rootClasses="rootClasses"
    :left="left"
    :linkText="linkText"
    :copiedText="copiedText"
  >
  </generic-social-sharing>
</template>

<script>
  import GenericSocialSharing from "./GenericSocialSharing.vue";

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
      },
      callOut: {
        type: String,
        default: undefined
      },
      version: {
        type: String,
        version: ""
      },
      left: {
        type: Boolean,
        default: false
      },
      url: {
        type: String,
        required: false
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
    components: {
      GenericSocialSharing
    },
    computed: {
      courseUrl() {
        return this.url || this.course.url;
      },
      title() {
        return this.course.name;
      },
      quote() {
        return this.course.name;
      },
      hashtags() {
        if (this.course.curated_tags && this.course.curated_tags.length) {
          return this.course.curated_tags.join(", ");
        } else {
          return this.course.name.split(/\s+/).slice(0, 2).join(", ");
        }
      }
    }
  };
</script>
