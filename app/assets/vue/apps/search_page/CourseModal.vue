<template>
  <modal :adaptive='true' width='90%' :max-width='600' height='428px' name='course-modal' @before-open='injectData'>
    <div v-if='course.video_url' class='video-container'>
      <iframe style='border:0px' width="853" height="480" :src="videoUrl" frameborder="0" allowfullscreen></iframe>
    </div>
    <h5 style="text-align: center;padding: 15px 0px;">{{ course.name }}</h5>
    <p class='course-description' v-html='course.description'></p>
  </modal>
</template>

<script>
export default {

  data () {
    return {
      course: {
        video_url: '',
        provider: {}
      }
    }
  },

  computed: {
    videoUrl () {
      if (this.course.provider_slug == 'coursera' && this.course.video_url)  {
        return `${this.course.video_url}full/540p/index.mp4`
      }
      var match = this.course.video_url.match(/.*\/(?:watch\?v=)?(.*)$/)
      if (match) {
        return `//www.youtube.com/embed/${match[1]}`
      } else {
        return ''
      }
    }
  },

  methods: {
    injectData (event) {
      this.course = event.params.course
    }
  }

}
</script>

<style>

.course-description  {
overflow-y: scroll;
    height: 150px;
    text-align: justify;
    padding: 0px 10px;
    margin-top: 0px;
}

.video-container {
position: relative;
overflow: hidden;
height: 215px;
}

.video-container iframe,
.video-container object,
.video-container embed {
position: absolute;
top: 0;
left: 0;
width: 100%;
height: 100%;
max-height: 215px;
}
</style>
