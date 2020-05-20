<template>
  <div class="el:amx-Pos(r)">
    <div class="el:amx-Pos(a)" style="width:100%;">
      <progress-bar v-if="debugTool.running" :indeterminate="true" />
    </div>
    <div class="container">
      <div class="row">
        <div class="col px-0">
          <validation-observer v-slot="{ invalid }" tag="div" class="el:amx-Pt(2.5em)">
            <div class="row">
              <div class="col-12">
                <div class="el:amx-Pb(1em)">
                  <validation-provider
                    #default="{ errors }"
                    tag="div"
                    name="course_url"
                    :rules="{
                      required: true,
                      url: true,
                      domainIncludedIn: [domains]
                    }"
                  >
                    <div
                      class="el:m-form-field el:amx-Mb(1em)"
                      :class="[
                        errors.length > 0 && 'el:m-form-field--error',
                        debugTool.running && 'el:m-form-field--disabled'
                      ]"
                    >
                      <div class="el:m-form-field__label el:m-form-field__label--over">
                        <label for="course-url" style="font-size: 1.5em">
                          Classpert JSON Validator
                        </label>
                        <div class="el:amx-Mt(0.5em)">
                          <span class="el:amx-Fs(0.875em)"
                            >Insert the URL of your course page below to check for errors on the
                            Classpert JSON. <br />If no errors were found, you'll get to see how
                            your course will show up on Classpert!</span
                          >
                        </div>
                      </div>
                      <div class="el:amx-Mt(1em) el:amx-D(f) el:amx-FxJc(sb)">
                        <div
                          class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block el:amx-Mr(2em)"
                          style="flex: 1"
                        >
                          <input
                            name="course-url"
                            id="course-url"
                            type="text"
                            :placeholder="`e.g. https://yourdomain.com/path/to/course/page`"
                            v-model.trim="debugTool.url"
                          />
                          <icon
                            width="1.125em"
                            height="1.125em"
                            name="wrong"
                            class="el:m-form-field__input-icon el:amx-C_er"
                            v-if="errors.length > 0"
                          ></icon>
                          <icon
                            width="1.125em"
                            height="1.125em"
                            name="checked"
                            class="el:m-form-field__input-icon el:amx-Fi_pr"
                            v-if="debugTool.url && errors.length == 0"
                          ></icon>
                        </div>
                        <button
                          type="submit"
                          class="btn btn--primary-flat btn--sm"
                          :disabled="debugTool.running || invalid"
                          :value="debugTool.running ? 'Debugging...' : 'Debug'"
                          @click.prevent="debugCourseUrl"
                        >
                          {{ debugTool.running ? "Debugging..." : "Debug" }}
                        </button>
                      </div>
                      <div v-if="errors.length > 0" class="el:amx-Mt(0.25em) el:amx-C_er">
                        <span class="el:amx-Fs(0.75em)">{{ errors[0] }}</span>
                      </div>
                      <div
                        class="el:amx-Mt(0.25em) el:amx-C_fgM"
                        v-if="debugTool.running && countdownTimer.status === 'started'"
                      >
                        <div class="el:amx-Fs(0.75em)">
                          Running debug tool. This process may take a while, please wait (
                          <pre class="el:amx-D(ib) el:amx-Fs(0.875em)">{{
                            countdownTimerLabel
                          }}</pre>
                          )
                        </div>
                      </div>
                    </div>
                  </validation-provider>
                </div>
              </div>
            </div>
            <div>
              <div class="row">
                <div class="col-12">
                  <h2 class="el:amx-Mb(0.5em)" v-if="true || debugTool.log.started">
                    Log
                  </h2>
                  <log-output
                    :log="debugTool.log.buffer"
                    :key="$route.fullPath"
                    class="el:amx-Mt(1.5em)"
                    style="min-height:200px"
                  ></log-output>
                </div>
              </div>
            </div>
          </validation-observer>
        </div>
      </div>
    </div>
    <div
      v-if="debugTool.previewCourse && !debugTool.error && debugTool.ready"
      class="el:amx-Bc_bg el:amx-Mt(1em)"
    >
      <div class="container">
        <div class="row">
          <div class="col-12">
            <h3 class="el:amx-Bob el:amx-Mt(1em) el:amx-Pb(0.25em) el:amx-Mb(1em)">
              Card
            </h3>

            <div class="el:amx-Mb(2em)">
              <h5 class="el:amx-Mb(0.5em)">Desktop</h5>
              <div class="row">
                <div class="d-md-none">
                  <div class="el:amx-Pt(1em) el:amx-Pb(1em) el:amx-Pr(1em) el:amx-Pl(1em)">
                    Desktop Card components are used when viewport is at least 768px wide
                  </div>
                </div>
                <div class="d-sm-none d-md-block col-12 col-lg-9">
                  <course-card-desktop
                    class="el:amx-Bc_su el:amx-Pt(1em) el:amx-Pb(1em) el:amx-Pr(1em) el:amx-Pl(1em)"
                    :course="debugTool.previewCourse.__indexed_json__"
                  ></course-card-desktop>
                </div>
              </div>
            </div>

            <div class="el:amx-Mb(3em)">
              <h5 class="el:amx-Mb(0.5em)">Mobile</h5>
              <course-card-mobile
                class="el:amx-Bc_su el:amx-Pt(1em) el:amx-Pb(1em) el:amx-Pr(1em) el:amx-Pl(1em)"
                :course="debugTool.previewCourse.__indexed_json__"
                style="min-width:300px;max-width:30%;"
              >
              </course-card-mobile>
            </div>

            <h3 class="el:amx-Bob el:amx-Pb(0.25em) el:amx-Mb(1em)">
              Page
            </h3>

            <div class="el:amx-D(f) el:amx-FxJc(sb)">
              <div class="el:amx-Mb(2em) el:amx-D(ib)" style="max-width:45%">
                <div class="el:amx-D(f) el:amx-FxJc(sb)">
                  <h5 class="el:amx-Mb(1em)">Desktop</h5>
                  <a :href="previewCourseUrl" target="_blank" class="el:amx-C_pr el:amx-Fw(b)">
                    <span class="el:amx-D(ib)">Open page</span>
                    <icon
                      width="0.75rem"
                      height="0.75rem"
                      :transform="'rotate(-90deg)'"
                      name="arrow-down"
                      class="el:amx-Fi_pr"
                    ></icon>
                  </a>
                </div>
                <a class="overlayed-image" :href="previewCourseUrl" target="_blank">
                  <div class="overlayed-image__cta">
                    <a :href="previewCourseUrl" target="_blank">Open page in new tab</a>
                  </div>
                  <img
                    :src="previewCourseDesktopScreenshotUrl"
                    style="max-width:100%;outline:1px solid var(--foreground)"
                  />
                </a>
              </div>

              <div class="el:amx-Mb(3em) el:amx-D(ib)" style="max-width:45%">
                <h5 class="el:amx-Mb(1em)">Mobile</h5>
                <img
                  :src="previewCourseMobileScreenshotUrl"
                  style="max-width:100%;outline:1px solid var(--foreground)"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import normalizeUrl from "normalize-url";
