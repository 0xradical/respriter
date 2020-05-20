<template>
  <div class="sidebar el:amx-Bc_su d-none d-md-block">
    <SidebarLinks :depth="0" :items="items" />
  </div>
</template>

<script>
import SidebarLinks from "~components/SidebarLinks.vue";

export default {
  props: {
    items: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  components: { SidebarLinks }
};
</script>

<style lang="scss">
@import "../styles/variables";

.sidebar {
  display: block;
  position: fixed;
  z-index: 10;
  box-sizing: border-box;
  border-right: 1px solid #d9d9e0;
  left: 0;
  height: 100%;
  padding: 2em 0;
  overflow-x: hidden;
  overflow-y: auto;
  width: $sidebar-width;
}
</style>
