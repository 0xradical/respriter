<template>
  <div v-show="open" class="el:m-alert" :class="alertClass">
    <slot>{{ message }}</slot>
  </div>
</template>

<script>
export default {
  props: {
    message: {
      type: String,
      required: true,
      default: ""
    },

    type: {
      type: String,
      required: true
    },

    classList: {
      type: String,
      required: false
    }
  },

  data() {
    return {
      open: true
    };
  },

  computed: {
    alertClass() {
      var typeClass;
      switch (this.type) {
        case "primary":
          typeClass = "el:m-alert--primary";
          break;
        case "success":
          typeClass = "el:m-alert--primary-variant";
          break;
        case "warning":
          typeClass = "el:m-alert--secondary";
          break;
        case "danger":
          typeClass = "el:m-alert--error";
          break;
        default:
          typeClass = "";
      }
      return `${typeClass} ${this.classList}`;
    }
  },

  methods: {
    close() {}
  }
};
</script>
