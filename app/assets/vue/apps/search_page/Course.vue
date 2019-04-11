<template>
  <div :id='course.url_id' class='c-hcard(2.0) mx-D(fx) mx-FxWp(w) mx-FxFd(col)@>desktop' :class="{ 'js-expanded' : expanded }">
    <!-- Video  -->
    <div class='c-hcard(2.0)__video-preview mx-Mr-0d5@phone mx-Mr-0d5@tablet mx-Mr-1@>desktop mx-Fx(100%)@>desktop mx-FxOrd(1)'>
      <div class='c-video'>
        <template v-if="course.video">
          <div :class="{ 'mx-D(n) ': videoComponent }">
            <div class='c-video__bg-img' :style="{ 'background-image': course.video.thumbnail_url && `url(${course.video.thumbnail_url})` }"></div>
            <div class="c-video__mask"></div>
            <div @click="fetchVideo" class='c-video__content' :class="{'mx-D(n)': videoClicked}">
              <svg class='c-video__icon c-video__icon--small@<tablet-half' viewBox='0 0 50 50'>
                <use :xlink:href="playIcon"></use>
              </svg>
              <span class='c-video__subtitle mx-Mt-0d125@<tablet-half mx-D(n)@>tablet-half'>{{ $t('dictionary.preview_this_course.short') }}</span>
              <span class='c-video__subtitle mx-D(n)@<tablet-half'>{{ $t('dictionary.preview_this_course.long') }}</span>
            </div>
          </div>
          <component :is="videoComponent" :url="videoUrl" :mode="videoMode"></component>
        </template>
        <template v-else>
          <div class='c-video__content'>
            <svg class='c-video__icon c-video__icon--small@<tablet-half' viewBox='0 0 50 50'>
              <use :xlink:href="noVideoIcon"></use>
            </svg>
            <span class='c-video__subtitle mx-Mt-0d125@<tablet-half mx-D(n)@>tablet-half'>{{ $t('dictionary.preview_not_available.short') }}</span>
            <span class='c-video__subtitle mx-D(n)@<tablet-half'>{{ $t('dictionary.preview_not_available.long') }}</span>
          </div>
        </template>
      </div>
    </div>
    <!-- Title -->
    <div class='c-hcard(2.0)__details-group mx-D(fx) mx-FxFd(col) mx-Fx(70%) mx-Fx(50%)@>desktop mx-FxOrd(2)'>
      <div class='mx-Mr-1@>desktop'>
        <div class='mx-D(fx) mx-FxJc(sb)'>
          <div class='c-hcard(2.0)__provider mx-Fs-0d875@>tablet'>
            <span class='c-label'>
              <svg class='c-label__icon c-label__icon--circled-border c-label__icon--px-based'>
                <use :xlink:href="logo"></use>
              </svg>
              <span class='c-label__text'>
                <span class='c-tags c-tags--gray'>
                  {{ course.provider_name }}
                </span>
              </span>
            </span>
          </div>
        </div>
        <div class='c-hcard(2.0)__title-box'>
          <a :href='course.id' target='_blank' :title='course.name' class='c-hcard(2.0)__title'>
            {{ course.name }}
          </a>
        </div>
      </div>
    </div>
    <!-- Price -->
    <div class='c-hcard(2.0)__details-expander-group mx-D(fx) mx-FxAi(fs) mx-FxFd(col) mx-Bc(white) mx-Fx(100%) mx-Fx(50%)@>desktop mx-FxOrd(3) mx-FxOrd(4)@>desktop'>
      <div class="c-hcard(2.0)__price mx-FxOrd(1) mx-FxOrd(2)@>desktop">
        {{ course.free_content ? "free" : `$${formattedPrice}` }}
      </div>
      <template v-if="course.price > 0">
        <div class="c-hcard(2.0)__price-trial-details mx-FxOrd(2) mx-FxOrd(1)@>desktop mx-D(n)@phone mx-D(n)@tablet">
          <template v-if="course.subscription_type">
            <span class="mx-Tt(u) mx-Fs-0d625">
              {{ $t(`datetime.distance_in_words.x_${course.trial_period.unit}.${course.trial_period.value == 1 ? 'one' : 'other'}`, {count: course.trial_period.value}) }} TRIAL
            </span>
          </template>
        </div>
        <template v-if="course.subscription_type && course.has_free_trial">
          <div class="c-hcard(2.0)__price-subscription-details mx-FxOrd(3) mx-D(n)@phone mx-D(n)@tablet mx-Mt-0d25@>desktop">
            <span :data-tippy="$t('components.card.subscription_tip', {period: $t(`datetime.distance_in_words.x_${course.trial_period.unit}`, { count: course.trial_period.value })})" class='c-label mx-Fs-0d625 mx-Mt-0d25'>
              <svg class='c-label__icon'>
                <use :xlink:href="renewIcon"></use>
              </svg>
              <span class='c-label__text'>
                {{ $t(`dictionary.subscription_period.${course.subscription_period.unit}`) }}
              </span>
            </span>
          </div>
        </template>
        <template v-if="false && course.free_content && course.paid_content">
          <div class="c-hcard(2.0)__price-subscription-details mx-FxOrd(3) mx-D(n)@phone mx-D(n)@tablet mx-Mt-0d25@>desktop">
            <span :data-tippy="$t('components.card.subscription_tip', {period: $t(`datetime.distance_in_words.x_${course.trial_period.unit}`, { count: course.trial_period.value })})" class='c-label mx-Fs-0d625 mx-Mt-0d25'>
              <svg class='c-label__icon'>
                <use :xlink:href="currencyIcon"></use>
              </svg>
              <span class='c-label__text'>
                {{ $t('dictionary.extra_paid_content') }}
              </span>
            </span>
          </div>
        </template>
      </template>
      <div class="mx-FxOrd(5) mx-D(n)@>desktop c-hcard(2.0)__details-expander c-hcard(2.0)--shown-on-collapse" @click="expanded = true">
        {{ $t('dictionary.details.show') }}
      </div>
      <div class="mx-FxOrd(5) mx-D(n)@>desktop c-hcard(2.0)__details-expander c-hcard(2.0)--shown-on-expand" @click="expanded = false">
        {{ $t('dictionary.details.hide') }}
      </div>
    </div>
    <!-- Details -->
    <div class='c-hcard(2.0)__details-group mx-Pos(r) mx-Fx(100%) mx-Fx(50%)@>desktop mx-FxOrd(4) mx-FxOrd(3)@>desktop mx-Fs-0d75@phone mx-Fs-0d75@tablet'>
      <div class='mx-Mr-1@>desktop'>
        <div class='c-hcard(2.0)__details mx-D(fx) mx-FxFd(col)'>
          <div class='mx-FxFd(col) c-hcard(2.0)--flexed-on-expand'>
            <template v-if="course.price > 0">
              <div class="c-hcard(2.0)__price-details mx-D(fx) mx-FxFd(col) mx-Mt-0d625 mx-D(n)@>desktop">
                <template v-if="course.subscription_type">
                  <span class="mx-Tt(u) mx-Fs-0d875">
                    {{ $t(`datetime.distance_in_words.x_${course.trial_period.unit}.${course.trial_period.value == 1 ? 'one' : 'other'}`, {count: course.trial_period.value}) }} TRIAL
                  </span>
                </template>
                <template v-if="course.subscription_type && course.has_free_trial">
                  <div class="c-hcard(2.0)__price-subscription-details mx-FxOrd(3) mx-D(n)@phone mx-D(n)@tablet mx-Mt-0d25@>desktop">
                    <span :data-tippy="$t('components.card.subscription_tip', {period: $t(`datetime.distance_in_words.x_${course.trial_period.unit}`, { count: course.trial_period.value })})" class='c-label mx-Fs-0d875 mx-Mt-0d25'>
                      <svg class='c-label__icon'>
                        <use :xlink:href="renewIcon"></use>
                      </svg>
                      <span class='c-label__text'>
                        {{ $t(`dictionary.subscription_period.${course.subscription_period.unit}`) }}
                      </span>
                    </span>
                  </div>
                </template>
                <template v-if="false && course.free_content && course.paid_content">
                  <div class="c-hcard(2.0)__price-subscription-details mx-FxOrd(3) mx-D(n)@phone mx-D(n)@tablet mx-Mt-0d25@>desktop">
                    <span :data-tippy="$t('components.card.subscription_tip', {period: $t(`datetime.distance_in_words.x_${course.trial_period.unit}`, { count: course.trial_period.value })})" class='c-label mx-Fs-0d625 mx-Mt-0d25'>
                      <svg class='c-label__icon'>
                        <use :xlink:href="currencyIcon"></use>
                      </svg>
                      <span class='c-label__text'>
                        {{ $t('dictionary.extra_paid_content') }}
                      </span>
                    </span>
                  </div>
                </template>
              </div>
            </template>
            <!-- Certificate -->
            <div v-if="course.certificate" class='c-hcard(2.0)__certificate-details mx-D(n)@>desktop mx-Fs-1d125 mx-Mt-0d75'>
              {{ $t(`dictionary.certificate.${course.certificate.type}`, {price: course.certificate.price})  }}
            </div>
            <!-- Localization Details Desktop and TV -->
            <div class='mx-D(fx) mx-D(n)@phone mx-D(n)@tablet c-hcard(2.0)__localization-details mx-Fs-0d75'>
              <div v-if="course.certificate" class='c-hcard(2.0)__certificate-details mx-Fs-1d125'>
                {{ $t(`dictionary.certificate.${course.certificate.type}`, {price: course.certificate.price})  }}
              </div>
              <ul class='c-list c-list--unstyled'>
                <li class='mx-F(l) mx-D(ib)'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-40%'>
                      <use :xlink:href="audioIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--uppercase mx-Fs-1d125'>
                      {{ course.root_audio.join(",") }}
                    </span>
                  </span>
                </li>
                <li class='mx-D(ib)'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-40%'>
                      <use :xlink:href="subtitleIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--uppercase mx-Fs-1d125'>
                      {{ course.root_subtitles.length && course.root_subtitles.slice(0,1).join(",") }}
                    </span>
                  </span>
                </li>
              </ul>
            </div>
            <!-- Details Phone and Tablet -->
            <div class='mx-D(fx) mx-D(n)@>desktop c-hcard(2.0)__course-details mx-Mt-0d75 mx-Mb-0d75'>
              <ul class='mx-Wd(50%) c-list c-list--unstyled'>
                <li class='c-hcard(2.0)__course-details-pacing'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="velocimeterIcon"></use>
                    </svg>
                    <span class='c-label__text'>
                      {{ course.pace ? $t(`dictionary.pace.${course.pace}`) : $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>

                <li class='c-hcard(2.0)__course-details-effort'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="clockIcon"></use>
                    </svg>
                    <span class='c-label__text'>
                      {{ course.effort? $t(`datetime.distance_in_words.x_hours.${course.effort == 1 ? 'one' : 'other'}`, {count: course.effort}) : $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>

                <li class='c-hcard(2.0)__course-details-instructor'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="userAndMonitorIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--truncated c-label__text--unwrapped'>
                      {{ course.instructors.length ? course.instructors.map(i => i.name).join(",") : $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>
              </ul>
              <ul class='mx-Wd(50%) c-list c-list--unstyled'>
                <li class='c-hcard(2.0)__course-details-level'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="levelIcon"></use>
                    </svg>
                    <span class='c-label__text'>
                      <template v-if="course.level.length">
                        {{ course.level.map(l => $t(`dictionary.levels.${l}`)).join(",")  }}
                      </template>
                      <template v-else>
                        {{ $t("dictionary.not_available") }}
                      </template>
                    </span>
                  </span>
                </li>

                <li class='c-hcard(2.0)__course-details-institution'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="institutionIcon"></use>
                    </svg>
                    <span v-if="course.offered_by.length" class='c-label__text c-label__text--truncated c-label__text--unwrapped'>
                      {{ course.offered_by.map(i => i.name).join(",") }}
                    </span>
                    <span v-else class='c-label__text'>
                      {{ $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>
              </ul>
            </div>
            <!-- Details Desktop and TV -->
            <div class='mx-D(fx) mx-Fs-0d75 mx-D(n)@phone mx-D(n)@tablet c-hcard(2.0)__course-details mx-Mt-0d5'>
              <ul class='mx-Fx(33%) mx-mWd(33%) c-list c-list--unstyled'>
                <li class='c-hcard(2.0)__course-details-pacing'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="velocimeterIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--truncated'>
                      {{ course.pace ? $t(`dictionary.pace.${course.pace}`) : $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>

                <li class='c-hcard(2.0)__course-details-effort'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="clockIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--truncated'>
                      {{ course.effort? $t(`datetime.distance_in_words.x_hours.${course.effort == 1 ? 'one' : 'other'}`, {count: course.effort}) : $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>
              </ul>
              <ul class='mx-Fx(33%) mx-mWd(33%) c-list c-list--unstyled'>
                <li class='c-hcard(2.0)__course-details-instructor'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="userAndMonitorIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--truncated'>
                      {{ course.instructors.length ? course.instructors.map(i => i.name).join(",") : $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>

                <li class='c-hcard(2.0)__course-details-level'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="levelIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--truncated'>
                      <template v-if="course.level.length">
                        {{ course.level.map(l => $t(`dictionary.levels.${l}`)).join(",")  }}
                      </template>
                      <template v-else>
                        {{ $t("dictionary.not_available") }}
                      </template>
                    </span>
                  </span>
                </li>
              </ul>

              <ul class='c-list c-list--unstyled'>
                <li class='c-hcard(2.0)__course-details-institution'>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="institutionIcon"></use>
                    </svg>
                    <span v-if="course.offered_by.length" class='c-label__text c-label__text--truncated c-label__text--unwrapped'>
                      {{ course.offered_by.map(i => i.name).join(",") }}
                    </span>
                    <span v-else class='c-label__text'>
                      {{ $t("dictionary.not_available") }}
                    </span>
                  </span>
                </li>
              </ul>
            </div>
            <!-- Localization Details Phone and Tablet -->
            <div class='mx-D(n)@>desktop c-hcard(2.0)__localization-details'>
              <ul class='c-list c-list--unstyled'>
                <li>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="audioIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--uppercase c-label__text--bottom'>
                      {{ course.root_audio.join(",") }}
                    </span>
                  </span>
                </li>
                <li>
                  <span class='c-label'>
                    <svg class='c-label__icon c-label__icon--inc-60%'>
                      <use :xlink:href="subtitleIcon"></use>
                    </svg>
                    <span class='c-label__text c-label__text--uppercase c-label__text--bottom'>
                      {{ course.root_subtitles.length && course.root_subtitles.slice(0,5).join(",") }}
                    </span>
                  </span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Action -->
    <div class='c-hcard(2.0)__action-group mx-D(fx) mx-FxFd(col) mx-FxJc(sb) mx-FxAi(c) mx-Fx(50%) mx-FxOrd(5)'>
      <div class='c-hcard(2.0)__call-to-action'>
        <a target='_blank' :href='course.gateway_path' class='btn btn--tiny@phone btn--rounded btn--blue-flat btn--expandable@>desktop'>
          {{ $t('dictionary.go_to_course') }}
        </a>
      </div>
      <!-- <div class='c-hcard(2.0)__syllabus mx-D(b)@phone mx-D(b)@tablet'>
        <template v-if="false">
          <syllabus :cssClasses="modalCssClasses" :course="syllabusCourse" :name="modalName" height="80%">
            <template #caller>
              {{ $t('dictionary.syllabus.view') }}
            </template>
            <template #dismisser>
              <span></span>
            </template>
            <template #header="{ course }">
              <div class='o-syllabus__provider'>
                <span class='c-label'>
                  <svg class='c-label__icon c-label__icon--circled-border'>
                    <use :xlink:href="course.provider_logo"></use>
                  </svg>
                  <span class='c-label__text'>
                    <span class='c-tags c-tags--gray'>
                      {{ course.provider_name }}
                    </span>
                  </span>
                </span>
              </div>
            </template>
            <template #body="{ course }">
              <h5 class='o-syllabus__course-name'>{{ course.name }}</h5>
              <p class='o-syllabus__course-description' v-html='course.description'></p>
              <span class='o-syllabus__course-syllabus-header'>
                {{ $t('dictionary.syllabus.header') }}
              </span>
              <div class='o-syllabus__course-syllabus' v-html='course.syllabus' v-bar></div>
            </template>
          </syllabus>
        </template>
      </div> -->
    </div>
  </div>
</template>

<script>
import _ from 'lodash';
import marked from 'marked';
import { slugify } from 'transliteration';
import Syllabus from 'blocks/src/vue/Syllabus.vue';
import EmbeddedVideo from './EmbeddedVideo.vue';

export default {

  props: {
    course: {
      type: Object,
      required: true
    },
  },

  data () {
    return {
      expanded: false,
      mdRenderer: new marked.Renderer(),
      videoComponent: null,
      videoClicked: false,
      videoUrl: '',
      videoMode: '',
      modalCssClasses: {
        rootClass: ["o-syllabus"],
        callerClass: ["o-syllabus__caller"],
        wrapperClass: ["o-syllabus__wrapper"],
        dismisserClass: ["o-syllabus__dismisser"],
        bodyClass: ["o-syllabus__body"]
      }
    }
  },

  components: {
    syllabus: Syllabus,
    embeddedVideo: EmbeddedVideo
  },

  methods: {
    fetchVideo: function() {
      this.videoClicked = true;

      fetch(`/videos/${this.course.id}`).then((response) => {
        response.json().then((json) => {
          this.videoUrl       = json.url;
          this.videoMode      = json.mode;
          this.videoComponent = "embedded-video";
        })
      });
    }
  },

  created() {
    this.mdRenderer.heading = () => ``;
    this.mdRenderer.list    = (body, ordered) => {
      let type = ordered ? 'ol' : 'ul';
      return `<${type}>\n${body}</${type}>\n`;
    };
  },

  computed: {

    playIcon () {
      return `${window.iconsLibPath}#play`
    },

    noVideoIcon () {
      return `${window.iconsLibPath}#no-video`
    },

    audioIcon () {
      return `${window.iconsLibPath}#audio`
    },

    subtitleIcon () {
      return `${window.iconsLibPath}#subtitle`
    },

    currencyIcon() {
      return `${window.iconsLibPath}#currency`
    },

    renewIcon () {
      return `${window.iconsLibPath}#renew`
    },

    subtitleIcon () {
      return `${window.iconsLibPath}#subtitle`;
    },

    velocimeterIcon () {
      return `${window.iconsLibPath}#velocimeter`;
    },

    clockIcon () {
      return `${window.iconsLibPath}#clock`;
    },

    userIcon () {
      return `${window.iconsLibPath}#user`;
    },

    userAndMonitorIcon () {
      return `${window.iconsLibPath}#user-and-monitor`;
    },

    levelIcon () {
      return `${window.iconsLibPath}#level`;
    },

    institutionIcon () {
      return `${window.iconsLibPath}#institution`;
    },

    logo () {
      return `${window.providersLibPath}#${slugify(this.course.provider_name)}`
    },

    price () {
      return parseFloat(this.course.price)
    },

    formattedPrice() {
      return this.price.toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2});
    },

    syllabusCourse () {
      return Object.assign({
        provider_logo: this.logo,
        syllabus: (this.course.syllabus_markdown && marked(this.course.syllabus_markdown, {renderer: this.mdRenderer}))
      }, this.course)
    },

    modalName () {
      return `syllabus-modal-${this.course.id}`;
    }
  }
}
</script>

<style lang="scss">
  @import '~elements/src/scss/config/variables.scss';

  .o-syllabus__course-syllabus > ul {
    width: auto !important;
  }

  .c-hcard\(2\.0\)__localization-details {
    @media (--desktop-min) {
      // horrible hack, coupling presentation with structure
      // TODO: refactor
      ul {
        width: calc(100% - 120px);

        li {
          width: auto;
          max-width: calc(50%);

          .c-label__text {
            min-width: 25px;
            width: auto;
            max-width: calc(100% - 25px);
            max-height: 1em;
            overflow: hidden;
          }
        }
      }
    }
  }
</style>
