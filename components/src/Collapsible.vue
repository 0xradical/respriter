<template>
  <div :class='["el:m-collapsible", ...rootClasses, ...collapseClasses]' @click='expanded = !expanded'>
    <div class='el:m-collapsible__visible-content'>
      <slot name='visible'></slot>
    </div>
    <div class='el:m-collapsible__hidden-content' v-if='!fixed'>
      <slot name='hidden'></slot>
    </div>
  </div>
</template>
<script>
  export default {
    props: {
      fixed: {
        type: Boolean,
        default: false
      },
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      }
    },
    computed: {
      collapseClasses() {
        if(this.fixed) {
          return ["el:m-collapsible--fixed"];
        } else if(this.expanded) {
          return ["el:m-collapsible--expanded"];
        } else {
          return [];
        }
      }
    },
    data() {
      return {
        expanded: false
      }
    }
  }
</script>
