<template>
  <div
    class="el:amx-D(f) el:amx-FxAi(c) el:amx-Mb(2em)@<sm"
    :class="[errors && errors.length && 'el:amx-Mb(2em)@>lg']"
  >
    <div style="flex: 1" class="el:amx-Pos(r) el:amx-D(ib)">
      <div
        class="el:amx-D(f) el:amx-Pos(r) user:sm-input"
        :class="{
          'user:sm-input--error': errors && errors.length
        }"
      >
        <div class="el:amx-D(ib) el:amx-D(f) user:sm-input__left">
          <svg class="user:sm-input__icon">
            <use :class="`el:amx-Fi_${iconColor}`" :xlink:href="icon" /></svg
          ><b class="el:amx-D(n)@<sm">{{ canonicalURL("") }}</b>
        </div>

        <input
          class="el:amx-D(ib) el:amx-D(n)@<sm user:sm-input__right"
          @paste.prevent="
            e => {
              model = onpaste(transform(validator))(e);
            }
          "
          :placeholder="$t('user.components.social_media_input.placeholder')"
          :disabled="disabled"
          @input="model = $event.target.value"
          :value="model"
        />
        <input
          class="el:amx-D(ib) el:amx-D(n)@>lg user:sm-input__right"
          @paste.prevent="
            e => {
              model = onpaste(transform(validator))(e);
            }
          "
          :placeholder="
            $t('user.components.social_media_input.placeholder_mobile')
          "
          :disabled="disabled"
          @input="model = $event.target.value"
          :value="model"
        />
        <svg
          v-if="errors && errors.length"
          class="user:sm-input__icon el:amx-Pos(a) el:amx-C_er"
        >
          <use xlink:href="#icons-wrong" />
        </svg>
        <svg
          v-if="model && !(errors && errors.length)"
          class="user:sm-input__icon el:amx-Pos(a) el:amx-Fi_pr"
        >
          <use xlink:href="#icons-checked" />
        </svg>
      </div>
      <div
        v-if="errors && errors.length"
        class="el:amx-Pos(a) el:amx-D(n)@<sm el:amx-C_er"
        style="top: 2.75em;"
      >
        <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
      </div>
      <div class="el:amx-Pos(a) el:amx-D(n)@>lg" style="top: 2.75em;">
        <span
          class="el:amx-Fs(0.75em)"
          :class="errors && errors.length && 'el:amx-C_er'"
          >{{ canonicalURL(this.model || "") }}</span
        >
      </div>
    </div>
    <div style="flex: 0 0 2em" class="el:amx-Ta(c)">
      <slot :errors="errors" name="control"> </slot>
    </div>
  </div>
</template>

<script>
import { validate } from "vee-validate";
import validations from "~validations/social";
import { onpaste } from "~utils";
import { SOCIAL_ICONS, ELEARNING_ICONS } from "~utils/social";

export default {
  data() {
    return {
      errors: []
    };
  },
  props: {
    value: {
      type: Object,
      required: true
    },
    platform: {
      type: String,
      required: true
    },
    type: {
      type: String,
      required: true
    },
    disabled: {
      type: Boolean,
      default: false
    },
    serverSideErrors: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  methods: {
    onpaste,
    transform(validator) {
      return function(pasted) {
        const validation = validator(pasted);
        return validation.valid ? validation.id : validation.originalValue;
      };
    }
  },
  mounted() {
    this.errors = [...this.serverSideErrors];
  },
  watch: {
    serverSideErrors: function(errors) {
      this.errors = [...errors];
    }
  },
  computed: {
    canonicalURL() {
      return validations[this.platform].canonicalURL;
    },
    validator() {
      return validations[this.platform].validator;
    },
    iconName() {
      return this.type === "elearning"
        ? ELEARNING_ICONS[this.platform]?.icon
        : SOCIAL_ICONS[this.platform]?.icon;
    },
    iconColor() {
      return this.type === "elearning"
        ? ELEARNING_ICONS[this.platform]?.color
        : SOCIAL_ICONS[this.platform]?.color;
    },
    iconType() {
      return this.type === "elearning" ? "providers" : "icons";
    },
    icon() {
      return `#${this.iconType}-${this.iconName}`;
    },
    model: {
      get() {
        return this.value[this.platform];
      },
      set(val) {
        const validation = this.validator(val);

        validate(
          val,
          {
            platformRequired: true,
            platformFormat: validation
          },
          { name: this.platform }
        ).then(result => {
          const id =
            this.value[this.platform] === validation.id &&
            validation.id !== undefined
              ? validation.id
              : val;

          this.errors = result.errors;

          this.$emit("input", {
            platform: this.platform,
            type: this.type,
            id: id,
            valid: result.valid,
            url: result.valid ? this.canonicalURL(val || "") : undefined
          });
        });
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.user\:sm-input {
  box-sizing: border-box;
  border-radius: 3px;
  border: 1px solid var(--foreground-medium);

  &--error {
    border: 1px solid var(--error);
  }

  &__left {
    font-size: 0.875em;
    border: none;
    padding: 0.925em 0 0.925em #{(0.75 / 0.875) * 1em};
  }

  &__right {
    background-color: var(--surface);
    line-height: 1;
    display: inline-block;
    box-sizing: border-box;
    color: var(--foreground);
    -moz-appearance: none;
    -webkit-appearance: none;
    box-shadow: none;
    outline: 0px;
    font-size: 0.875em;
    padding: 0.925em #{(0.75 / 0.875) * 1em} 0.925em 0;
    border: none;
    width: 100%;
  }

  &__icon {
    width: 1.125em;
    height: 1.125em;
  }

  &__left > &__icon {
    margin-right: 0.5em;
  }

  &__right + &__icon {
    top: 0.75em;
    right: 0.75em;
  }
}
</style>
