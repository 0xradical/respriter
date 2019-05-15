<template>
  <svg :style='style'>
    <use :xlink:href='path' />
  </svg>
</template>

<script>
export default {
  props: {
    name: {
      type: String,
      required: true
    },
    width: {
      type: String,
      default: '1em'
    },
    height: {
      type: String,
      default: '1em'
    },
    transform: {
      type: String,
      default: 'initial'
    }
  },
  computed: {
    style() {
      return {
        'transform': this.transform,
        'width': this.width,
        'height': this.height
      }
    },
    path() {
      return `${window.iconsLibPath}#${this.name}`
    }
  }
}
</script>

