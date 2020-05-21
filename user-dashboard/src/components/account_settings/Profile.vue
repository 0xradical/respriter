<template>
  <validation-observer v-slot="{ invalid, errors: allErrors }" tag="div">
    <section-frame :alert="alert.basic" ref="basic-frame">
      <span class="el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-C_fgM el:amx-Tt(u)">
        {{
          $t(
            "user.sections.account_settings.profile.subsections.personal.title"
          )
        }}
      </span>

      <form class="el:amx-Mt(1.5em)" action="#" ref="form">
        <validation-provider
          #default="{ errors }"
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
            :errors="errors"
            :disabled="loading || sending"
            :label="$t('user.forms.profile.name_field_label')"
            input-size="medium"
            :input-block="true"
            :input-placeholder="$t('user.forms.profile.name_field_placeholder')"
            :value="profile.name"
            @input="v => (profile.name = v)"
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
              ...(serverSideErrors.basic.username || [])
            ]"
            :disabled="loading || sending"
            :label="$t('user.forms.profile.username_field_label')"
            input-size="medium"
            :input-block="true"
            :input-placeholder="
              $t('user.forms.profile.username_field_placeholder')
            "
            :value="profile.username"
            @input="v => (profile.username = v)"
          >
          </text-input-field>
        </validation-provider>
      </form>
    </section-frame>
    <section-frame
      :alert="alert.instructor"
      :disabled="!profile.instructor"
      class="el:amx-Mt(1.5em)"
      ref="instructor-frame"
    >
      <template #header>
        <div
          class="el:amx-Pos(r) el:amx-D(f) el:amx-Bob el:amx-Pl(2em) el:amx-Pr(2em) el:amx-Pt(1.5em) el:amx-Pb(1.5em)"
        >
          <span class="el:amx-Fw(b)" style="flex: 1">{{
            $t(
              "user.sections.account_settings.profile.subsections.instructor.header"
            )
          }}</span>
          <label class="el:m-switch el:m-switch--flat-primary" for="instructor">
            <input
              @click="profile.instructor = !profile.instructor"
              :checked="profile.instructor"
              type="checkbox"
              id="instructor"
            />
            <div class="el:m-switch__slider"></div>
          </label>
        </div>
      </template>

      <div>
        <span
          class="el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-C_fgM el:amx-Tt(u)"
          >{{
            $t(
              "user.sections.account_settings.profile.subsections.instructor.title"
            )
          }}</span
        >
      </div>
      <form class="el:amx-Mt(1.5em)" action="#" ref="form">
        <validation-provider
          #default="{ errors: clientSideErrors }"
          tag="div"
          class="el:amx-Mb(1em)"
          name="shortbio"
          :rules="{
            required: false,
            max: 60
          }"
        >
          <text-area-field
            field="shortbio"
            :errors="clientSideErrors"
            :disabled="loading || sending"
            :label="$t('user.forms.profile.shortbio_field_label')"
            :placeholder="$t('user.forms.profile.shortbio_field_placeholder')"
            height="100px"
            :value="profile.shortBio"
            @input="v => (profile.shortBio = v)"
          >
          </text-area-field>
        </validation-provider>

        <text-area-field
          class="el:amx-Mb(1em)"
          field="longbio"
          :disabled="loading || sending"
          :label="$t('user.forms.profile.about_field_label')"
          :placeholder="$t('user.forms.profile.about_field_placeholder')"
          height="200px"
          :value="profile.longBio"
          @input="v => (profile.longBio = v)"
        >
        </text-area-field>

        <div class="el:m-form-field el:amx-Mb(1.5em)">
          <div class="el:m-form-field__label el:m-form-field__label--over">
            <label for="social_profiles">{{
              $t("user.forms.profile.country_field_label")
            }}</label>
          </div>

          <div class="el:m-select">
            <select v-model="profile.country">
              <option value="">{{
                $t("user.forms.profile.country_field_select")
              }}</option>
              <option
                v-for="[countryCode, country] in countries"
                :value="countryCode"
                :key="countryCode"
              >
                {{ country }}
              </option>
            </select>
          </div>
        </div>

        <div class="el:amx-D(f) el:amx-Mb(2em)">
          <span class="el:amx-Fw(b) el:amx-Fs(0.875em)" style="flex: 1">{{
            $t("user.forms.profile.public_field_label")
          }}</span>
          <label class="el:m-switch el:m-switch--flat-primary" for="public">
            <input
              @click="profile.public = !profile.public"
              :checked="profile.public"
              type="checkbox"
              id="public"
            />
            <div class="el:m-switch__slider"></div>
          </label>
        </div>

        <h4>{{ $t("user.forms.profile.social_profiles_field_header") }}</h4>

        <p class="el:amx-Fs(0.75em)">
          {{ $t("user.forms.profile.social_profiles_field_about") }}
        </p>

        <div class="el:m-form-field el:amx-Mt(1em)">
          <div class="el:m-select" style="width: 93%;">
            <select
              @change="e => selectedPlatform('social')(e)"
              :disabled="platforms.social.available.length === 0"
            >
              <option value="">{{
                $t("user.forms.profile.social_profiles_field_select")
              }}</option>
              <option
                v-for="option in platforms.social.available"
                :value="option"
                :key="option"
              >
                {{ upperFirst(camelCase(option)) }}
              </option>
            </select>
          </div>

          <template v-for="(platform, index) in platforms.social.added">
            <social-media-input
              :platform="platform"
              :server-side-errors="
                serverSideErrors.instructor.social_profile &&
                  serverSideErrors.instructor.social_profile[platform]
              "
              type="social"
              :key="platform"
              :class="[
                'el:amx-D(ib)',
                index === 0 ? 'el:amx-Mt(1.5em)' : 'el:amx-Mt(1em)'
              ]"
              style="width: 93%;"
              :value="platforms.social.ids"
              @input="onInputPlatformID"
            ></social-media-input>
            <svg
              @click="removeProfilePlatform('social')(platform)"
              :key="`${platform}-remove`"
              class="user:platform-remover"
            >
              <use xlink:href="#icons-trash" />
            </svg>
          </template>
        </div>

        <h4 class="el:amx-Mt(2em)">
          {{ $t("user.forms.profile.elearning_profiles_field_header") }}
        </h4>

        <p class="el:amx-Fs(0.75em)">
          {{ $t("user.forms.profile.elearning_profiles_field_about") }}
        </p>

        <div class="el:m-form-field el:amx-Mt(1em)">
          <div class="el:m-select" style="width: 93%;">
            <select
              @change="e => selectedPlatform('elearning')(e)"
              :disabled="platforms.elearning.available.length === 0"
            >
              <option value="">{{
                $t("user.forms.profile.elearning_profiles_field_select")
              }}</option>
              <option
                v-for="option in platforms.elearning.available"
                :value="option"
                :key="option"
              >
                {{ upperFirst(camelCase(option)) }}
              </option>
            </select>
          </div>

          <template v-for="(platform, index) in platforms.elearning.added">
            <social-media-input
              :platform="platform"
              :server-side-errors="
                serverSideErrors.instructor.elearning_profile &&
                  serverSideErrors.instructor.elearning_profile[platform]
              "
              type="elearning"
              :key="platform"
              :class="[
                'el:amx-D(ib)',
                index === 0 ? 'el:amx-Mt(1.5em)' : 'el:amx-Mt(1em)'
              ]"
              style="width: 93%;"
              :value="platforms.elearning.ids"
              @input="onInputPlatformID"
            ></social-media-input>
            <svg
              @click="removeProfilePlatform('elearning')(platform)"
              :key="`${platform}-remove`"
              class="user:platform-remover"
            >
              <use xlink:href="#icons-trash" />
            </svg>
          </template>
        </div>
      </form>
    </section-frame>

    <input
      :disabled="
        loading ||
          sending ||
          (allErrors &&
            ((allErrors.username && allErrors.username.length > 0) ||
              (allErrors.name && allErrors.name.length > 0) ||
              (profile.instructor &&
                allErrors.shortbio &&
                allErrors.shortbio.length > 0)))
      "
      @click.prevent="submit"
      type="submit"
      class="el:amx-Mt(1.5em) btn btn--primary-flat btn--medium btn--block"
      :value="$t('user.forms.profile.submit')"
    />
  </validation-observer>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import { camelCase, upperFirst } from "lodash";
