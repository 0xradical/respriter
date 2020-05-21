<template>
  <div class="el:m-form-field">
    <div
      class="el:m-form-field__label"
      :class="[labelOver && 'el:m-form-field__label--over']"
    >
      <label :for="field">{{ label }}</label>
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
    }
  },
  computed: {
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
