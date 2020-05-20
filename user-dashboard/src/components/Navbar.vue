<template>
  <div
    class="el:o-navbar el:amx-Bc_su"
    role="header-nav"
    :class="containerClassList"
  >
    <div v-if="brand" class="el:o-navbar__slot" :class="brandClassList">
      <slot name="brand"></slot>
    </div>

    <div v-for="(v, k) in slots" class="el:o-navbar__slot" :class="v" :key="k">
      <slot :name="`${k}`"></slot>
    </div>

    <div
      v-if="offCanvasButton"
      class="el:o-navbar__slot"
      :class="offCanvasClassList"
    >
      <a
        @click="$store.commit('menu/open')"
        class="el:o-navbar__offcanvas-button"
      ></a>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    containerClassList: {
      type: String,
      required: false,
      default: ""
    },

    brand: {
      type: Boolean,
      required: false,
      default: true
    },

    brandClassList: {
      type: String,
      required: false,
      default: ""
    },

    offCanvasButton: {
      type: Boolean,
      required: false,
      default: true
    },

    offCanvasClassList: {
      type: String,
      required: false,
      default: ""
    },

    slots: {
      type: Object,
      required: true
    }
  },

  data() {
    return {};
  }
};
</script>
