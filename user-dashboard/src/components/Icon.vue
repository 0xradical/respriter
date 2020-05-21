<template>
  <inline-svg
    :src="require(`../assets/${name}.svg`)"
    :class="[`el:amx-C_${color}`]"
    :aria-label="name"
  ></inline-svg>
</template>

<script>
import InlineSvg from "vue-inline-svg";

export default {
  props: {
    name: {
      type: String,
      required: true
    },
    color: {
      type: String,
      required: false,
      default: "fg"
    }
  },
  components: {
    InlineSvg
  }
};
</script>
