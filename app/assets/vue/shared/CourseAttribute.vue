<template>
  <div class='clspt:course-attribute c-label' :class='rootClasses'>
    <icon :iconClasses="[...iconClassesBase, ...iconClasses]" :name="icon"></icon>
    <span class='clspt:course-attribute__label c-label__text'>
      <span class='c-tags c-tags--gray3' :class='valueClasses'>
        <slot></slot>
      </span>
    </span>
  </div>
</template>

<script>
import Icon from './Icon.vue';

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
    valueClasses: {
      type: Array,
      default() {
        return [];
      }
    },
    icon: {
      type: String
    }
  },
  components: {
    icon: Icon
  },
  computed: {
    iconClassesBase() {
      return ['c-label__icon', 'clspt:course-attribute__icon',`clspt:course-attribute__icon--${this.icon}`];
    }
  }
}
</script>

<style lang="scss">
.clspt\:course-attribute {
  box-sizing: border-box;

  &__icon {
    position: relative;

    &--clock {
      top: -1;
    }
  }

  &__label {
    max-height: 1em;
    overflow: hidden;
    max-width: 90%;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
}
</style>


