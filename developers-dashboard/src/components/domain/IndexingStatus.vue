<template>
  <div class="container el:amx-Mt(2em) el:amx-Ml(2em)">
    <div class="row">
      <div class="col">
        <h4>{{ currentDomain }}</h4>
        <div class="el:amx-Mt(0.5em)" v-if="currentProviderCrawlerReady">
          <button
            v-if="currentProviderCrawler.scheduled"
            type="button"
            class="btn btn--error-border btn--xs"
            :disabled="crawling.stopping"
            @click="stopCrawler"
          >
            {{ crawling.stopping ? "Disabling" : "Disable" }} indexing
          </button>
          <button
            v-else
            type="button"
            class="btn btn--primary-border btn--xs"
            :disabled="crawling.starting"
            @click="startCrawler"
          >
            {{ crawling.starting ? "Enabling" : "Enable" }} indexing
          </button>
          <div class="el:amx-Mt(0.5em)" v-if="this.crawling.error">
            <span class="el:amx-C_er el:amx-Fs(0.75em)">{{ this.crawling.error }}</span>
          </div>
          <div class="el:amx-Mt(0.5em)" v-else>
            <font-awesome-icon
              icon="info-circle"
              class="el:amx-Fs(0.75em) el:amx-C_pr"
              style="position:relative;top:-1px"
            ></font-awesome-icon>
            <span class="el:amx-Fs(0.75em)">
              Once enabled, Classpert Bot will visit your site twice a day. If everything is
              <a
                v-tooltip="{
                  content: 'Validate your Classpert JSON using the Debug Tool',
                  classes: ['el:amx-Fs(0.625em)']
                }"
                style="text-decoration: underline; cursor: pointer"
                >correct</a
              >, your courses will be automatically listed after 12 hours.
            </span>
          </div>
        </div>
      </div>
    </div>
    <div class="row el:amx-Mt(1.5em)">
      <div class="col">
        <div class="el:amx-Bob" />
      </div>
    </div>
    <div :class="['row el:amx-Mt(1.5em)', inlinedUrls.expanded && 'el:amx-Mb(2.5em)']">
      <div class="col">
        <validation-observer v-slot="{ invalid, errors: allErrors }" tag="div">
          <div class="el:m-form-field__label el:m-form-field__label--over">
            <label for="field">
              Sitemap
            </label>
            <div
              v-if="!currentSitemap && currentProviderCrawlerUrls.length === 0"
              class="el:amx-Mt(0.5em) el:amx-Mb(0.5em) el:amx-D(f) el:amx-FxAi(c)"
            >
              <font-awesome-icon
                icon="exclamation-triangle"
                class="el:amx-Fs(0.75em) el:amx-C_se el:amx-Mr(0.25em)"
                style="position:relative;top:-1px"
              ></font-awesome-icon>
              <span class="el:amx-Fs(0.75em)">
                You need to submit a sitemap link to be crawled
              </span>
            </div>
          </div>
          <validation-provider
            #default="{ errors, pristine }"
            tag="div"
            name="sitemap_url"
            :rules="{
              required: currentProviderCrawlerUrls.length === 0,
              url: true,
              urlPath: [currentDomain, false]
            }"
          >
            <div
              :style="{ width: pixels(styles.sitemap.input.width) }"
              class="el:amx-Pos(r) el:amx-D(f) el:m-form-field el:amx-Mb(1em)"
              :class="[
                !sitemap.validating &&
                  (errors.length > 0 || sitemap.error) &&
                  'el:m-form-field--error',
                sitemap.validating && 'el:m-form-field--disabled'
              ]"
            >
              <div
                style="flex: 1"
                class="el:amx-Mr(1em) el:m-form-field__input el:m-form-field__input--medium"
              >
                <input
                  name="field"
                  id="field"
                  type="text"
                  style="width: 100%"
                  v-model.trim="sitemap.value"
                  :placeholder="`e.g. https://${currentDomain}/path/to/sitemap.xml`"
                />
                <icon
                  width="1.125em"
                  height="1.125em"
                  name="wrong"
                  class="el:m-form-field__input-icon el:amx-C_er"
                  v-if="!sitemap.validating && (errors.length > 0 || sitemap.error)"
                ></icon>
                <icon
                  width="1.125em"
                  height="1.125em"
                  name="checked"
                  class="el:m-form-field__input-icon el:amx-Fi_pr"
                  v-if="
                    !sitemap.validating && sitemap.value && errors.length == 0 && !sitemap.error
                  "
                ></icon>
              </div>
              <button
                type="submit"
                style="flex: 0"
                class="btn btn--primary-flat btn--xs"
                :disabled="
                  sitemap.value === '' ||
                    (pristine && !currentSitemap) ||
                    sitemap.validating ||
                    (allErrors && allErrors.sitemap_url && allErrors.sitemap_url.length > 0)
                "
                :value="sitemap.validating ? 'Changing...' : 'Change'"
                @click.prevent="changeSitemap"
              >
                {{ sitemap.validating ? "Changing..." : "Change" }}
              </button>

              <div
                v-if="!sitemap.validating && (errors.length > 0 || sitemap.error)"
                class="el:amx-Pos(a) el:amx-Mb(0.5em) el:amx-C_er"
                style="bottom: -1.75em"
              >
                <span class="el:amx-Fs(0.75em)">{{ errors[0] || sitemap.error }}</span>
              </div>

              <div
                class="el:amx-Pos(a) el:amx-Mb(0.5em) el:amx-C_fgM"
                v-if="sitemap.validating && countdownTimer.status === 'started'"
                style="bottom: -1.75em"
              >
                <div class="el:amx-Fs(0.75em)">
                  Validating sitemap. This process may take a while, please wait (
                  <pre class="el:amx-D(ib) el:amx-Fs(0.875em)">{{ countdownTimerLabel }}</pre>
                  )
                </div>
              </div>
            </div>
          </validation-provider>
          <validation-provider
            #default="{ errors, pristine }"
            tag="div"
            class="inlined-urls el:amx-Mt(2em)"
            name="inlined_urls"
            :rules="{
              required: true,
              inlinedUrls: { max: 50, domain: currentDomain }
            }"
          >
            <div
              class="expander el:amx-Fs(0.875em)"
              @click="inlinedUrls.expanded = !inlinedUrls.expanded"
            >
              <svg
                class="el:m-label__icon el:amx-Mr(0.25em) el:amx-C_pr"
                :style="{ transform: `rotate(${inlinedUrls.expanded ? 0 : -90}deg)` }"
              >
                <use xlink:href="#icons-arrow-down" /></svg
              ><span
                >Don't have a sitemap?
                <a class="el:amx-C_pr">Submit your courses URLs manually</a></span
              >
            </div>
            <div v-if="inlinedUrls.expanded">
              <div class="el:amx-Mt(0.875em)">
                <span class="el:amx-Fs(0.875em)"
                  >Insert one course URL per line. Maximum allowed: 50 URLs</span
                >
              </div>
              <div
                class="el:amx-Pos(r) el:m-form-field el:amx-Mt(0.5em) el:amx-Mb(1em)"
                :style="{ width: pixels(styles.sitemap.input.width) }"
                :class="[
                  errors.length > 0 && 'el:m-form-field--error',
                  inlinedUrls.submitting && 'el:m-form-field--disabled'
                ]"
              >
                <div class="el:m-form-field__textarea">
                  <textarea
                    name="field"
                    v-model.trim="inlinedUrls.value"
                    :placeholder="
                      `https://${currentDomain}/path/to/course1\nhttps://${currentDomain}/path/to/course2\n...`
                    "
                    style="width: 100%; height:150px"
                  ></textarea>
                  <div class="el:amx-Mt(0.25em) el:amx-Pos(a)" style="width: 100%">
                    <button
                      type="submit"
                      style="right: 0"
                      class="el:amx-Pos(a) btn btn--primary-flat btn--xs"
                      :disabled="
                        (pristine && currentProviderCrawlerUrls.length === 0) ||
                          inlinedUrls.submitting ||
                          errors.length > 0 ||
                          (allErrors && allErrors.inlined_urls && allErrors.inlined_urls.length > 0)
                      "
                      :value="inlinedUrls.submitting ? 'Submitting...' : 'Submit'"
                      @click.prevent="addInlinedUrls"
                    >
                      {{ inlinedUrls.submitting ? "Submitting..." : "Submit" }}
                    </button>
                  </div>
                  <div
                    v-if="!inlinedUrls.submitting && (errors.length > 0 || inlinedUrls.error)"
                    class="el:amx-Mb(0.5em) el:amx-C_er"
                    :style="{ maxWidth: pixels(styles.sitemap.input.width - 150) }"
                  >
                    <span class="el:amx-Fs(0.75em)">
                      <span v-if="errors.length > 0" v-html="errors[0]" />
                      <span v-else v-html="inlinedUrls.error" />
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </validation-provider>
        </validation-observer>
      </div>
    </div>
    <div class="row el:amx-Mt(1.5em)">
      <div class="col">
        <div class="el:amx-Bob" />
      </div>
    </div>
    <div class="row el:amx-Mt(1.5em)">
      <div class="col">
        <h4>
          Log
        </h4>
        <log-output
          :log="logBuffer"
          :key="$route.fullPath"
          class="el:amx-Mt(1em)"
          style="min-height:200px"
        ></log-output>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import Icon from "~external/Icon.vue";
