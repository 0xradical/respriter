<template>
  <div>
    <div ref="personal">
      <personal-profile
        :profile="profile"
        :loading="loading"
        @success="scroll($refs.personal)"
      />
    </div>
    <div ref="instructor">
      <instructor-profile
        :profile="profile"
        :loading="loading"
        @success="scroll($refs.instructor)"
      />
    </div>
  </div>
</template>

<script>
import { clone, __, curryN } from "ramda";
import { createNamespacedHelpers as helpers } from "vuex";
import ScrollTo from "vue-scrollto";
import PersonalProfile from "~components/account_settings/profile/Personal.vue";
import InstructorProfile from "~components/account_settings/profile/Instructor.vue";
import { operations } from "~store/types";
import namespaces from "~store/namespaces";

const { mapState } = helpers(namespaces.PROFILE);

const scrollOptions = {
  container: "body",
  easing: "ease-in",
  offset: -60,
  force: true,
  cancelable: false,
  x: false,
  y: true
};
const scrollDuration = 300;
const scroll = curryN(3, ScrollTo.scrollTo)(__, scrollDuration, scrollOptions);

export default {
  data() {
    return {
      profile: {},
      loading: true
    };
  },

  components: {
    PersonalProfile,
    InstructorProfile
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
    scroll,
    init() {
      this.profile = clone(this.$store.state.profile);
      this.loading = false;
    }
  }
};
</script>
