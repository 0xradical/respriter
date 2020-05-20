<template>
  <transition name="slide">
    <router-view></router-view>
  </transition>
</template>

<script>
export default {
  name: "app",

  data() {
    return {};
  },

  created() {}
};
</script>

<style lang="scss">
html {
  box-sizing: border-box;
  -ms-overflow-style: scrollbar;
}

*,
*::before,
*::after {
  box-sizing: inherit;
}

@import "~bootstrap/scss/functions";
@import "~bootstrap/scss/variables";
@import "~bootstrap/scss/mixins/breakpoints";
@import "~bootstrap/scss/mixins/grid-framework";
@import "~bootstrap/scss/mixins/grid";
@import "~bootstrap/scss/mixins/hover";
@import "~bootstrap/scss/mixins/border-radius";
@import "~bootstrap/scss/utilities/sizing";
@import "~bootstrap/scss/utilities/spacing";
@import "~bootstrap/scss/utilities/flex";
@import "~bootstrap/scss/utilities/display";
@import "~bootstrap/scss/grid";
@import "~bootstrap/scss/nav";

.text-decoration-underline {
  text-decoration: underline !important;
}
</style>
