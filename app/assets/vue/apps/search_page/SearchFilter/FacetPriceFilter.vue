<template>
  <div class='facet-price-filter' :class='`facet-price-filter--${this.size}`'>
    <vue-slider :value="value"
                @dragging='updateCurrentValues'
                @drag-start='dragStart'
                @drag-end='dragEnd'
                @change='onChange'
                :contained="true"
                tooltip='focus'
                :enable-cross='false'
                :min='0'
                :max='2500'
                :marks='marks'
                :lazy='true'>
    </vue-slider>
  </div>
</template>

<script>
import VueSlider from 'vue-slider-component';

export default {
  components: {
    VueSlider
  },
  props: {
    size: {
      type: String,
      default: 'normal'
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
      isDragging: false,
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
      [this.currentMin, this.currentMax] = params.map(parseFloat);
    },
    dragStart: function() {
      this.isDragging = true;
    },
    dragEnd: function() {
      this.isDragging = false;
      this.emitChanges();
    },
    onChange: function(params) {
      let [nMin, nMax] = params.map(parseFloat);

      if(nMin !== this.currentMin || nMax !== this.currentMax) {
        [this.currentMin, this.currentMax] = [nMin, nMax];
        this.emitChanges();
      }
    },
    emitChanges: function() {
      this.$emit('priceValueChanged', [this.currentMin, this.currentMax]);
    }
  },
  computed: {
    value(){
      return [this.currentMin, this.currentMax];
    }
  }
}
</script>

<style lang="scss">
  @import '~elements/src/scss/config/variables.scss';
  @import '~elements/src/scss/config/functions.scss';

  $themeColor: get-color("blue2");

  @import '~vue-slider-component/lib/theme/default.scss';

  .vue-slider-dot-handle {
    background-color: $themeColor;
  }

  .facet-price-filter {
    .vue-slider {
      .vue-slider-rail {
        height: 4px;

        .vue-slider-marks {
          .vue-slider-mark-active {
            height: 4px;
          }
        }

        .vue-slider-dot {
          width: 14px !important;
          height: 14px !important;

          .vue-slider-dot-handle {
            width: 14px;
            height: 14px;
          }
        }
      }
    }
  }

  .facet-price-filter {
    &--big {
      padding-left: 30px;
      padding-right: 30px;

      .vue-slider {
        .vue-slider-rail {
          height: 6px;

          .vue-slider-marks {
            .vue-slider-mark, .vue-slider-mark-active {
              height: 6px !important;
              width: 6px !important;
            }
          }

          .vue-slider-dot {
            padding-top: 20px;
            width: 60px !important;
            height: 40px !important;

            .vue-slider-dot-handle {
              margin: 0 auto;
              width: 20px;
              height: 20px;
            }
          }
        }
      }
    }
  }
</style>

