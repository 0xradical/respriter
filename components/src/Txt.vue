<script>
  export default {
    render(h) {
      return this._v(this.$slots.default[0].text.trim());
    }
  };
</script>
