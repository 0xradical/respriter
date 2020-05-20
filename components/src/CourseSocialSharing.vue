<template>
  <generic-social-sharing
    :url="url"
    :title="title"
    :description="description"
    :quote="quote"
    :hashtags="hashtags"
    :callOutClasses="callOutClasses"
    :iconClasses="iconClasses"
    :rootClasses="rootClasses"
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
      }
    },
    components: {
      GenericSocialSharing
    },
    computed: {
      url() {
        return this.course.url;
      },
      title() {
        return this.course.name;
      },
      description() {
        return this.course.description;
      },
      quote() {
        return this.course.name;
      },
      hashtags() {
        if (this.course.curated_tags && this.course.curated_tags.length) {
          return this.course.curated_tags.join(", ");
        } else {
          return this.course.name
            .split(/\s+/)
            .slice(0, 2)
            .join(", ");
        }
      }
    }
  };
</script>
