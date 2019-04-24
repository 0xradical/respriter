<template>
  <vue-slider :value="value"
              @input='[previousMin, previousMax] = [currentMin, currentMax]; [currentMin, currentMax] = $event.map(parseFloat)'
              @change='emitChanges'
              :contained="true"
              tooltip='none'
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
    currentMin: {
      type: Number,
      default: 0
    },
    currentMax: {
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
      previousMin: this.currentMin,
      previousMax: this.currentMax,
    }
  },
  methods: {
    emitChanges: function([ minVal, maxVal ]) {
      if (minVal !== this.previousMin) {
        this.$emit('priceLowerValueChanged', minVal);
      }
      if (maxVal !== this.previousMax) {
        this.$emit('priceUpperValueChanged', maxVal);
      }
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

