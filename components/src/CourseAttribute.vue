<template>
  <div class="el:m-attribute" :class="rootClasses">
    <svg :class="['el:m-attribute__icon', ...iconClasses]">
      <use :xlink:href="'#icons-' + icon" />
    </svg>
    <span class="el:m-attribute__label" :class="labelClasses">
      <span :class="valueClasses">
        <slot></slot>
      </span>
    </span>
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
      iconClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      labelClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      valueClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      icon: {
        type: String
      }
    }
  };
</script>