import { clone, without, omit, __, curryN } from "ramda";
import ScrollTo from "vue-scrollto";
import SectionFrame from "~components/SectionFrame.vue";
import TextInputField from "~components/form_fields/TextInput.vue";
import TextAreaField from "~components/form_fields/TextArea.vue";
import SocialMediaInput from "~components/form_fields/SocialMediaInput.vue";
import namespaces from "~store/namespaces";
import validations, {
  SOCIAL_PLATFORMS,
  ELEARNING_PLATFORMS,
  socialPlatformsReducer,
  elearningPlatformsReducer
} from "~validations/social";
import { operations } from "~store/types";
import { snakeCasedKeys, normalizeUrl, safeJSONParse } from "~utils";

const { mapActions, mapMutations, mapState } = helpers(namespaces.PROFILE);
const initializer = () => undefined;
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
const BASIC_SECTION_FIELDS = ["name", "username"];
const INSTRUCTOR_SECTION_FIELDS = [
  "shortbio",
  "longbio",
  "social_profiles",
  "elearning_profiles"
];

export default {
  data() {
    return {
      profile: {
        name: undefined,
        username: undefined,
        shortBio: undefined,
        longBio: undefined,
        public: false,
        country: undefined,
        instructor: false,
        socialProfiles: {},
        elearningProfiles: {}
      },
      platforms: {
        social: {
          ids: socialPlatformsReducer(initializer),
          urls: socialPlatformsReducer(initializer),
          open: false,
          available: SOCIAL_PLATFORMS,
          added: []
        },
        elearning: {
          ids: elearningPlatformsReducer(initializer),
          urls: elearningPlatformsReducer(initializer),
          open: false,
          available: ELEARNING_PLATFORMS,
          added: []
        }
      },
      countries: [],
      loading: true,
      sending: false,
      serverSideErrors: {
        basic: [],
        instructor: []
      },
      alert: {
        basic: {
          message: "",
          type: ""
        },
        instructor: {
          message: "",
          type: ""
        }
      }
    };
  },

  components: {
    SectionFrame,
    SocialMediaInput,
    TextInputField,
    TextAreaField
  },

  computed: {
    ...mapState(["loaded"])
  },

  watch: {
    // coming from /account-settings directly
    loaded: function() {
      this.init();
    },
    "$i18n.locale": function() {
      this.computeCountries();
    }
  },

  created() {
    this.computeCountries();
    // coming from / -> /account-setting redirection
    if (this.loaded) {
      this.init();
    }
  },

  methods: {
    camelCase,
    upperFirst,
    computeCountries() {
      this.countries = Object.entries(
        this.$t("iso3166_1_alpha2_codes")
      ).sort((a, b) => a[1].localeCompare(b[1]));
    },
    selectedPlatform(type) {
      return e => {
        if (e.target.value?.length) {
          this.addProfilePlatform(type)(e.target.value);
        }

        // this resets to "Add platform" option
        e.target.value = "";
      };
    },
    /**
     * ids is used to display what is typed
     * (regardless of the correctness)
     * urls is the final correct object
     */
    onInputPlatformID({ type, platform, id, url, valid }) {
      if (type && platform) {
        this.platforms[type].ids[platform] = id;
        this.platforms[type].urls[platform] = valid
          ? normalizeUrl(encodeURI(url))
          : undefined;
      }
    },
    addProfilePlatform(type) {
      return platform => {
        this.platforms[type].added = [...this.platforms[type].added, platform];

        this.platforms[type].available = without(
          [platform],
          this.platforms[type].available
        ).sort();
      };
    },
    removeProfilePlatform(type) {
      return platform => {
        this.platforms[type].ids = omit([platform], this.platforms[type].ids);
        this.platforms[type].urls = omit([platform], this.platforms[type].urls);

        this.platforms[type].added = without(
          [platform],
          this.platforms[type].added
        );

        this.platforms[type].available = [
          ...this.platforms[type].available,
          platform
        ].sort();
      };
    },
    ...mapMutations({ change: operations.UPDATE }),
    ...mapActions({ persist: operations.UPDATE }),
    init() {
      this.profile = clone(this.$store.state.profile);
      for (const type of ["social", "elearning"]) {
        for (const platform of Object.keys(
          this.profile[`${type}Profiles`]
        ).sort()) {
          if (
            Object.prototype.hasOwnProperty.call(
              this.profile[`${type}Profiles`],
              platform
            )
          ) {
            const url = this.profile[`${type}Profiles`][platform];
            const { id } = validations[platform]?.validator(url);

            if (id) {
              this.platforms[type].ids[platform] = id;
              this.platforms[type].urls[platform] = url;
              this.addProfilePlatform(type)(platform);
            }
          }
        }
      }

      this.loading = false;
    },
    submit(event) {
      event.preventDefault();
      this.serverSideErrors.basic = [];
      this.serverSideErrors.instructor = [];
      this.sending = true;

      const userAccountId = this.$session.getUserId();
      var payload = snakeCasedKeys({
        ...this.profile,
        socialProfiles: this.platforms.social.urls,
        elearningProfiles: this.platforms.elearning.urls
      });

      if (payload.country === "" || payload.country == null) {
        payload = omit(["country"], payload);
      }

      this.persist({ userAccountId, payload })
        .then(() => {
          this.sending = false;
          this.alert.basic = {
            message: this.$t(
              "user.sections.account_settings.profile.success_message"
            ),
            type: "success"
          };
          setTimeout(() => (this.alert.basic = {}), 5000);
          scroll(this.$refs["basic-frame"]);
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
          const errors = {
            [errorField]: errorHint?.platform
              ? { [errorHint.platform]: [errorMessage] }
              : [errorMessage]
          };

          if (errors.username || errors.name) {
            this.serverSideErrors.basic = errors;
            this.alert.basic = {
              message: errorMessage,
              type: "danger"
            };
            scroll(this.$refs["basic-frame"]);
          } else {
            this.serverSideErrors.instructor = errors;
            this.alert.instructor = {
              message: errorMessage,
              type: "danger"
            };
            scroll(this.$refs["instructor-frame"]);
          }
        });
    }
  }
};
</script>

<style lang="scss" scoped>
.user\:platform-remover {
  display: inline-block;
  cursor: pointer;
  margin-left: 0.25em;
  width: 1.125em;
  height: 1.125em;
  fill: var(--foreground-medium);
  &:hover {
    fill: var(--error);
  }
}
</style>
