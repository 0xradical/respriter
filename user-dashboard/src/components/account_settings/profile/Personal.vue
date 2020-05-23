<template>
  <validation-observer v-slot="{ invalid }" tag="div">
    <section-frame :alert="alert">
      <template #header>
        <div
          class="el:amx-D(f) el:amx-Bob el:amx-Pl(2em) el:amx-Pr(2em) el:amx-Pt(1.5em) el:amx-Pb(1.5em)"
        >
          <span class="el:amx-Fw(b) el:amx-Tt(u) el:amx-Fs(0.875em)">{{
            $t("user.sections.account_settings.profile.sections.personal.title")
          }}</span>
        </div>
      </template>

      <form action="#" ref="form">
        <validation-provider
          #default="{ errors: clientSideErrors }"
          tag="div"
          name="name"
          :rules="{
            required: true,
            min: 5,
            max: 30,
            regex: /^\w+( \w+)*/
          }"
        >
          <text-input-field
            class="el:amx-Mb(1em)"
            field="name"
            :errors="[...clientSideErrors, ...(serverSideErrors.name || [])]"
            :disabled="loading || sending"
            :label="$t('user.forms.profile.name_field_label')"
            input-size="medium"
            :input-block="true"
            :input-placeholder="$t('user.forms.profile.name_field_placeholder')"
            :value="local.name"
            @input="v => (local.name = v)"
          >
          </text-input-field>
        </validation-provider>

        <validation-provider
          #default="{ errors: clientSideErrors }"
          tag="div"
          class="el:amx-Mb(1em)"
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
          <text-input-field
            field="username"
            :errors="[
              ...clientSideErrors,
              ...(serverSideErrors.username || [])
            ]"
            :disabled="loading || sending"
            :label="$t('user.forms.profile.username_field_label')"
            input-size="medium"
            :input-block="true"
            :input-placeholder="
              $t('user.forms.profile.username_field_placeholder')
            "
            :value="local.username"
            @input="v => (local.username = v)"
          >
          </text-input-field>
        </validation-provider>

        <input
          :disabled="loading || sending || invalid"
          @click.prevent="submit"
          type="submit"
          class="el:amx-Mt(1.5em) btn btn--primary-flat btn--medium btn--block"
          :value="$t('user.forms.profile.submit')"
        />
      </form>
    </section-frame>
  </validation-observer>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import { pick } from "ramda";
import SectionFrame from "~components/SectionFrame.vue";
import TextInputField from "~components/form_fields/TextInput.vue";
import { snakeCasedKeys, normalizeUrl, safeJSONParse } from "~utils";
import { operations } from "~store/types";
import namespaces from "~store/namespaces";

const { mapActions } = helpers(namespaces.PROFILE);

const FIELDS = {
  name: undefined,
  username: undefined
};
const alertInitializer = () => ({ message: "", type: "" });

export default {
  props: {
    profile: {
      type: Object,
      required: true
    },
    loading: {
      type: Boolean,
      default: true
    }
  },
  components: {
    SectionFrame,
    TextInputField
  },
  data() {
    return {
      local: { ...FIELDS },
      serverSideErrors: [],
      alert: alertInitializer(),
      sending: false
    };
  },
  created() {
    this.local = pick(Object.keys(FIELDS), this.profile);
  },
  watch: {
    profile(n) {
      this.local = pick(Object.keys(FIELDS.keys), this.n);
    }
  },
  methods: {
    ...mapActions({ persist: operations.UPDATE }),
    submit(event) {
      event.preventDefault();
      this.serverSideErrors = [];
      this.sending = true;

      const userAccountId = this.$session.getUserId();
      const payload = snakeCasedKeys(this.local);

      this.persist({ userAccountId, payload })
        .then(() => {
          this.sending = false;
          this.alert = {
            message: this.$t(
              "user.sections.account_settings.profile.success_message"
            ),
            type: "success"
          };
          setTimeout(() => (this.alert = alertInitializer()), 5000);
          this.$emit("success", { what: "personal" });
        })
        .catch(error => {
          this.sending = false;
          const { response } = error;
          const errorDetail = response?.data?.details || "unmapped_constraint";
          const errorHint = safeJSONParse(response?.data?.hint);
          const errorField =
            errorDetail.match(/^(?:(?<field>.*)__)/)?.groups?.field ||
            "profile";
          const errorMessage = this.$t(`db.${errorDetail}`, errorHint)?.replace(
            /\.$/,
            ""
          );

          this.serverSideErrors = {
            [errorField]: [errorMessage]
          };

          this.alert = {
            message: errorMessage,
            type: "danger"
          };

          this.$emit("error", {
            what: "instructor",
            where: errorField,
            why: errorMessage
          });
        });
    }
  }
};
</script>
