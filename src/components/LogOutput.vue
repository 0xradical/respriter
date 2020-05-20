<template>
  <div class="el:m-log-output">
    <div
      v-for="(line, idx) in log"
      :key="idx"
      class="el:m-log-output__line"
      :class="lineClass(line.severity)"
    >
      {{ line.time }} {{ line.message.payload }}
    </div>
  </div>
</template>
<script>
export default {
  props: {
    lineNumbers: {
      type: Boolean,
      default: false
    },

    log: {
      type: Array,
      default() {
        return [];
      }
    }
  },

  data() {
    return {};
  },

  computed: {
    lnPadSize() {
      return this.log.length.toString().split("").length;
    }
  },

  methods: {
    lineClass(level) {
      return {
        "el:m-log-output__line--error": ["error", "alert", "emerg", "crit"].includes(level),
        "el:m-log-output__line--warning": ["warn"].includes(level)
      };
    },

    lineNumber(idx) {
      let currentLn = idx.toString().split("");
      for (var i = currentLn.length; i < this.lnPadSize; i++) {
        currentLn.unshift(" ");
      }
      return currentLn.join("");
    }
  }
};
</script>
