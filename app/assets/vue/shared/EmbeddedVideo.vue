<template>
  <div>
    <template v-if="!embed">
      <video :class='videoClasses' oncontextmenu='return false;' controls controlsList='nodownload' autoplay="true" width='100%' height='100%'>
        <source :src="videoUrl" type='video/mp4'>
      </video>
    </template>
    <template v-else>
      <iframe :class='videoClasses' width='100%' height='100%' :src="videoUrl" frameBorder=0 />
    </template>
  </div>
</template>

<script>
export default {
  props: {
    url: {
      type: String,
      required: true,
      default: ''
    },
    embed: {
      type: Boolean,
      required: false,
      default: false
    },
    autoplay: {
      type: Boolean,
      required: false,
      default: false
    },
    videoClasses: {
      type: Array,
      default() {
        return [];
      }
    }
  },

  computed: {
    videoUrl() {
      if(this.autoplay && this.embed) {
        return this.url + (this.url.indexOf('?') < 0 ? '?' : '&') + 'autoplay=true';
      } else {
        return this.url;
      }
    }
  }
}
</script>
