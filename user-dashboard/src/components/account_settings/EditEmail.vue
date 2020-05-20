<template>
  <section-frame :alert="alert">
    <template #title>
      {{ $t("user.sections.account_settings.email.title") }}
    </template>

    <span
      v-html="
        $t('user.sections.account_settings.email.your_current_email_is', {
          email: 'johndoe@gmail.com'
        })
      "
      class="el:amx-Mt(1em) el:amx-Mb(0.5em) el:amx-Fs(1em) el:amx-Lh(1) el:amx-D(ib)"
    ></span>

    <br />
    <div class="el:amx-Mb(1em)">
      <span
        class="el:amx-Mt(0.25em) el:amx-Fs(0.75em) el:amx-Mr(0.5em) el:amx-Lh(1) el:amx-D(ib)"
        >skillo@gmail.com</span
      >
      <span class="el:m-tag el:m-tag--magenta3-border el:amx-Fs(0.5em)">
        {{ $t("user.sections.account_settings.email.awaiting_confirmation") }}
      </span>
    </div>

    <validation-observer v-slot="{ invalid, validate }" slim>
      <form @submit.prevent="validate().then(submit)">
        <validation-provider
          #default="{ errors }"
          tag="div"
          name="email"
          rules="required|email"
        >
          <div
            class="el:m-form-field el:amx-Mb(0.5em)"
            :class="[
              errors.length > 0 && 'el:m-form-field--error',
              sending && 'el:m-form-field--disabled'
            ]"
          >
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label for="email">{{
                $t("user.forms.email.email_field_label")
              }}</label>
            </div>

            <div
              class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
            >
              <input
                name="email"
                type="text"
                :placeholder="$t('user.forms.email.email_field_placeholder')"
                v-model.trim="email"
              />
              <svg
                v-if="errors.length > 0"
                class="el:m-form-field__input-icon el:amx-C_er"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-wrong" />
              </svg>
              <svg
                v-if="email && errors.length == 0"
                class="el:m-form-field__input-icon el:amx-Fi_pr"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-checked" />
              </svg>
              <div
                v-if="errors.length > 0"
                class="el:amx-Mt(0.25em) el:amx-C_er"
              >
                <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
              </div>
            </div>
          </div>
        </validation-provider>

        <validation-provider
          #default="{ errors }"
          tag="div"
          name="email_confirmation"
          rules="required|mismatch:email"
        >
          <div
            class="el:m-form-field el:amx-Mb(0.5em)"
            :class="[
              errors.length > 0 && 'el:m-form-field--error',
              sending && 'el:m-form-field--disabled'
            ]"
          >
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label for="email_confirmation">{{
                $t("user.forms.email.email_confirmation_field_label")
              }}</label>
            </div>

            <div
              class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
            >
              <input
                name="email_confirmation"
                type="text"
                :placeholder="
                  $t('user.forms.email.email_confirmation_field_placeholder')
                "
                v-model.trim="email_confirmation"
              />
              <svg
                v-if="errors.length > 0"
                class="el:m-form-field__input-icon el:amx-C_er"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-wrong" />
              </svg>
              <svg
                v-if="email_confirmation && errors.length == 0"
                class="el:m-form-field__input-icon el:amx-Fi_pr"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-checked" />
              </svg>
              <div
                v-if="errors.length > 0"
                class="el:amx-Mt(0.25em) el:amx-C_er"
              >
                <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
              </div>
            </div>
          </div>
        </validation-provider>

        <validation-provider
          #default="{ errors }"
          tag="div"
          name="password"
          rules="required|min:10"
        >
          <div
            class="el:m-form-field el:amx-Mb(0.5em)"
            :class="[
              errors.length > 0 && 'el:m-form-field--error',
              sending && 'el:m-form-field--disabled'
            ]"
          >
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label for="password">{{
                $t("user.forms.email.password_field_label")
              }}</label>
            </div>

            <div
              class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
            >
              <input
                name="password"
                type="text"
                :placeholder="$t('user.forms.email.password_field_placeholder')"
                v-model.trim="password"
              />
              <svg
                v-if="errors.length > 0"
                class="el:m-form-field__input-icon el:amx-C_er"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-wrong" />
              </svg>
              <svg
                v-if="password && errors.length == 0"
                class="el:m-form-field__input-icon el:amx-Fi_pr"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-checked" />
              </svg>
              <div
                v-if="errors.length > 0"
                class="el:amx-Mt(0.25em) el:amx-C_er"
              >
                <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
              </div>
            </div>
          </div>
        </validation-provider>

        <input
          :disabled="invalid || sending"
          type="submit"
          class="btn btn--primary-flat btn--medium btn--block"
          :value="$t('user.forms.email.submit')"
        />
      </form>
    </validation-observer>
  </section-frame>
</template>

<script>
import SectionFrame from "../SectionFrame.vue";

export default {
  data() {
    return {
      sending: false,
      alert: {
        message: "",
        type: ""
      },
      email: "",
      email_confirmation: "",
      password: ""
    };
  },

  components: {
    SectionFrame
  },

  methods: {
    submit() {
      this.alert = {
        message: `We've sent a confirmation link to ${this.email}! Change will only take effect after you confirm it`,
        type: "success"
      };
    }
  }
};
</script>
