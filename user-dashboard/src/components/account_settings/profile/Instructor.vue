<template>
  <validation-observer v-slot="{ invalid }" tag="div">
    <section-frame
      :alert="alert"
      :disabled="!local.instructor"
      class="el:amx-Mt(1.5em)"
    >
      <template #header>
        <div
          class="el:amx-Pos(r) el:amx-D(f) el:amx-Bob el:amx-Pl(2em) el:amx-Pr(2em) el:amx-Pt(1.5em) el:amx-Pb(1.5em)"
        >
          <span
            class="el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-Tt(u) el:amx-Ls(5%)"
            style="flex: 1"
            >{{
              $t(
                "user.sections.account_settings.profile.sections.instructor.title"
              )
            }}</span
          >
          <div class="el:amx-D(f) el:amx-FxAi(c)">
            <span class="el:amx-Fs(0.875em)">{{
              $t("user.forms.profile.instructor_field_label")
            }}</span>
            <label
              class="el:m-switch el:m-switch--flat-primary el:amx-Ml(0.5em)"
              for="instructor"
            >
              <input
                @click="
                  local.instructor = !local.instructor;
                  save({ instructor: local.instructor }, { alert: false });
                "
                :checked="local.instructor"
                type="checkbox"
                id="instructor"
              />
              <div class="el:m-switch__slider"></div>
            </label>
          </div>
        </div>
      </template>

      <form action="#">
        <div class="el:amx-Mb(2em)">
          <div class="el:amx-Mb(1em)">
            <span
              class="el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-C_fgM el:amx-Tt(u) el:amx-Ls(5%)"
              >{{
                $t(
                  "user.sections.account_settings.profile.sections.instructor.sections.about_me"
                )
              }}</span
            >
          </div>

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
            <text-input-field
              field="shortbio"
              :errors="[
                ...clientSideErrors,
                ...(serverSideErrors.shortbio || [])
              ]"
              :disabled="loading || sending"
              :label="$t('user.forms.profile.shortbio_field_label')"
              input-size="medium"
              :input-block="true"
              :input-placeholder="
                $t('user.forms.profile.shortbio_field_placeholder')
              "
              :value="local.shortBio"
              @input="v => (local.shortBio = v)"
            />
          </validation-provider>

          <text-area-field
            class="el:amx-Mb(1em)"
            field="longbio"
            :disabled="loading || sending"
            :label="$t('user.forms.profile.about_field_label')"
            :placeholder="$t('user.forms.profile.about_field_placeholder')"
            height="200px"
            :value="local.longBio"
            @input="v => (local.longBio = v)"
          >
          </text-area-field>
          <div class="el:m-form-field el:amx-Mb(1.5em)">
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label for="social_profiles">{{
                $t("user.forms.profile.country_field_label")
              }}</label>
            </div>

            <div class="el:m-select">
              <select v-model="local.country">
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

          <validation-provider
            #default="{ errors: clientSideErrors }"
            tag="div"
            class="el:amx-Mb(1em)"
            name="website"
            :rules="{
              url: true
            }"
          >
            <text-input-field
              class="el:amx-Mb(1em)"
              field="website"
              :errors="[
                ...clientSideErrors,
                ...(serverSideErrors.website || [])
              ]"
              :disabled="loading || sending"
              :label="$t('user.forms.profile.website_field_label')"
              input-size="medium"
              :input-block="true"
              :input-placeholder="
                $t('user.forms.profile.website_field_placeholder')
              "
              :value="local.website"
              @input="v => (local.website = v)"
              ><template #description>
                <p
                  class="el:amx-Fs(0.75em)"
                  v-html="
                    $t('user.forms.profile.website_field_about', {
                      index_tool: `<a class='el:cmx-content-link' href='https://listing.classpert.com' target='_blank'>${$t(
                        'dictionary.index_tool'
                      )}</a>`
                    })
                  "
                ></p>
              </template>
            </text-input-field>
          </validation-provider>
        </div>

        <div class="el:amx-Mb(2em)">
          <div class="el:amx-Mb(1em)">
            <span
              class="el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-C_fgM el:amx-Tt(u) el:amx-Ls(5%)"
              >{{
                $t(
                  "user.sections.account_settings.profile.sections.instructor.sections.social_media"
                )
              }}</span
            >

            <p class="el:amx-Fs(0.75em)">
              {{ $t("user.forms.profile.social_profiles_field_about") }}
            </p>
            <div class="el:m-form-field el:amx-Mt(1em)">
              <div class="el:m-select">
                <select
                  @change="e => selectedPlatform('social')(e)"
                  :disabled="platforms.social.available.length === 0"
                >
                  <option value="">{{
                    platforms.social.added.length > 1
                      ? $t(
                          "user.forms.profile.social_profiles_field_select_n",
                          { n: platforms.social.added.length }
                        )
                      : $t(
                          `user.forms.profile.social_profiles_field_select_${platforms.social.added.length}`
                        )
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

              <div
                :class="[index === 0 ? 'el:amx-Mt(1.5em)' : 'el:amx-Mt(1em)']"
                :key="platform"
                v-for="(platform, index) in platforms.social.added"
              >
                <social-media-input
                  :platform="platform"
                  :server-side-errors="
                    serverSideErrors.public_profile &&
                      serverSideErrors.public_profile[platform]
                  "
                  type="social"
                  :value="platforms.social.ids"
                  @input="onInputPlatformID"
                >
                  <template #control>
                    <svg
                      @click="removeProfilePlatform('social')(platform)"
                      :key="`${platform}-remove`"
                      class="user:platform-remover"
                    >
                      <use xlink:href="#icons-trash" />
                    </svg>
                  </template>
                </social-media-input>
              </div>
            </div>
          </div>
        </div>

        <div class="el:amx-Mb(2em)">
          <div class="el:amx-Mb(1em)">
            <span
              class="el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-C_fgM el:amx-Tt(u) el:amx-Ls(5%)"
              >{{
                $t(
                  "user.sections.account_settings.profile.sections.instructor.sections.elearning_platforms"
                )
              }}</span
            >
            <p class="el:amx-Fs(0.75em)">
              {{ $t("user.forms.profile.elearning_profiles_field_about") }}
            </p>
          </div>

          <div class="el:m-form-field el:amx-Mt(1em)">
            <div class="el:m-select">
              <select
                @change="e => selectedPlatform('elearning')(e)"
                :disabled="platforms.elearning.available.length === 0"
              >
                <option value="">{{
                  platforms.elearning.added.length > 1
                    ? $t(
                        "user.forms.profile.elearning_profiles_field_select_n",
                        { n: platforms.elearning.added.length }
                      )
                    : $t(
                        `user.forms.profile.elearning_profiles_field_select_${platforms.elearning.added.length}`
                      )
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

            <div
              :class="[index === 0 ? 'el:amx-Mt(1.5em)' : 'el:amx-Mt(1em)']"
              :key="platform"
              v-for="(platform, index) in platforms.elearning.added"
            >
              <social-media-input
                :platform="platform"
                :server-side-errors="
                  serverSideErrors.public_profile &&
                    serverSideErrors.public_profile[platform]
                "
                type="elearning"
                :value="platforms.elearning.ids"
                @input="onInputPlatformID"
              >
                <template #control>
                  <svg
                    @click="removeProfilePlatform('elearning')(platform)"
                    :key="`${platform}-remove`"
                    class="user:platform-remover"
                  >
                    <use xlink:href="#icons-trash" />
                  </svg>
                </template>
              </social-media-input>
            </div>
          </div>
        </div>

        <input
          :disabled="loading || sending || invalid"
          @click.prevent="submit"
          type="submit"
          class="el:amx-Mt(1.5em) el:amx-Mb(2em) btn btn--primary-flat btn--medium btn--block"
          :value="$t('user.forms.profile.submit')"
        />

        <div>
          <div class="el:amx-Mb(1em)">
            <span
              class="el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-C_fgM el:amx-Tt(u) el:amx-Ls(5%)"
              >{{
                $t(
                  "user.sections.account_settings.profile.sections.instructor.sections.privacy_settings"
                )
              }}</span
            >
          </div>

          <div class="el:amx-D(f)">
            <span class="el:amx-Fw(b) el:amx-Fs(0.875em)" style="flex: 1">{{
              $t("user.forms.profile.public_field_label")
            }}</span>
            <label class="el:m-switch el:m-switch--flat-primary" for="public">
              <input
                @click="
                  local.public = !local.public;
                  save({ public: local.public }, { alert: false });
                "
                :checked="local.public"
                type="checkbox"
                id="public"
              />
              <div class="el:m-switch__slider"></div>
            </label>
          </div>
        </div>
      </form>
    </section-frame>
  </validation-observer>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import { pick, without, omit } from "ramda";
import { camelCase, upperFirst } from "lodash";
import SectionFrame from "~components/SectionFrame.vue";
import SocialMediaInput from "~components/form_fields/SocialMediaInput.vue";
import TextAreaField from "~components/form_fields/TextArea.vue";
import TextInputField from "~components/form_fields/TextInput.vue";
import { snakeCasedKeys, normalizeUrl, safeJSONParse } from "~utils";
import { operations } from "~store/types";
import namespaces from "~store/namespaces";
import validations, {
  SOCIAL_PLATFORMS,
  ELEARNING_PLATFORMS,
  socialPlatformsReducer,
  elearningPlatformsReducer
} from "~validations/social";

const { mapActions } = helpers(namespaces.PROFILE);
const initializer = () => undefined;
const alertInitializer = () => ({ message: "", type: "" });
const FIELDS = {
  shortBio: undefined,
  longBio: undefined,
  public: false,
  country: undefined,
  website: undefined,
  instructor: false,
  socialProfiles: {},
  elearningProfiles: {}
};

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
    TextInputField,
    TextAreaField,
    SocialMediaInput
  },
  data() {
    return {
      local: { ...FIELDS },
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
      serverSideErrors: [],
      alert: alertInitializer(),
      sending: false
    };
  },
  created() {
    this.local = pick(Object.keys(FIELDS), this.profile);
    this.computeCountries();
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
  },
  watch: {
    profile(n) {
      this.local = pick(Object.keys(FIELDS), this.n);
    },
    "$i18n.locale": function() {
      this.computeCountries();
    }
  },
  methods: {
    camelCase,
    upperFirst,
    ...mapActions({ persist: operations.UPDATE }),
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
    save(payload, { alert = true } = {}) {
      const userAccountId = this.$session.getUserId();

      this.persist({ userAccountId, payload })
        .then(() => {
          this.sending = false;

          if (alert) {
            this.alert = {
              message: this.$t(
                "user.sections.account_settings.profile.success_message"
              ),
              type: "success"
            };
            setTimeout(() => (this.alert = alertInitializer()), 5000);
            this.$emit("success", { what: "instructor" });
          }
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
            [errorField]: errorHint?.platform
              ? { [errorHint.platform]: [errorMessage] }
              : [errorMessage]
          };

          if (alert) {
            this.alert = {
              message: errorMessage,
              type: "danger"
            };

            this.$emit("error", {
              what: "instructor",
              where: errorField,
              why: errorMessage
            });
          }
        });
    },
    submit(event) {
      event.preventDefault();
      this.serverSideErrors = [];
      this.sending = true;

      var payload = snakeCasedKeys({
        ...this.local,
        socialProfiles: this.platforms.social.urls,
        elearningProfiles: this.platforms.elearning.urls
      });

      if (payload.country === "" || payload.country == null) {
        payload = omit(["country"], payload);
      }

      this.save(payload);
    }
  }
};
</script>

<style lang="scss" scoped>
.user\:platform-remover {
  display: inline-block;
  cursor: pointer;
  width: 1.125em;
  height: 1.125em;
  fill: var(--foreground-medium);
  &:hover {
    fill: var(--error);
  }
}
</style>
