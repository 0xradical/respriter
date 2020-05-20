<template>
  <transition name="el:o-modal">
    <div class="el:o-modal__mask" @click.self="$emit('close', name)">
      <div :class="['el:o-modal__wrapper', wrapperClasses]" @click.self="$emit('close', name)">
        <div :class="['el:o-modal__container', containerClasses]">
          <div class='el:o-modal__close' aria-label="Close" @click.self="$emit('close', name)"></div>

          <div :class="['el:o-modal__header', headerClasses]">
            <slot name="header"></slot>
          </div>

          <div :class="['el:o-modal__body', bodyClasses]">
            <slot name="body"></slot>
          </div>

          <div :class="['el:o-modal__footer', footerClasses]">
            <slot name="footer"></slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
  export default {
    props: {
      name: {
        type: String,
        required: true
      },
      wrapperClasses: {
        type: Array,
        required: false,
        default() {
          return []
        }
      },
      containerClasses: {
        type: Array,
        required: false,
        default() {
          return []
        }
      },
      headerClasses: {
        type: Array,
        required: false,
        default() {
          return []
        }
      },
      bodyClasses: {
        type: Array,
        required: false,
        default() {
          return []
        }
      },
      footerClasses: {
        type: Array,
        required: false,
        default() {
          return []
        }
      }
    },
    created() {
      document.addEventListener('keyup', (event) => {
        // esc
        if (event.keyCode === 27) {
          this.$emit('close', this.name);
        }
      });
    },
  }
</script>
