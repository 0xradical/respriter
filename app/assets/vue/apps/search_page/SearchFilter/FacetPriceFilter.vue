<template>
  <vue-slider :value="value"
              @dragging='updateCurrentValues'
              @drag-end='emitChanges'
              :contained="true"
              tooltip='focus'
              :enable-cross='false'
              :min='0'
              :max='2500'
              :marks='marks'
              :dot-style='dotStyle'
              :lazy='true'>
  </vue-slider>
</template>

<script>
import VueSlider from 'vue-slider-component';

export default {
  components: {
    VueSlider
  },
  props: {
    dotSize: {
      type: String,
      default: '14px'
    },
    initialMin: {
      type: Number,
      default: 0
    },
    initialMax: {
      type: Number,
      default: 2500
    },
    marks: {
      type: Array,
      required: false,
      default() {
        return [0, 500, 1000, 1500, 2000, 2500]
      }
    }
  },
  data() {
    return {
      currentMin: this.initialMin,
      currentMax: this.initialMax
    }
  },
  watch: {
    'initialMin': function (nVal, oVal) {
      this.currentMin = nVal;
    },
    'initialMax': function (nVal, oVal) {
      this.currentMax = nVal;
    }
  },
  methods: {
    updateCurrentValues: function(params) {
      [this.currentMin, this.currentMax]   = params.map(parseFloat);
    },
    emitChanges: function() {
      this.$emit('priceValueChanged', [this.currentMin, this.currentMax]);
    }
  },
  computed: {
    dotStyle() {
      return {
        'width': this.dotSize,
        'height': this.dotSize
      }
    },
    value(){
      return [this.currentMin, this.currentMax];
    }
  }
}
</script>

<style lang="scss">
  @import '~elements/src/scss/config/variables.scss';
  @import '~elements/src/scss/config/functions.scss';

  $themeColor: color(blue);

  @import '~vue-slider-component/lib/theme/default.scss';

  .vue-slider-dot-handle {
    background-color: $themeColor;
  }
</style>

