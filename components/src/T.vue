<script>
  export default {
    props: {
      k: {
        type: String,
        required: true
      },
      options: {
        type: Object,
        default() {
          return {};
        }
      }
    },
    render(h) {
      return this._v(this.$t(this.k, this.options));
    }
  };
</script>
