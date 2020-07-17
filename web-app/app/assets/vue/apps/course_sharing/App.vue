<template>
  <course-social-sharing
    :version="version"
    :course="course"
    :callOut="callOut"
    :rootClasses="rootClasses"
    :left="left"
    :url="url"
    :linkText="linkText"
    :copiedText="copiedText"
  />
</template>

<script>
  import CourseSocialSharing from "components/CourseSocialSharing.vue";

  export default {
    name: "Sharing",
    props: {
      course: {
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
        default: ""
      },
      callOut: {
        type: String,
        default: undefined
      },
      linkText: {
        type: String,
        required: true
      },
      copiedText: {
        type: String,
        required: true
      },
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      left: {
        type: Boolean,
        default: false
      },
      url: {
        type: String,
        required: false
      }
    },
    components: {
      CourseSocialSharing
    }
  };
</script>
