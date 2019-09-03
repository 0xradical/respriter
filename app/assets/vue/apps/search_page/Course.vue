<template>
  <div class='clspt:course'>
    <!-- promo -->
    <modal :adaptive="true" :width='mobileViewport() ? "100%" : "33%"' :height='mobileViewport() ? "100%" : "auto"' :scrollable='false' :name='promoId' style='z-index:1000!important'>
      <div class='el:amx-Pt(5em) el:amx-Pt(1.875em)@>lg el:amx-Pr(1.875em) el:amx-Pb(1.875em) el:amx-Pl(1.875em) el:amx-Pos(r)'>
        <div class='el:amx-Pos(a)' aria-label="Close" @click='$modal.hide(promoId)' style='top: 0.875em; right: 0.875em;'>
          <icon name='close' width='1rem' height='1rem' cursor='pointer' class='el:amx-C_blue3'></icon>
        </div>
        <div class='el:amx-Fs(1.5em) el:amx-Lh(1.5) el:amx-Fw(b) el:amx-C_gray5'>
          {{ $t('promo.title') }}
        </div>
        <div class='el:amx-Fs(1em) el:amx-Lh(1.2) el:amx-C_gray3 el:amx-Mt(1em) el:amx-Mt(0.5em)@>lg'
             v-html="$t('promo.subtitle', { benefit: `<span class='el:amx-C_magenta3 el:amx-Fw(b)'>${$t('promo.benefit')}</span>`})">
        </div>
        <div class='el:amx-Fs(0.75em) el:amx-C_gray3 el:amx-Lh(1) el:amx-Mt(1em) el:amx-Mt(0.75em)@>lg'>
          {{ $t('promo.login') }}
        </div>
        <ul class='el:amx-Mt(1.5em) el:amx-Mt(1.125em)@>lg el:amx-Mb(1.5em) el:amx-Mb(1em)@>lg' style='list-style:none;padding:0'>
          <li class='el:amx-Mb(1em) el:amx-Mb(0.5em)@>lg' v-for="provider in ['linkedin', 'github', 'facebook']" :key='provider'>
            <oauth-account
              :provider='provider'
              :authorize-url='`/user_accounts/auth/${provider}?redirect_to=${course.gateway_path}`'
              :connected='false'
              ></oauth-account>
          </li>
        </ul>
        <div class='container'>
          <div class='row'>
            <div class='col-6' style='padding-left: 0'>
              <a :href="signInLink" class='btn btn--medium btn--blue-border btn--block'>
                {{ $t('dictionary.sign_in') }}
              </a>
            </div>
            <div class='col-6' style='padding-right: 0'>
              <a :href="signUpLink" class='btn btn--medium btn--blue-border btn--block'>
                {{ $t('dictionary.sign_up') }}
              </a>
            </div>
          </div>
        </div>
        <div class='el:amx-Mt(4em) el:amx-Mt(2em)@>lg el:amx-Ta(c)'>
          <a target='_blank' :href='course.gateway_path' class='el:amx-Fs(1em) el:amx-Fw(b) el:amx-C_gray3'>
            <span class='el:amx-Lh(1em)'>{{ $t('promo.nologin') }}</span><icon name='arrow-down' transform='rotate(-90deg)' width='0.875em' height='0.875em' cursor='pointer' class='el:amx-Ml(0.25em) el:amx-C_gray3 el:amx-D(ib) el:amx-Va(m)'></icon>
          </a>
        </div>
      </div>
    </modal>

    <!-- desktop offcanvas -->
    <modal :adaptive="true" width='50%' height="auto" :scrollable="true" :name='offCanvasId'>
      <div class='el:o-hcard-offcanvas el:amx-Pt(1.875em) el:amx-Pr(1.875em) el:amx-Pb(1.875em) el:amx-Pl(1.875em)'>
        <div class='el:o-hcard-offcanvas__content-slot'>
          <div class='el:o-hcard-offcanvas__header-slot el:amx-Mb(1.5em)'>
            <course-provider :logoClasses="['el:amx-Fs(1.5em)']"
                             :nameClasses="['el:amx-Fs(0.875em)']"
                             :course="course">
            </course-provider>

            <div aria-label="Close" @click='$modal.hide(offCanvasId)'>
              <icon name='close' width='1rem' height='1rem' cursor='pointer' class='el:amx-C_blue3'></icon>
            </div>
          </div>

          <div class='el:o-hcard-offcanvas__body-slot'>
            <course-title :course='course'
                          :rootClasses="['el:amx-Mb(1.75em)','el:amx-C_gray5']"
                          :titleClasses="['el:amx-Fs(1.25em)']">
            </course-title>

            <div class='el:amx-D(f)'>
              <video-preview :course='course'
                              :rootClasses="['el:amx-Mr(1.75em)']"
                              style='flex: 50%;'>
              </video-preview>

              <course-attribute-list :course='course'
                                     :rootClasses="['el:amx-D(f)','el:amx-FxJc(sb)','el:amx-FxDi(c)']"
                                     :attributeClasses="['el:amx-Fs(0.875em)']"
                                     :attributeIconClasses="['el:amx-Mr(0.5em)']"
                                     style='flex: 50%'>
              </course-attribute-list>
            </div>

            <course-description-toggler :course='course'
                                :rootClasses="['el:amx-Mt(1.75em)','el:amx-Pt(0.5em)','el:amx-Pb(0.5em)','el:amx-Cur(p)']">
            </course-description-toggler>

            <div class='el:amx-D(f) el:amx-Mt(1.75em)'>
              <course-pricing :course="course"
                              :rootClasses="['el:amx-Mr(1.75em)']"
                              style='flex: 50%;'>
              </course-pricing>
              <course-button :course="course"
                              :rootClasses="['el:amx-Mt(a)', 'el:amx-Mb(a)', 'el:amx-Ta(c)']"
                              :buttonClasses="['el:amx-Fs(0.75em)','btn--block']"
                              style='flex: 50%;'>
              </course-button>
            </div>
          </div>
        </div>
      </div>
    </modal>

    <!-- desktop card -->
    <div data-chrome-ext='clsp-tagger' :data-chrome-ext-data='chromeExtData' :id='course.id' class='el:o-hcard el:amx-Pr(0.75em) el:amx-Pl(0.75em) el:amx-Pb(0.75em) el:amx-Pt(0.75em) el:amx-Bc_white el:amx-D(n)@<sm el:amx-Fs(0.875em) el:amx-Fs(1em)@>lg' :class="{ 'js-expanded' : expanded }">
      <div class='el:o-hcard__slot-0 el:amx-Mr(0.75em)'>
        <video-preview :course='course'></video-preview>
      </div>

      <div class='el:o-hcard__slot-1'>
        <course-provider :rootClasses="['el:amx-Mb(0.5em)']"
                         :logoClasses="['el:amx-Fs(1.25em)']"
                         :nameClasses="['el:amx-Fs(0.875em)']"
                         :course="course">
        </course-provider>

        <course-title :course='course'
                      :rootClasses="['el:amx-C_gray5']"
                      :clickHandler="promoHandler">
        </course-title>

        <course-attribute icon='clock'
                          :rootClasses="['el:amx-Mt(a)']"
                          :iconClasses="['el:amx-Fs(0.75em)']"
                          :valueClasses="['el:amx-Fs(0.75em)']"
                          v-if="course.effort">
          {{ $t(`datetime.distance_in_words.x_hours.${course.effort == 1 ? 'one' : 'other'}`, {count: course.effort}) }}
        </course-attribute>
      </div>

      <div class='el:o-hcard__slot-2'>
        <course-pricing :course="course" style='flex: 1 1 60%;'></course-pricing>

        <div class='el:amx-D(f) el:amx-FxDi(c) el:amx-FxJc(c) el:amx-Ta(c) el:amx-Ml(0.75em)' style='flex: 0 0 40%;'>
          <course-button :course="course"
                         :buttonClasses="['el:amx-Mb(0.75em)','el:amx-Fs(0.625em)','btn--block']"
                         :clickHandler="promoHandler">
          </course-button>
          <template v-if='coursePageLink'>
            <a class='el:amx-Fs(0.625em) btn btn--rounded btn--blue-border' :href='coursePageLink' target='_blank'>
              {{ $t('dictionary.details.see') }}
            </a>
          </template>
          <template v-else>
            <button type='button' @click='$modal.show(offCanvasId)' class='el:amx-Fs(0.625em) btn btn--rounded btn--blue-border'>
              {{ $t('dictionary.details.see') }}
            </button>
          </template>
        </div>
      </div>
    </div>

    <!-- mobile offcanvas -->
    <modal :id='mobileOffCanvasId' :adaptive="true" width='100%' height="auto" :scrollable="true" :name='mobileOffCanvasId'>
      <div class='el-mb:o-hcard-offcanvas'>
        <div class='el-mb:o-hcard-offcanvas__content-slot'>
          <div class='el-mb:o-hcard-offcanvas__header-slot el:amx-Pt(1em) el:amx-Pb(2em) el:amx-Pos(r)'>
            <div class='el:amx-Pos(a)' aria-label="Close" @click='$modal.hide(mobileOffCanvasId)' style='top: 0.875em; right: 0.875em;'>
              <icon name='close' width='1rem' height='1rem' class='el:amx-C_blue3'></icon>
            </div>
          </div>
          <div class='el-mb:o-hcard-offcanvas__body-slot'>
            <div class='el:amx-Bc_white el:amx-Pt(1em) el:amx-Pb(2em)'>
              <div class='container'>
                <div class='row'>
                  <div class='col'>
                    <video-preview :course='course'
                                  :rootClasses="['el:amx-W(100%)']">
                    </video-preview>
                  </div>
                </div>
                <div class='row el:amx-Mt(1em)'>
                  <div class='col'>
                    <div class='el:amx-D(f) el:amx-FxFd(c)'>
                      <course-provider  :logoClasses="['el:amx-Fs(1em)']"
                                        :nameClasses="['el:amx-Fs(0.875em)']"
                                        :course="course">
                      </course-provider>
                    </div>
                  </div>
                </div>
                <div class='row el:amx-Mt(1em)'>
                  <div class='col'>
                    <course-title :course='course'
                                  :titleClasses="['el:amx-Fs(1.5em)']"
                                  :lines='5'
                                  :clickHandler="promoHandler">
                    </course-title>
                  </div>
                </div>
                <div class='row el:amx-Mt(1.5em)'>
                  <div class='col-4 el:amx-D(f) el:amx-FxDi(c)'>
                    <course-pricing :course="course"
                                    :rootClasses="['el:amx-D(f)','el:amx-FxDi(c)','el:amx-FxAi(fe)','el:amx-FxJc(c)']"
                                    style="flex: 1;">
                    </course-pricing>
                  </div>
                  <div class='col-8 el:amx-D(f) el:amx-FxDi(c) el:amx-FxJc(c)'>
                    <course-button :course="course"
                                  :buttonClasses="['btn--large','btn--block']"
                                  :clickHandler="promoHandler">
                    </course-button>
                  </div>
                </div>
                <div class='row el:amx-Mt(2em)'>
                  <div class='col'>
                    <course-social-sharing :course="course"
                                          :iconClasses="['el:amx-Fs(1.6em)']"
                                          :rootClasses="['el:cmx-aright']">
                    </course-social-sharing>
                  </div>
                </div>
              </div>
            </div>
            <!-- description + details -->
            <div class='el:amx-Pt(2em) el:amx-Pb(2em) el:amx-Bc_gray1'>
              <div class='container'>
                <div class="row">
                  <div class="col">
                    <div class='el:amx-Bc_white el:amx-Pt(1.5em) el:amx-Pr(1.5em) el:amx-Pb(0.375em) el:amx-Pl(1.5em)'>
                      <span class='el:amx-Fs(1.25em) el:amx-Fw(b)'>{{ $t('dictionary.details.header') }}</span>
                      <course-attribute-list :course='course'
                                            :rootClasses="['el:amx-Mt(1.5em)']"
                                            :attributeClasses="['el:amx-Mb(1.125em)']"
                                            :attributeIconClasses="['el:amx-Mr(0.5em)']"
                                            :showUnavailable="false">
                      </course-attribute-list>
                    </div>
                  </div>
                </div>
                <div class="row el:amx-Mt(2em)" v-if='course.description && course.description.length > 0'>
                  <div class="col">
                    <span class='el:amx-Fs(1.5em) el:amx-Fw(b)'>{{ $t('dictionary.description.header') }}</span>
                    <course-description :rootClasses="['el:amx-Pt(0.5em)']"
                                        :course="course">
                    </course-description>
                  </div>
                </div>
                <div class='row el:amx-Mt(2em)' v-if='course.tags && course.tags.length > 0'>
                  <div class="col">
                    <span class='el:amx-Fs(1.5em) el:amx-Fw(b)'>{{ $t('dictionary.tags.header') }}</span>
                      <course-tags  :course="course"
                                    :rootClasses="['el:amx-Mt(0.5em)']"
                                    :tagClasses="['el:amx-D(ib)','el:amx-Fs(0.75em)','el:amx-Mr(0.5em)','el:amx-Mt(0.5em)']">
                      </course-tags>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </modal>

    <!-- mobile card -->
    <div :id='`mobile-${course.id}`' @click='$modal.show(mobileOffCanvasId)' class='el-mb:o-hcard el:amx-Pr(0.875em) el:amx-Pb(0.875em) el:amx-Pt(0.875em) el:amx-Pl(0.875em) el:amx-Bc_white el:amx-Cur(p) el:amx-D(n)@>lg'>
      <div class='el-mb:o-hcard__slot-0'>
        <course-provider :rootClasses="['el:amx-Mb(0.5em)']"
                        :nameClasses="['el:amx-Fs(0.75em)']"
                        :course="course">
        </course-provider>

        <course-title :course='course'
                      :rootClasses="['el:amx-C_gray5']"
                      :titleClasses="['el:amx-Fs(0.875em)']"
                      :hyperlink="false">
        </course-title>

        <course-attribute icon='clock'
                          :rootClasses="['el:amx-Mt(0.5em)']"
                          :iconClasses="['el:amx-Fs(0.75em)']"
                          :valueClasses="['el:amx-Fs(0.75em)']"
                          v-if="course.effort">
          {{ $t(`datetime.distance_in_words.x_hours.${course.effort == 1 ? 'one' : 'other'}`, {count: course.effort}) }}
        </course-attribute>
      </div>

      <div class='el-mb:o-hcard__slot-1'>
        <course-rating :rootClasses="['el:amx-Mb(0.75em)']"></course-rating>
        <course-pricing :course="course"
                        :rootClasses="['el:amx-Ta(r)']"
                        :trial-callout="false">
        </course-pricing>
      </div>
    </div>
  </div>
