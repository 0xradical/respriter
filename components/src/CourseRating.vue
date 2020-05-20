<template>
  <div class='el:m-rating' :class='rootClasses'></div>
</template>

<script>
export default {
  props: {
    rootClasses: {
      type: Array,
      default() {
        return [];
      }
    }
  }
}
</script>

