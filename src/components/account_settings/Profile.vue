<template>
  <section-frame :alert="alert">
    <template #title>
      {{ $t("user.sections.account_settings.profile.title") }}
    </template>

    <validation-observer v-slot="{ invalid }" slim>
      <form class="el:amx-Mt(1.5em)" action="#">
        <validation-provider
          #default="{ errors }"
          tag="div"
          name="name"
          :rules="{ required: true, min: 5, max: 30, regex: /^\w+( \w+)*/ }"
        >
          <div
            class="el:m-form-field el:amx-Mb(1em)"
            :class="[
              errors.length > 0 && 'el:m-form-field--error',
              (loading || sending) && 'el:m-form-field--disabled'
            ]"
          >
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label
                v-html="$t('user.forms.profile.name_field_label')"
                for="name"
              ></label>
            </div>
            <div
              class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
            >
              <input
                name="name"
                :disabled="loading || sending"
                type="text"
                :placeholder="$t('user.forms.profile.name_field_placeholder')"
                v-model="name"
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
                v-if="name && errors.length == 0"
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
          #default="{ errors: clientSideErrors }"
          tag="div"
          name="username"
          :rules="{
            required: true,
            min: 5,
            max: 15,
            usernameFormat: true,
            usernameConsecutiveDash: true,
            usernameConsecutiveUnderline: true,
            usernameBoundaryDash: true,
            usernameBoundaryUnderline: true,
            usernameLowercased: true
          }"
        >
          <div
            class="el:m-form-field el:amx-Mb(1.625em)"
            :class="[
              (clientSideErrors.length > 0 || serverSideErrors.length > 0) &&
                'el:m-form-field--error',
              (loading || sending) && 'el:m-form-field--disabled'
            ]"
          >
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label
                v-html="$t('user.forms.profile.username_field_label')"
                for="username"
              ></label>
            </div>
            <div
              class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
            >
              <input
                name="username"
                :disabled="loading || sending"
                type="text"
                :placeholder="
                  $t('user.forms.profile.username_field_placeholder')
                "
                v-model="username"
              />
              <svg
                v-if="
                  clientSideErrors.length > 0 || serverSideErrors.length > 0
                "
                class="el:m-form-field__input-icon el:amx-C_er"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-wrong" />
              </svg>
              <svg
                v-if="
                  username &&
                    clientSideErrors.length == 0 &&
                    serverSideErrors.length == 0
                "
                class="el:m-form-field__input-icon el:amx-Fi_pr"
                width="1.125em"
                height="1.125em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-checked" />
              </svg>
              <div
                v-if="
                  clientSideErrors.length > 0 || serverSideErrors.length > 0
                "
                class="el:amx-Mt(0.25em) el:amx-C_er"
              >
                <span class="el:amx-Fs(0.75em)">{{ clientSideErrors[0] }}</span>
              </div>
            </div>
          </div>
        </validation-provider>

        <input
          :disabled="loading || invalid || sending"
          @click.prevent="submit"
          type="submit"
          class="btn btn--primary-flat btn--medium btn--block"
          :value="$t('user.forms.profile.submit')"
        />
      </form>
    </validation-observer>
  </section-frame>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import SectionFrame from "../SectionFrame.vue";
import namespaces from "../../store/namespaces";
import { primitives } from "../../store/types";

const { mapActions, mapMutations, mapState } = helpers(namespaces.PROFILE);

export default {
  data() {
    return {
      name: null,
      username: null,
      loading: true,
      sending: false,
      serverSideErrors: [],
      alert: {
        message: "",
        type: ""
      }
    };
  },

  components: {
    SectionFrame
  },

  computed: {
    ...mapState(["loaded"])
  },

  watch: {
    // coming from /account-settings directly
    loaded: function() {
      this.init();
    }
  },

  created() {
    // coming from / -> /account-setting redirection
    if (this.loaded) {
      this.init();
    }
  },

  methods: {
    ...mapMutations({ change: primitives.UPDATE }),
    ...mapActions({ persist: primitives.UPDATE }),
    init() {
      this.name = this.$store.state.profile.name;
      this.username = this.$store.state.profile.username;
      this.loading = false;
    },
    submit(event) {
      event.preventDefault();

      const payload = {};

      if (this.name) {
        payload.name = this.name;
      }
      if (this.username) {
        payload.username = this.username;
      }

      this.sending = true;

      this.persist({
        user_account_id: this.$session.getUserId(),
        payload
      }).then(
        () => {
          this.sending = false;
          this.alert = {
            message: this.$t(
              "user.sections.account_settings.profile.success_message"
            ),
            type: "success"
          };
        },
        error => {
          this.sending = false;
          const { response } = error;
          const errorDetail = response?.data?.details || "unmapped_constraint";
          const errorMessage = this.$t(`db.${errorDetail}`);

          this.serverSideErrors.push(errorMessage);

          this.alert = {
            message: errorMessage,
            type: "danger"
          };
        }
      );
    }
  }
};
</script>
