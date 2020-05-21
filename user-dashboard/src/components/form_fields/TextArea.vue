<template>
  <div
    class="el:m-form-field"
    :class="[
      disabled && 'el:m-form-field--disabled',
      hasErrors && 'el:m-form-field--error'
    ]"
  >
    <div
      class="el:m-form-field__label"
      :class="[labelOver && 'el:m-form-field__label--over']"
    >
      <label :for="field" :disabled="disabled">{{ label }}</label>
    </div>
    <div class="el:m-form-field__textarea">
      <textarea
        :name="field"
        v-model="model"
        :placeholder="placeholder"
        :style="{
          height: height,
          width: '100%'
        }"
      ></textarea>

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
    height: {
      type: String,
      required: false,
      default: "150px"
    },
    errors: {
      type: Array,
      default() {
        return [];
      }
    },
    label: {
      type: String,
      required: true
    },
    labelOver: {
      type: Boolean,
      default: true
    },
    field: {
      type: String,
      required: true
    },
    placeholder: {
      type: String
    },
    disabled: {
      type: Boolean,
      default: false
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

<style lang="scss" scoped>
label[disabled] {
  color: var(--foreground-low);
}
</style>
