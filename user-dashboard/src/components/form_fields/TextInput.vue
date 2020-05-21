<template>
  <div
    class="el:m-form-field"
    :class="[
      hasErrors && 'el:m-form-field--error',
      disabled && 'el:m-form-field--disabled',
      ...rootClasses
    ]"
  >
    <div
      class="el:m-form-field__label"
      :class="[labelOver && 'el:m-form-field__label--over']"
    >
      <label v-html="label" :for="field"></label>
    </div>
    <div
      class="el:m-form-field__input"
      :class="[
        `el:m-form-field__input--${inputSize}`,
        inputBlock && 'el:m-form-field__input--block'
      ]"
    >
      <input
        :name="field"
        :disabled="disabled"
        type="text"
        :placeholder="inputPlaceholder"
        v-model="model"
      />
      <svg
        v-if="hasErrors"
        class="el:m-form-field__input-icon el:amx-C_er"
        width="1.125em"
        height="1.125em"
        viewbox="0 0 24 24"
      >
        <use xlink:href="#icons-wrong" />
      </svg>
      <svg
        v-if="model && !hasErrors"
        class="el:m-form-field__input-icon el:amx-Fi_pr"
        width="1.125em"
        height="1.125em"
        viewbox="0 0 24 24"
      >
        <use xlink:href="#icons-checked" />
      </svg>
      <div v-if="hasErrors" class="el:amx-C_er">
        <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      required: false
    },
    errors: {
      type: Array,
      default() {
        return [];
      }
    },
    rootClasses: {
      type: Array,
      default() {
        return [];
      }
    },
    disabled: {
      type: Boolean,
      default: false
    },
    label: {
      type: String,
      required: true
    },
    field: {
      type: String,
      required: true
    },
    labelOver: {
      type: Boolean,
      default: true
    },
    inputSize: {
      type: String,
      default: "medium",
      validator: value => ["medium", "large"].indexOf(value) !== -1
    },
    inputBlock: {
      type: Boolean,
      default: false
    },
    inputPlaceholder: {
      type: String
    }
  },
  computed: {
    hasErrors() {
      return this.errors.length > 0;
    },
    model: {
      get() {
        return this.value;
      },
      set(val) {
        this.$emit("input", val);
      }
    }
  }
};
</script>
