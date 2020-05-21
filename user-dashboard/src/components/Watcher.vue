<template>
  <span v-show="false"></span>
</template>

<script>
export default {
  props: ["watched"],
  watch: {
    watched: {
      immediate: true,
      handler() {
        this.$emit("changed", this.watched);
      }
    }
  }
};
</script>
