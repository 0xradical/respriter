<template>
  <div>
    <div class="el:m-avatar el:m-avatar--circle el:m-avatar--64x64">
      <img
        v-if="$store.state.profile.avatar_url != ''"
        :src="$store.state.profile.avatar_url"
      />
      <img v-else src="../assets/avatar-default.svg" />
      <div class="el:m-avatar__overlay el:m-avatar__overlay--upload-icon">
        <input id="pick-avatar" type="file" />
      </div>
    </div>
    <div class="el:amx-D(ib) el:amx-Va(m) el:amx-Ml(0.5em)">
      {{ $t("user.greetings", { name: $store.state.profile.name }) }}
      <a
        :href="$session.logOutURL()"
        class="el:amx-Fs(0.75em) el:amx-D(b) el:amx-Mt(0.375em)"
      >
        {{ $t("dictionary.sign_out") }}
      </a>
    </div>
    <avatar-cropper
      @uploaded="onSuccessUpload"
      :labels="labels"
      trigger="#pick-avatar"
      :upload-url="`${$railsApi.defaults.baseURL}/images`"
      :upload-headers="{ Authorization: $session.getApiAuthHeader() }"
    />
  </div>
</template>

<script>
import AvatarCropper from "vue-avatar-cropper";

export default {
  data() {
    return {
      labels: {
        submit: this.$i18n.t("user.avatar.submit"),
        cancel: this.$i18n.t("user.avatar.cancel")
      }
    };
  },

  components: {
    AvatarCropper
  },

  methods: {
    onSuccessUpload(response) {
      this.$store.commit("profile/update", {
        avatar_url: response.data.attributes.file.url
      });
    },

    logout() {
      this.$session.logOut();
    }
  }
};
</script>

<style>
.avatar-cropper-btn:hover {
  background-color: #027aff !important;
}
.avatar-cropper-overlay {
  background-color: #000000b3;
}
</style>
