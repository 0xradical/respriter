<template>
  <div class='el:m-video-preview' :class="[...rootClassesBase, ...rootClasses]">
    <!-- video available -->
    <template v-if="videoExists">
      <div class='el:m-video-preview__wrapper' :class="{ 'el:amx-D(n)': videoComponent }" @click="fetchVideo">
        <div class='el:m-video-preview__background' :style='style'></div>
        <div class='el:m-video-preview__mask'></div>
        <div class='el:m-video-preview__content' :class="{'el:amx-D(n)': videoClicked}">
          <icon :iconClasses="['el:m-video-preview__icon el:amx-C_white']" name='play' width="50%" height="50%" transform="translate(0%, 50%)"></icon>
        </div>
      </div>
      <component :is="videoComponent" :url="videoUrl" :embed="videoEmbed" class='el:m-video-preview__wrapper' :videoClasses="['el:m-video-preview__content']"></component>
    </template>

    <!-- video unavailable -->
    <template v-else>
      <div class='el:m-video-preview__wrapper el:amx-Bc_gray clspt:m-video-preview--unavailable__wrapper'>
        <div class='el:m-video-preview__background'></div>
        <div class='el:m-video-preview__mask el:amx-Bc_dark-gray'></div>
        <div class='el:m-video-preview__content'>
          <icon :iconClasses="['el:m-video-preview__icon el:amx-C_white']" name='no-video' width="50%" height="50%" transform="translate(0%, 50%)" cursor="inherit"></icon>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import Icon from './Icon.vue';
import EmbeddedVideo from './EmbeddedVideo.vue';

export default {
  data() {
    return {
      videoComponent: null,
      videoClicked: false,
      videoUrl: '',
      videoEmbed: '',
      videoMobileUx: false,
      videoLoaded: false
    }
  },
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
    }
  },
  components: {
    icon: Icon,
    embeddedVideo: EmbeddedVideo
  },
  computed: {
    video() {
      return this.course.video;
    },
    videoExists() {
      return this.video && (this.video.url || (this.video.type === "youtube" && this.video.id));
    },
    style() {
      const backgroundImage = this.video && this.video.thumbnail_url;

      if(backgroundImage) {
        return {
          'background-image': `url(${backgroundImage})`
        }
      } else {
        return {};
      }
    },
    rootClassesBase() {
      let base = [];

      if (this.video) {
        base.push('clspt:m-video-preview--available');
      } else {
        base.push('clspt:m-video-preview--unavailable el:amx-Bc_dark-gray');
      }

      return base;
    }
  },
  methods: {
    fetchVideo: function() {
      this.videoClicked = true;

      if(!this.videoLoaded) {
        fetch(`/videos/${this.course.id}`).then((response) => {
          response.json().then((json) => {
            this.videoUrl        = json.url;
            this.videoEmbed      = json.embed;
            this.videoComponent  = "embedded-video";
            this.videoLoaded     = true
          })
        });
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.clspt\:m-video-preview {
  &--available {
    cursor: pointer;
  }
}
</style>
