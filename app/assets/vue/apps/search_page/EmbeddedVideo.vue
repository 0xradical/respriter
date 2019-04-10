<template>
  <div>
    <template v-if="mode == 'html5'">
      <video oncontextmenu='return false;' controls controlsList='nodownload' autoplay width='100%' height='auto'>
        <source :src="url" type='video/mp4'>
      </video>
    </template>
    <template v-else>
      <iframe width='100%' height='auto' :src="url" frameBorder=0 />
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
    mode: {
      type: String,
      required: false,
      default: 'html5'
    }
  }
}
</script>

