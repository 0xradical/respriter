<template>
  <social-sharing
      :url="url"
      :title="title"
      :description="description"
      :quote="quote"
      :hashtags="hashtags"
      twitter-user="classpert"
      :callOutClasses='callOutClasses'
      :iconClasses='iconClasses'
      :rootClasses='rootClasses'
      >
  </social-sharing>
</template>

<script>
import SocialSharing from './SocialSharing.vue';

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
    socialSharing: SocialSharing
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
      return "some quote";
    },
    hashtags() {
      return this.course.tags.map((tag) => `#${tag}`).join(', ');
    }
  }
}
</script>
