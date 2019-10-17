<template>
  <div class='el:amx-D(n)@<sm'>
    <client-only>
      <promo-modal :name='promoId' :course='course'></promo-modal>
    </client-only>

    <!-- video + title + pricing/cta -->
    <div class='el:amx-Bc_white el:amx-Pt(1.5em) el:amx-Pb(2.5em)'>
      <div class='container'>
        <div class='row'>
          <div class='col-3'>
            <video-preview :course='course'
                          :rootClasses="['el:amx-W(100%)']">
            </video-preview>
          </div>
          <div class='col-6'>
            <div class='el:amx-D(f) el:amx-FxFd(c)'>
              <div class=''>
                <course-provider :rootClasses="['el:amx-Mb(0.5em)']"
                                 :logoClasses="['el:amx-Fs(1.25em)']"
                                 :nameClasses="['el:amx-Fs(0.875em)']"
                                 :course="course">
                </course-provider>

                <course-title :course='course'
                              :titleClasses="['el:amx-Fs(1.5em)']"
                              :lines='3'
                              :clickHandler="promoHandler">
                </course-title>
              </div>
            </div>
          </div>
          <div class='col-3 el:amx-D(f)'>
            <div style='position:relative;flex:1;'>
              <div style='position:absolute; bottom: 0; width: 100%;'>
                <course-pricing :course="course"
                                :priceClasses="['el:amx-Fs(1.8em)']"
                                spacing="0em"></course-pricing>
                <course-button :course="course"
                              :rootClasses="['el:amx-Mt(0.5em)']"
                              :buttonClasses="['btn--medium','btn--block']"
                              :clickHandler="promoHandler">
                </course-button>
                <course-social-sharing :course="course"
                                      :rootClasses="['el:amx-Mt(1em)','el:cmx-aright']">
                </course-social-sharing>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- description + details -->
    <div class='el:amx-Pt(4em) el:amx-Pb(4em)'>
      <div class='container'>
        <div class="row">
          <div class="col-8">
            <span class='el:amx-Fs(1.5em) el:amx-Fw(b)'>{{ $t('dictionary.description.header') }}</span>
            <div>
              <lazy-hydrate ssr-only>
                <course-description :rootClasses="['el:amx-Pt(0.5em)']"
                                    :course="course">
                </course-description>
              </lazy-hydrate>

              <div class='el:amx-Mt(2.75em)' v-if='course.curated_tags && course.curated_tags.length > 0'>
                <span class='el:amx-Fs(1.5em) el:amx-Fw(b)'>{{ $t('dictionary.tags.header') }}</span>
                <lazy-hydrate ssr-only>
                  <course-tags :course="course"
                              :rootClasses="['el:amx-Mt(0.5em)']"
                              :tagClasses="['el:amx-D(ib)','el:amx-Fs(0.75em)','el:amx-Mr(0.5em)','el:amx-Mt(0.5em)']">
                  </course-tags>
                </lazy-hydrate>
              </div>
            </div>
          </div>
          <div class="col-4">
            <div class='el:amx-Bc_white el:amx-Pt(1.5em) el:amx-Pr(1.5em) el:amx-Pb(0.375em) el:amx-Pl(1.5em)'>
              <span class='el:amx-Fs(1.25em) el:amx-Fw(b)'>{{ $t('dictionary.details.header') }}</span>
              <lazy-hydrate ssr-only>
                <course-attribute-list :course='course'
                                      :rootClasses="['el:amx-Mt(1.5em)']"
                                      :attributeClasses="['el:amx-Mb(1.125em)']"
                                      :attributeIconClasses="['el:amx-Mr(0.5em)']"
                                      :showUnavailable="false">
                </course-attribute-list>
              </lazy-hydrate>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- similar courses -->
    <div class='container'>
      <div class="row">

      </div>
    </div>
  </div>
</template>

<script>
import LazyHydrate from 'vue-lazy-hydration';
import ClientOnly from 'vue-client-only';
import VideoPreview from '../../shared/VideoPreview.vue';
import CoursePricing from '../../shared/CoursePricing.vue';
import CourseTitle from '../../shared/CourseTitle.vue';
import CourseButton from '../../shared/CourseButton.vue';
import CourseSocialSharing from '../../shared/CourseSocialSharing.vue';
import PromoModal from '../../shared/PromoModal.vue';

export default {
  props: {
    course: {
      type: Object,
      required: true
    },
    devise: {
      type: Object,
      required: false
    }
  },
  components: {
    LazyHydrate,
    ClientOnly,
    VideoPreview,
    CourseProvider: () => import('../../shared/CourseProvider.vue'),
    CourseTitle,
    CourseButton,
    CourseSocialSharing,
    CourseDescription: () => import('../../shared/CourseDescription.vue'),
    CourseTags: () => import('../../shared/CourseTags.vue'),
    CoursePricing,
    CourseAttributeList: () => import('../../shared/CourseAttributeList.vue'),
    PromoModal
  },
  computed: {
    promoId() {
      return `promo-${this.course.id}`;
    },
    promoHandler() {
      if(this.signedIn) {
        return null;
      } else {
        return (
          () => {
            this.$modal.show(this.promoId);
          }
        );
      }
    },
    signedIn() {
      if(typeof(window) === 'undefined') {
        return false
      } else {
        return window.env_context.devise.signed_in;
      }
    }
  }
}
</script>
