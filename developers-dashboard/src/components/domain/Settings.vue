<template>
  <div class="container el:amx-Mt(2em) el:amx-Ml(2em)">
    <div class="row">
      <div class="col">
        <h4>Website Profile</h4>

        <div class="el:amx-Mt(1.5em)">
          <div class="el:m-form-field">
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label for="field">
                Logo
              </label>
              <div class="el:amx-Mt(0.25em)">
                <span class="el:amx-Fs(0.875em)">
                  Upload your logo in SVG (preferred), PNG or JPG.
                </span>
              </div>
            </div>

            <div class="el:amx-Mt(1em)">
              <img class="logo" v-if="logo.url" :src="logo.url" />
              <div v-else class="logo el:amx-Pos(r)">
                <div
                  class="el:amx-Pos(a) el:amx-C_fgM el:amx-Ta(c) el:amx-Tt(u) el:amx-Fs(0.5em)"
                  style="transform: translate(-50%, -50%); left: 50%; top: 50%;"
                >
                  Your logo
                </div>
              </div>
              <div class="el:amx-Mt(0.75em)" v-if="logo.url && logo.filename">
                <span class="el:amx-Fs(0.75em)" style="font-style: italic;">{{
                  decodeURI(logo.filename)
                }}</span>
              </div>
              <domain-logo-uploader
                ref="logoUploader"
                class="el:amx-Mt(0.5em)"
                @success="getCurrentProviderLogo"
              />
            </div>
          </div>

          <validation-observer
            v-if="currentProviderNameUpdatable"
            v-slot="{ invalid, changed }"
            tag="div"
            class="el:amx-Mt(1.5em)"
          >
            <div class="el:amx-Pb(1em)">
              <validation-provider
                #default="{ errors }"
                tag="div"
                name="provider_name"
                :rules="`required|max:30|providerNameFormat`"
              >
                <div
                  class="el:m-form-field el:amx-Mb(1em)"
                  :class="[
                    (errors.length > 0 || provider.error) && 'el:m-form-field--error',
                    provider.updating && 'el:m-form-field--disabled'
                  ]"
                >
                  <div class="el:m-form-field__label el:m-form-field__label--over">
                    <label for="field">
                      Name
                    </label>
                  </div>

                  <div
                    style="min-width:300px"
                    class="el:m-form-field__input el:m-form-field__input--medium"
                  >
                    <input
                      name="field"
                      style="width:300px"
                      type="text"
                      @input="
                        () => {
                          provider.reset();
                        }
                      "
                      v-model.trim="provider.name"
                      :placeholder="`Name that will appear on classpert.com`"
                    />
                    <icon
                      width="1.125em"
                      height="1.125em"
                      name="wrong"
                      class="el:m-form-field__input-icon el:amx-C_er"
                      v-if="errors.length > 0 || provider.error"
                    ></icon>
                    <icon
                      width="1.125em"
                      height="1.125em"
                      name="checked"
                      class="el:m-form-field__input-icon el:amx-Fi_pr"
                      v-if="provider.name && errors.length == 0 && !provider.error"
                    ></icon>
                  </div>
                  <button
                    type="submit"
                    class="btn btn--primary-border btn--sm el:amx-Ml(0.75em)"
                    :disabled="!changed || provider.updating || invalid"
                    :value="provider.updating ? 'Changing...' : 'Change'"
                    @click.prevent="updateProviderName"
                  >
                    {{ provider.updating ? "Changing..." : "Change" }}
                  </button>
                  <div
                    v-if="errors.length > 0 || provider.error"
                    class="el:amx-Mt(0.125em) el:amx-Mb(0.5em) el:amx-C_er"
                  >
                    <span class="el:amx-Fs(0.75em)">{{ errors[0] || provider.error }}</span>
                  </div>
                  <div v-else class="el:amx-Mt(0.25em) el:amx-Mb(0.5em) el:amx-D(f) el:amx-FxAi(c)">
                    <font-awesome-icon
                      icon="exclamation-triangle"
                      class="el:amx-Fs(0.75em) el:amx-C_se el:amx-Mr(0.25em)"
                      style="position:relative;top:-1px"
                    ></font-awesome-icon>
                    <span class="el:amx-Fs(0.75em)">You can only change this once </span>
                  </div>
                </div>
              </validation-provider>
            </div>
          </validation-observer>
          <div class="el:amx-Mt(1em) el:m-form-field" v-else>
            <div class="el:m-form-field__label el:m-form-field__label--over">
              <label for="field">
                Name
              </label>
              <div class="el:amx-Mt(0.25em)">
                <span class="el:amx-Fs(0.875em)">
                  {{ currentProvider.name }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="row el:amx-Mt(1em)">
      <div class="col">
        <div class="el:amx-Bob" />
      </div>
    </div>
    <div class="row el:amx-Mt(1em)">
      <div class="col">
        <h4>Privacy Settings</h4>
        <div class="el:amx-Mt(0.75em)">
          <div class="el:amx-Fs(0.75em)">
            <div class="el:amx-Fw(b)">Crawler Token</div>
            <div class="el:amx-Mt(0.25em) el:amx-D(f)">
              <span class="el:amx-Mr(1em)">{{ currentProviderCrawlerToken }}</span>
              <svg
                class="el:amx-Mr(0.25em) el:amx-Fi_pr"
                width="1em"
                height="1em"
                viewbox="0 0 24 24"
              >
                <use xlink:href="#icons-question" />
              </svg>
              <a
                class="el:cmx-content-link"
                href="/docs/troubleshooting/classpert-bot.html"
                target="_blank"
              >
                View documentation
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";
import Icon from "~external/Icon.vue";
import DomainLogoUploader from "~components/domain/LogoUploader.vue";
import Mixins from "~mixins";

const { mapActions: mapProviderLogoActions } = helpers(namespaces.PROVIDER_LOGO);

const { mapState: mapSharedState, mapGetters: mapSharedGetters } = helpers(namespaces.SHARED);

export default {
  mixins: [Mixins.Provider],
  data() {
    return {
      provider: {
        name: undefined,
        updating: false,
        error: undefined,
        reset() {
          this.updating = false;
          this.error = undefined;
        }
      },
      logo: {
        url: undefined
      }
    };
  },
  components: {
    Icon,
    DomainLogoUploader
  },
  mounted() {
    this.provider.name = this.currentProvider?.name;

    if (!this.logo.url) {
      this.getCurrentProviderLogo();
    }
  },
  computed: {
    ...mapSharedGetters([
      "domains",
      "currentDomain",
      "currentSitemap",
      "currentProvider",
      "currentProviderNameUpdatable",
      "currentProviderCrawler",
      "currentProviderCrawlerToken"
    ]),
    ...mapSharedState(["loaded", "loading", "error"])
  },
  methods: {
    ...mapProviderLogoActions({
      getProviderLogo: operations.GET,
      resetProviderLogo: operations.RESET
    }),
    getCurrentProviderLogo() {
      this.getProviderLogo({ providerId: this.currentProvider?.id })
        .then(({ fetch_url, file_content_type, file }) => {
          this.logo.url = fetch_url;
          this.logo.contentType = file_content_type;
          this.logo.filename = file;
        })
        .catch(() => {});
    },
    updateProviderName() {
      this.provider.update();
    }
  }
};
</script>

<style lang="scss" scoped>
.logo {
  display: block;
  width: 100px;
  height: 50px;
}

div.logo {
  background: #eee no-repeat center;
  background-size: cover;
}

img.logo {
  height: auto;
}
</style>
