<template>
  <div>
    <template v-if="!embed">
      <video oncontextmenu='return false;' controls controlsList='nodownload' autoplay width='100%' height='100%'>
        <source :src="url" type='video/mp4'>
      </video>
    </template>
    <template v-else>
      <iframe width='100%' height='100%' :src="url" frameBorder=0 />
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
    }
  }
}
</script>

