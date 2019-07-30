<template>
  <div class='el:amx-D(n)@>lg'>
    <!-- video + title + pricing/cta -->
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
                          :lines='5'>
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
                           :buttonClasses="['btn--large','btn--block']">
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
    <div class='el:amx-Pt(2em) el:amx-Pb(2em)'>
      <div class='container'>
        <div class="row">
          <div class="col">
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
        <div class="row el:amx-Mt(2em)">
          <div class="col">
            <span class='el:amx-Fs(1.5em) el:amx-Fw(b)'>{{ $t('dictionary.description.header') }}</span>
              <lazy-hydrate ssr-only>
                <course-description :rootClasses="['el:amx-Pt(0.5em)']"
                                    :course="course">
                </course-description>
              </lazy-hydrate>
          </div>
        </div>
        <div class='row el:amx-Mt(2em)' v-if='course.tags && course.tags.length > 0'>
          <div class="col">
            <span class='el:amx-Fs(1.5em) el:amx-Fw(b)'>{{ $t('dictionary.tags.header') }}</span>
              <lazy-hydrate ssr-only>
                <course-tags  :course="course"
                              :rootClasses="['el:amx-Mt(0.5em)']"
                              :tagClasses="['el:amx-D(ib)','el:amx-Fs(0.75em)','el:amx-Mr(0.5em)','el:amx-Mt(0.5em)']">
                </course-tags>
              </lazy-hydrate>
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
import VideoPreview from '../../shared/VideoPreview.vue';
import CoursePricing from '../../shared/CoursePricing.vue';
import CourseTitle from '../../shared/CourseTitle.vue';
import CourseButton from '../../shared/CourseButton.vue';
import CourseSocialSharing from '../../shared/CourseSocialSharing.vue';

export default {
  props: {
    course: {
      type: Object,
      required: true
    }
  },
  components: {
    LazyHydrate,
    VideoPreview,
    CourseProvider: () => import('../../shared/CourseProvider.vue'),
    CourseTitle,
    CourseButton,
    CourseSocialSharing,
    CourseDescription: () => import('../../shared/CourseDescription.vue'),
    CourseTags: () => import('../../shared/CourseTags.vue'),
    CoursePricing,
    CourseAttributeList: () => import('../../shared/CourseAttributeList.vue')
  }
}
</script>

<style lang="scss" scoped>

</style>
