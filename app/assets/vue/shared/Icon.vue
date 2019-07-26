<template>
  <svg :class='iconClasses' :style='style' :width='width' :height='height' viewbox='0 0 24 24'>
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
    scope: {
      type: String,
      default: "icons"
    },
    width: {
      type: String,
      default: "1em"
    },
    height: {
      type: String,
      default: "1em"
    },
    transform: {
      type: String,
      default: 'initial'
    },

    cursor: {
      type: String,
      defaul: 'initial'
    },
    iconClasses: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  computed: {
    style() {
      return {
        'transform': this.transform,
        'transition': 'all .5s',
        'width': this.width,
        'height': this.height,
        'cursor': this.cursor
      }
    },
    path() {
      return `#${this.scope}-${this.name}`
    }
  }
}
</script>

