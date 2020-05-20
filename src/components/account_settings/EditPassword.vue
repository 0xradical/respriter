<template>
  <section-frame :alert="alert">
    <template #title>
      {{ $t("user.sections.account_settings.password.title") }}
    </template>
    <p class="el:amx-Fs(0.875em) el:amx-Mb(1.5em)">
      {{ $t("user.sections.account_settings.password.info") }}
    </p>
    <a
      @click="submit"
      class="btn btn--primary-flat btn--medium btn--block"
      value="change password"
    >
      {{ $t("user.sections.account_settings.password.change_password_button") }}
    </a>
  </section-frame>
</template>
<script>
import env from "../../config/environment";
import SectionFrame from "../SectionFrame.vue";

export default {
  data() {
    return {
      alert: {
        message: "",
        type: ""
      }
    };
  },

  components: {
    SectionFrame
  },

  methods: {
    submit() {
      var vm = this;

      this.$crossOriginXHR
        .post(env.forgotPasswordPath, {
          user_account: {
            email: vm.$store.state.user_account.email
          }
        })
        .then(function() {
          vm.alert.message = vm.$i18n.t(
            "user.sections.account_settings.password.success_message",
            { email: vm.$store.state.user_account.email }
          );
          vm.alert.type = "success";
        })
        .catch(function() {
          vm.alert.message = vm.$i18n.t(
            "user.sections.account_settings.password.error_message",
            { email: vm.$store.state.user_account.email }
          );
          vm.alert.type = "danger";
        });
    }
  }
};
</script>
