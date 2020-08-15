<template>
  <div
    class="el:m-video-preview"
    :class="[
      ...rootClasses,
      videoComponent && 'el:m-video-preview--loaded',
      videoClicked && 'el:m-video-preview--clicked',
      videoExists
        ? 'el:m-video-preview--available'
        : 'el:m-video-preview--unavailable'
    ]"
  >
    <!-- video available -->
    <template v-if="videoExists">
      <div
        class="el:m-video-preview__wrapper el:m-video-preview__wrapper--static"
        @click="fetchVideo"
      >
        <div
          class="el:m-video-preview__background lazyload"
          :data-bg="this.video && this.video.thumbnail_url"
        ></div>
        <div class="el:m-video-preview__mask"></div>
        <div class="el:m-video-preview__content">
          <icon
            :iconClasses="['el:m-video-preview__icon']"
            name="play"
            width="50%"
            height="50%"
            transform="translate(0%, 50%)"
          ></icon>
        </div>
      </div>
      <component
        :is="videoComponent"
        :url="videoUrl"
        :embed="videoEmbed"
        class="el:m-video-preview__wrapper"
        :videoClasses="['el:m-video-preview__content']"
      ></component>
    </template>

    <!-- video unavailable -->
    <template v-else>
      <div class="el:m-video-preview__wrapper">
        <div class="el:m-video-preview__background"></div>
        <div class="el:m-video-preview__mask"></div>
        <div class="el:m-video-preview__content">
          <icon
            :iconClasses="['el:m-video-preview__icon']"
            name="video-recorder-unavailable"
            width="25%"
            height="25%"
            transform="translate(0%, 150%)"
            cursor="inherit"
          ></icon>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
  import videoService from "~~video-service";
  import Icon from "./Icon.vue";
  import EmbeddedVideo from "./EmbeddedVideo.vue";

  export default {
    data() {
      return {
        videoComponent: null,
        videoClicked: false,
        videoUrl: "",
        videoEmbed: "",
        videoMobileUx: false,
        videoLoaded: false
      };
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
      courseType() {
        return this.course.type || "Course";
      },
      videoExists() {
        return (
          this.video &&
          (this.video.url ||
            ((this.video.type === "youtube" || this.video.type === "vimeo") &&
              this.video.id) ||
            (this.video.type === "video_service" && this.video.path))
        );
      },
      style() {
        const backgroundImage = this.video && this.video.thumbnail_url;

        if (backgroundImage) {
          return {
            "background-image": `url(${backgroundImage})`
          };
        } else {
          return {};
        }
      }
    },
    methods: {
      fetchVideo: function () {
        this.videoClicked = true;

        if (!this.videoLoaded) {
          videoService(this.course.id, this.courseType).then(response => {
            response.json().then(json => {
              this.videoUrl = json.url;
              this.videoEmbed = json.embed;
              this.videoComponent = "embedded-video";
              this.videoLoaded = true;
            });
          });
        }
      }
    }
  };
</script>