</template>

<script>
import Icon from '../../shared/Icon.vue';
import VideoPreview from '../../shared/VideoPreview.vue';
import CourseProvider from '../../shared/CourseProvider.vue';
import CourseTitle from '../../shared/CourseTitle.vue';
import CourseAttribute from '../../shared/CourseAttribute.vue';
import CourseAttributeList from '../../shared/CourseAttributeList.vue';
import CoursePricing from '../../shared/CoursePricing.vue';
import CourseButton from '../../shared/CourseButton.vue';
import CourseDescription from '../../shared/CourseDescription.vue';
import CourseDescriptionToggler from './CourseDescriptionToggler.vue';
import CourseRating from '../../shared/CourseRating.vue';
import CourseSocialSharing from '../../shared/CourseSocialSharing.vue';
import CourseTags from '../../shared/CourseTags.vue';
import OauthAccount from '../../shared/OauthAccount.vue';

export default {

  props: {
    course: {
      type: Object,
      required: true
    },
  },

  data () {
    return {
      expanded: false
    }
  },

  components: {
    Icon,
    VideoPreview,
    CourseProvider,
    CourseTitle,
    CourseAttribute,
    CourseAttributeList,
    CoursePricing,
    CourseButton,
    CourseDescription,
    CourseDescriptionToggler,
    CourseRating,
    CourseSocialSharing,
    CourseTags,
    OauthAccount
  },

  methods: {
    mobileViewport: function() {
      let width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
      return width < parseInt(Elements.breakpoints.lg);
    }
  },
  computed: {
    chromeExtData () {
      return JSON.stringify({
          curated_tags: this.course.curated_tags
      })
    },
    offCanvasId() {
      return `offcanvas-${this.course.id}`;
    },
    mobileOffCanvasId() {
      return `mobile-offcanvas-${this.course.id}`;
    },
    promoId() {
      return `promo-${this.course.id}`;
    },
    promoHandler() {
      // if(this.signedIn) {
        return null;
      // } else {
      //   return (
      //     () => {
      //       this.$modal.show(this.promoId);
      //     }
      //   );
      // }
    },
    coursePageLink() {
      if (this.course.slug) {
        return `/${this.course.provider_slug}/courses/${this.course.slug}`;
      } else {
        return null
      }
    },
    signInLink() {
      return `${window.env_context.devise.sign_in}?redirect_to=${this.course.gateway_path}`;
    },
    signUpLink() {
      return `${window.env_context.devise.sign_up}?redirect_to=${this.course.gateway_path}`;
    },
    signedIn() {
      return window.env_context.devise.signed_in;
    }
  }
}
</script>
