<template>
  <video-preview
    :course="course"
    :root-classes="rootClasses"
    :lazyLoaded="lazyLoaded"
  >
  </video-preview>
</template>

<script>
  import VideoPreview from "components/VideoPreview.vue";

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
      lazyLoaded: {
        type: Boolean,
        default: true
      }
    },
    components: {
      VideoPreview
    }
  };
</script>
