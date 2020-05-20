<template>
  <div class="el:amx-Bc_su wizard col-12">
    <ul class="wizard__nav el:m-list el:m-list--unstyled el:amx-Pt(2em)">
      <li
        v-for="step in numOfSteps"
        :key="step"
        :class="[
          'wizard__nav-item',
          step === numOfSteps ? 'wizard__nav-item--last' : '',
          step === 1 ? 'wizard__nav-item--first' : '',
          step === currentStep ? 'wizard__nav-item--current' : '',
          step !== currentStep && step <= currentStep
            ? 'wizard__nav-item--completed'
            : ''
        ]"
        :style="{ flex: `0 0 calc(100% / ${numOfSteps})` }"
      >
        <div class="wizard__nav-item-icon">
          <svg
            class="el:amx-Fi_pr"
            width=".875em"
            height=".875em"
            viewbox="0 0 24 24"
          >
            <use xlink:href="#icons-checked" />
          </svg>
        </div>
        <div class="wizard__nav-item-box wizard__nav-item-box--left"></div>
        <div class="wizard__nav-item-box wizard__nav-item-box--right"></div>
      </li>
    </ul>
    <div class="wizard__content">
      <div
        class="wizard__content-item"
        v-for="step in numOfSteps"
        v-show="showStep(step)"
        :key="step"
      >
        <event-listener @next="next(step)" @previous="previous(step)">
          <slot :name="`wizard-item-${step}-content`"></slot>
        </event-listener>
      </div>
    </div>
  </div>
</template>

<script>
import EventListener from "./EventListener.vue";

export default {
  props: {
    numOfSteps: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      currentStep: 1
    };
  },
  components: {
    EventListener
  },
  methods: {
    showStep(step) {
      return this.currentStep == step;
    },
    next() {
      if (this.currentStep < this.numOfSteps) {
        this.currentStep = this.currentStep + 1;
      }
    },
    previous() {
      if (this.currentStep > 1) {
        this.currentStep = this.currentStep - 1;
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.wizard {
  .wizard__nav {
    display: flex;
    min-height: 1rem;
    margin: 0 25%;

    .wizard__nav-item {
      display: inline-block;
      text-align: center;
      position: relative;

      .wizard__nav-item-icon {
        position: absolute;
        display: inline-block;
        width: 0.5em;
        height: 0.5em;
        top: calc(50% - (0.5em / 2));
        background-color: white;
        border: 1px solid #4c636f;
        border-radius: 100%;
        z-index: 1;

        svg {
          position: absolute;
          display: none;
          top: calc(50% - (0.875em / 2));
          left: 0;
        }
      }

      .wizard__nav-item-box {
        display: inline-block;
        position: absolute;
        top: 50%;
        width: 50%;
        height: 50%;
        border-top: 1px solid #4c636f;

        &--left {
          right: 50%;
        }
      }

      &--first {
        .wizard__nav-item-box--left {
          border-top: none;
        }
      }

      &--last {
        .wizard__nav-item-box--right {
          border-top: none;
        }
      }

      &--current {
        .wizard__nav-item-icon {
          background-color: #4c636f;
        }
      }

      &--completed {
        .wizard__nav-item-icon {
          border: none;

          svg {
            display: inline-block;
          }
        }
      }
    }
  }
}
</style>