import namespaces from "~store/namespaces";
import Mixins from "~mixins";
import LogOutput from "~components/LogOutput.vue";
import { operations } from "~store/types";

const {
  mapState: mapSharedState,
  mapMutations: mapSharedMutations,
  mapGetters: mapSharedGetters
} = helpers(namespaces.SHARED);

export default {
  mixins: [Mixins.CountdownTimer, Mixins.Crawling, Mixins.Sitemap, Mixins.InlinedUrls],
  data() {
    return {
      styles: {
        sitemap: {
          input: {
            width: 540
          }
        }
      }
    };
  },
  components: {
    Icon,
    LogOutput
  },
  beforeDestroy() {
    this.crawling.stopPolling();
  },
  mounted() {
    this.sitemap.loadSitemap();
    this.inlinedUrls.loadUrls();
    this.crawling.startPolling();
  },
  computed: {
    ...mapSharedGetters([
      "domains",
      "currentDomain",
      "currentSitemap",
      "currentProviderCrawler",
      "currentProviderCrawlerUrls",
      "currentProviderCrawlerReady"
    ]),
    ...mapSharedState(["loaded", "loading", "error"]),
    logBuffer() {
      if (this.sitemap?.error && this.sitemap?.log?.buffer?.[0]) {
        return this.sitemap.log.buffer;
      } else {
        return this.crawling.log.buffer;
      }
    }
  },
  methods: {
    ...mapSharedMutations({
      updateShared: operations.UPDATE
    }),
    pixels(value) {
      return `${value}px`;
    },
    startCrawler() {
      this.crawling.start();
    },
    stopCrawler() {
      this.crawling.stop();
    },
    changeSitemap() {
      // if countdown expires, finish sitemap immediately
      this.countdownTimerStart(() => {
        this.sitemap.stop();
      });

      this.sitemap.update({
        onFinish: () => this.countdownTimerStop()
      });
    },
    addInlinedUrls() {
      this.inlinedUrls.update();
    }
  }
};
</script>

<style lang="scss" scoped>
.inlined-urls {
  .expander {
    cursor: pointer;

    a:hover {
      color: inherit !important;
    }
  }
}
</style>
