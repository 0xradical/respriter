<template>
  <div class="el:amx-Bc_su el:amx-Pos(r)">
    <alert v-if="alert" class-list="el:amx-Fs(0.75em)" v-bind="alert"></alert>
    <slot name="header"></slot>
    <div class="el:amx-Pos(r)">
      <div v-if="disabled" class="el:amx-Pos(a) overlay"></div>
      <div class="el:amx-Pt(2em) el:amx-Pb(2em) el:amx-Pl(2em) el:amx-Pr(2em)">
        <h3 class="el:amx-Fs(1.25em) el:amx-Fw(b) el:amx-C_fg el:amx-Lh(1)">
          <slot name="title"></slot>
        </h3>
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
import Alert from "./Alert.vue";
export default {
  components: {
    Alert
  },

  props: {
    alert: {
      type: Object,
      required: false,
      default() {
        return {};
      }
    },
    disabled: {
      type: Boolean,
      required: false,
      default: false
    }
  }
};
</script>

<style lang="scss" scoped>
.overlay {
  height: 100%;
  width: 100%;
  z-index: 1;
  background-color: rgba(255, 255, 255, 0.75);
}
</style>
