<template>
  <div
    class="clspt:contact-us__form container el:amx-Mt(1.5em) el:amx-Mb(3em) el:amx-Mt(2em)@>lg el:amx-Mb(4em)@>lg"
  >
    <div class="row el:amx-Mb(1.5em) el:amx-Mb(2em)@>lg">
      <div class="col el:amx-Ta(c)">
        <div class="el:amx-Mb(0.5em) el:amx-Mb(1em)@>lg">
          <span
            class="el:amx-Fs(1.5em) el:amx-Fs(2em)@>lg el:amx-Fw(b) el:amx-C_gray5"
            >{{ $t("contact_us.new.title") }}</span
          >
        </div>
        <div>
          <span class="el:amx-Fs(1em) el:amx-C_gray3">{{
            $t("contact_us.new.subtitle")
          }}</span>
        </div>
      </div>
    </div>

    <validation-observer v-slot="{ invalid, validate }" tag="div">
      <form @submit.prevent="validate().then(submit)" class="row">
        <input name="authenticity_token" :value="authToken" type="hidden" />

        <validation-provider
          tag="div"
          name="name"
          rules="required|min:5"
          class="col-md-12 offset-lg-4 col-lg-4 el:amx-Mb(2em)"
        >
          <template #default="{ errors }">
            <div
              class="el:m-form-field"
              :class="[
                errors.length > 0 && 'el:m-form-field--error',
                sending && 'el:m-form-field--disabled'
              ]"
            >
              <div class="el:m-form-field__label el:m-form-field__label--over">
                <label for="name">{{
                  $t("contact_us.new.form.name.header")
                }}</label>
              </div>

              <div
                class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
              >
                <input
                  name="name"
                  type="text"
                  :placeholder="$t('contact_us.new.form.name.placeholder')"
                  v-model="contact.name"
                />
                <icon
                  v-if="errors.length > 0"
                  class="el:m-form-field__input-icon el:amx-Fi_er"
                  name="error"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <icon
                  v-if="contact.name && errors.length == 0"
                  class="el:m-form-field__input-icon el:amx-Fi_pr"
                  name="checked"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <div
                  v-if="errors.length > 0"
                  class="el:amx-Mt(0.25em) el:amx-C_er"
                >
                  <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
                </div>
              </div>
            </div>
          </template>
        </validation-provider>

        <validation-provider
          tag="div"
          name="email"
          rules="required|email"
          class="col-md-12 offset-lg-4 col-lg-4 el:amx-Mb(2em)"
        >
          <template #default="{ errors }">
            <div
              class="el:m-form-field"
              :class="[
                errors.length > 0 && 'el:m-form-field--error',
                sending && 'el:m-form-field--disabled'
              ]"
            >
              <div class="el:m-form-field__label el:m-form-field__label--over">
                <label for="email">{{
                  $t("contact_us.new.form.email.header")
                }}</label>
              </div>

              <div
                class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
              >
                <input
                  name="email"
                  type="text"
                  :placeholder="$t('contact_us.new.form.email.placeholder')"
                  v-model="contact.email"
                />
                <icon
                  v-if="errors.length > 0"
                  class="el:m-form-field__input-icon el:amx-Fi_er"
                  name="error"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <icon
                  v-if="contact.email && errors.length == 0"
                  class="el:m-form-field__input-icon el:amx-Fi_pr"
                  name="checked"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <div
                  v-if="errors.length > 0"
                  class="el:amx-Mt(0.25em) el:amx-C_er"
                >
                  <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
                </div>
              </div>
            </div>
          </template>
        </validation-provider>

        <validation-provider
          tag="div"
          name="reason"
          rules="required"
          class="col-md-12 offset-lg-4 col-lg-4 el:amx-Mb(2em)"
        >
          <template #default="{ errors }">
            <div
              class="el:m-form-field"
              :class="[
                errors.length > 0 && 'el:m-form-field--error',
                sending && 'el:m-form-field--disabled'
              ]"
            >
              <div class="el:m-form-field__label el:m-form-field__label--over">
                <label for="reason">{{
                  $t("contact_us.new.form.reason.header")
                }}</label>
              </div>

              <div class="el:m-select el:select--medium">
                <select
                  name="reason"
                  v-model="contact.reason"
                  :disabled="sending"
                >
                  <option value="">{{
                    $t("contact_us.new.form.reason.options.select_option")
                  }}</option>
                  <option value="customer_support">{{
                    $t("contact_us.new.form.reason.options.customer_support")
                  }}</option>
                  <option value="bug_report">{{
                    $t("contact_us.new.form.reason.options.bug_report")
                  }}</option>
                  <option value="feature_suggestion">{{
                    $t("contact_us.new.form.reason.options.feature_suggestion")
                  }}</option>
                  <option value="commercial_and_partnerships">{{
                    $t(
                      "contact_us.new.form.reason.options.commercial_and_partnerships"
                    )
                  }}</option>
                  <option value="manual_profile_claim">{{
                    $t(
                      "contact_us.new.form.reason.options.manual_profile_claim"
                    )
                  }}</option>
                  <option value="other">{{
                    $t("contact_us.new.form.reason.options.other")
                  }}</option>
                </select>
              </div>
              <div
                v-if="errors.length > 0"
                class="el:amx-Mt(0.25em) el:amx-C_er"
              >
                <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
              </div>
            </div>
          </template>
        </validation-provider>

        <validation-provider
          tag="div"
          name="subject"
          rules="required"
          class="col-md-12 offset-lg-4 col-lg-4 el:amx-Mb(2em)"
        >
          <template #default="{ errors }">
            <div
              class="el:m-form-field"
              :class="[
                errors.length > 0 && 'el:m-form-field--error',
                sending && 'el:m-form-field--disabled'
              ]"
            >
              <div class="el:m-form-field__label el:m-form-field__label--over">
                <label for="subject">{{
                  $t("contact_us.new.form.subject.header")
                }}</label>
              </div>

              <div
                class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
              >
                <input
                  name="subject"
                  type="text"
                  :placeholder="$t('contact_us.new.form.subject.placeholder')"
                  v-model="contact.subject"
                />
                <icon
                  v-if="errors.length > 0"
                  class="el:m-form-field__input-icon el:amx-Fi_er"
                  name="error"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <icon
                  v-if="contact.subject && errors.length == 0"
                  class="el:m-form-field__input-icon el:amx-Fi_pr"
                  name="checked"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <div
                  v-if="errors.length > 0"
                  class="el:amx-Mt(0.25em) el:amx-C_er"
                >
                  <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
                </div>
              </div>
            </div>
          </template>
        </validation-provider>

        <validation-provider
          tag="div"
          name="message"
          rules="required"
          class="col-md-12 offset-lg-4 col-lg-4 el:amx-Mb(1.5em)"
        >
          <template #default="{ errors }">
            <div
              class="el:m-form-field"
              :class="[
                errors.length > 0 && 'el:m-form-field--error',
                sending && 'el:m-form-field--disabled'
              ]"
            >
              <div class="el:m-form-field__label el:m-form-field__label--over">
                <label for="message">{{
                  $t("contact_us.new.form.message.header")
                }}</label>
              </div>

              <div class="el:m-form-field__textarea">
                <textarea
                  class="el:amx-W(100%)"
                  name="message"
                  type="text"
                  :placeholder="$t('contact_us.new.form.message.placeholder')"
                  v-model="contact.message"
                />
                <div
                  v-if="errors.length > 0"
                  class="el:amx-Mt(0.25em) el:amx-C_er"
                >
                  <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
                </div>
              </div>
            </div>
          </template>
        </validation-provider>

        <validation-provider
          tag="div"
          name="challenge"
          :rules="
            `required|challenge:${mathenticate.first},${mathenticate.second}`
          "
          class="col-md-12 offset-lg-4 col-lg-4 el:amx-Mb(2em)"
        >
          <template #default="{ errors }">
            <div
              class="el:m-form-field"
              :class="[
                errors.length > 0 && 'el:m-form-field--error',
                sending && 'el:m-form-field--disabled'
              ]"
            >
              <div class="el:m-form-field__label el:m-form-field__label--over">
                <label for="challenge">{{
                  $t("contact_us.new.form.challenge.header", {
                    question: mathenticate.show()
                  })
                }}</label>
              </div>

              <div
                class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
              >
                <input
                  name="challenge"
                  type="text"
                  :placeholder="$t('contact_us.new.form.challenge.placeholder')"
                  v-model="mathenticate.answer"
                />
                <icon
                  v-if="errors.length > 0"
                  class="el:m-form-field__input-icon el:amx-Fi_er"
                  name="error"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <icon
                  v-if="mathenticate.answer && errors.length == 0"
                  class="el:m-form-field__input-icon el:amx-Fi_pr"
                  name="checked"
                  width="1.125em"
                  height="1.125em"
                ></icon>
                <div
                  v-if="errors.length > 0"
                  class="el:amx-Mt(0.25em) el:amx-C_er"
                >
                  <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
                </div>
              </div>
            </div>
          </template>
        </validation-provider>

        <div class="col-md-12 offset-lg-6 col-lg-2">
          <button
            :disabled="server || invalid || sending"
            class="btn btn--block btn--primary-flat"
          >
            {{ $t("contact_us.new.form.action.submit") }}
          </button>
        </div>
      </form>
    </validation-observer>
  </div>
</template>

<script>
  import Icon from "components/Icon.vue";
  import axios from "axios";

  export default {
    data() {
      return {
        sending: false,
        server: true,
        mathenticate: {
          first: Math.floor(Math.random() * 5) + 1,
          second: Math.floor(Math.random() * 95) + 1,
          answer: null,
          solve: function() {
            return this.first + this.second;
          },
          show: function() {
            return this.first + " + " + this.second;
          }
        }
      };
    },
    props: {
      contact: {
        type: Object,
        required: true
      },
      authToken: {
        type: String,
        required: true
      }
    },
    components: {
      Icon
    },
    mounted() {
      this.server = false;
    },
    methods: {
      submit: function() {
        if (this.sending) {
          return;
        }

        this.sending = true;

        axios
          .post(
            `/contact-us.json?authenticity_token=${encodeURIComponent(
              this.authToken
            )}`,
            {
              contact: this.contact
            }
          )
          .then(response => {
            this.sending = false;
            this.$emit("submitted");
          })
          .catch(error => {
            this.sending = false;
          });
      }
    }
  };
</script>

<style lang="scss" scoped>
  textarea {
    height: 6.25em;
  }
</style>