import { createNamespacedHelpers as helpers } from "vuex";
import { domain } from "~utils";
import env from "~config/environment";
import CourseCardDesktop from "~external/CourseCardDesktop.vue";
import CourseCardMobile from "~external/CourseCardMobile.vue";
import Icon from "~external/Icon.vue";
import ProgressBar from "~external/ProgressBar.vue";
import LogOutput from "~components/LogOutput.vue";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";
import Mixins from "~mixins";

const { mapActions: mapPreviewCourseActions } = helpers(namespaces.PREVIEW_COURSE);

const { mapState: mapSharedState, mapGetters: mapSharedGetters } = helpers(namespaces.SHARED);

export default {
  data() {
    return {};
  },
  mixins: [Mixins.CountdownTimer, Mixins.DebugTool],
  components: {
    CourseCardDesktop,
    CourseCardMobile,
    Icon,
    ProgressBar,
    LogOutput
  },
  computed: {
    ...mapSharedGetters(["domains", "domainByDomain"]),
    ...mapSharedState(["loaded", "loading", "error"]),
    currentProviderCrawler() {
      const currentDomain = this.domainByDomain(domain(this.debugTool.url));

      return currentDomain?.provider_crawler;
    },
    previewCourseUrl() {
      if (this.debugTool.previewCourse) {
        return normalizeUrl(`${env.previewCourseEndpoint}/${this.debugTool.previewCourse.id}`);
      } else {
        return null;
      }
    },
    previewCourseMobileScreenshotUrl() {
      let image;

      if (this.debugTool.previewCourse?.preview_course_images) {
        image = this.debugTool.previewCourse.preview_course_images.filter(
          image => image.kind === "mobile"
        )[0];
      } else {
        return null;
      }

      if (image) {
        // eslint-disable-next-line no-undef
        return normalizeUrl(`${env.previewCourseScreenshotEndpoint}/${image.file}`);
      } else {
        return null;
      }
    },
    previewCourseDesktopScreenshotUrl() {
      let image;

      if (this.debugTool.previewCourse?.preview_course_images) {
        image = this.debugTool.previewCourse.preview_course_images.filter(
          image => image.kind === "desktop"
        )[0];
      } else {
        return null;
      }

      if (image) {
        // eslint-disable-next-line no-undef
        return normalizeUrl(`${env.previewCourseScreenshotEndpoint}/${image.file}`);
      } else {
        return null;
      }
    }
  },
  methods: {
    ...mapPreviewCourseActions({
      createPreviewCourse: operations.CREATE,
      getPreviewCourse: operations.GET
    }),
    debugCourseUrl() {
      this.debugTool.reset();
      this.debugTool.running = true;
      this.debugTool.log.poll(() => this.debugTool.finishTime, this.getLogData);

      // if countdown expires, finish debug tool immediately
      this.countdownTimerStart(() => {
        this.debugTool.stop();
      });

      this.createPreviewCourse({
        providerCrawlerId: this.currentProviderCrawler.id,
        id: this.$uuid(),
        courseUrl: normalizeUrl(this.debugTool.url, {
          defaultProtocol: "https:"
        })
      }).then(
        previewCourse => {
          this.debugTool.previewCourse = previewCourse;
          this.pollOnPreviewCourseStatus();
        },
        error => {
          this.debugTool.failed(null, error);
          this.countdownTimerStop();
        }
      );
    },
    pollOnPreviewCourseStatus() {
      this.debugTool.interval = setInterval(() => {
        this.getPreviewCourse({
          id: this.debugTool.previewCourse.id
        }).then(
          previewCourse => {
            if (previewCourse.status === "succeeded") {
              this.debugTool.success(previewCourse);
              this.countdownTimerStop();
            }

            if (previewCourse.status === "failed") {
              this.debugTool.failed(previewCourse, null);
              this.countdownTimerStop();
            }
          },
          error => {
            this.debugTool.failed(null, error);
            this.countdownTimerStop();
          }
        );
      }, this.debugTool.timeout);
    },
    getLogData() {
      if (this.debugTool.previewCourse) {
        this.$logs
          .get(`/logs/${this.debugTool.previewCourse.id}.json`)
          .then(({ data }) => {
            if (data && data.length) {
              this.debugTool.log.buffer = data;
            }
          })
          .catch(() => {});
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.el\:o-hcard,
.el-mb\:o-hcard {
  &::v-deep .clspt\:course-provider__logo {
    padding: 0 !important;
  }
}

.overlayed-image {
  display: block;
  position: relative;

  .overlayed-image__cta {
    position: absolute;
    display: none;
    right: 50%;
    top: 10%;
    border: 1px solid white;
    font-weight: bold;
    transform: translateX(50%);
    padding: 1em;
    text-transform: uppercase;
    border-radius: 0.25em;
    z-index: 1;
    a {
      color: white;
    }
  }

  &:after {
    position: absolute;
    content: "\A";
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    background: rgba(0, 0, 0, 0.6);
    opacity: 0;
  }

  &:hover:after {
    opacity: 1;
  }

  &:hover {
    .overlayed-image__cta {
      display: block;
    }
  }
}
</style>
