<template>
  <div>
    <slot></slot>
  </div>
</template>

<script>
export default {
  render() {
    return this.$slots.default;
  }
};
</script>
