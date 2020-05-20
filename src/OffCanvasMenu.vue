<template>
  <div>
    <div :id='id' :class='["el:o-off-canvas-menu", left && "el:o-off-canvas-menu--left-positioned", ...rootClasses, $store.state.menu.open ? "el:o-off-canvas-menu--open" : ""]'>
      <slot></slot>
    </div>
    <div class='el:o-off-canvas-menu-mask' @click='$store.commit("menu/close")' :style="{'display': $store.state.menu.open ? 'block' : 'none' }"></div>
  </div>
</template>
<script>
  export default {
    props: {
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      left: {
        type: Boolean,
        default: false
      },
      id: {
        type: String,
        default: null
      }
    }
  }
</script>
