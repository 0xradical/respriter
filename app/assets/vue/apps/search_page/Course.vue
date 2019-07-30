<template>
  <div class='clspt:course'>
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
              <icon name='close' width='1rem' height='1rem' cursor='pointer'></icon>
            </div>
          </div>

          <div class='el:o-hcard-offcanvas__body-slot'>
            <course-title :course='course'
                          :rootClasses="['el:amx-Mb(1.75em)']"
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

        <course-title :course='course'></course-title>

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
          <course-button :course="course" :buttonClasses="['el:amx-Mb(0.75em)','el:amx-Fs(0.625em)','btn--block']"></course-button>
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
      <div class='el-mb:o-hcard-offcanvas el:amx-Pt(1em) el:amx-Pr(1em) el:amx-Pb(1em) el:amx-Pl(1em)'>
        <div class='el-mb:o-hcard-offcanvas__content-slot'>
          <div class='el-mb:o-hcard-offcanvas__header-slot'>
            <course-provider :rootClasses="['el:amx-Mb(0.5em)']"
                              :nameClasses="['el:amx-Fs(0.875em)']"
                              :course="course">
            </course-provider>

            <div aria-label="Close" @click='$modal.hide(mobileOffCanvasId)'>
              <icon name='close' width='1rem' height='1rem'></icon>
            </div>
          </div>

          <div class='el-mb:o-hcard-offcanvas__body-slot'>
            <course-title :course='course'
                          :rootClasses="['el:amx-Mb(1em)']">
            </course-title>

            <video-preview :course='course'
                            :rootClasses="['el:amx-Mb(1em)','el:amx-W(100%)']">
            </video-preview>

            <div class='el:amx-Mb(0.75em) el:amx-Pos(r)'>
              <course-pricing :course="course"
                              :rootClasses="['el:amx-Pos(a)','el:amx-Pos-b(0)', 'el:amx-Pos-r(0)']">
              </course-pricing>

              <course-attribute-list :course='course'
                                      :attributeClasses="['el:amx-Fs(0.75em)','el:amx-Mb(0.5em)']"
                                      :attributeIconClasses="['el:amx-Mr(0.5em)']"
                                      style="max-width: 60%">
              </course-attribute-list>
            </div>

            <course-description-toggler :course='course'
                                :rootClasses="['el:amx-Pt(0.5em)','el:amx-Pb(0.5em)']">
            </course-description-toggler>

            <div class='el:amx-D(f)' style='flex: 1;min-height:100px;'>
              <course-button :course='course'
                              :rootClasses="['el:amx-Ta(c)', 'el:amx-W(100%)']"
                              :buttonClasses="['el:cmx-vcenter','btn--block','el:amx-Fs(1em)']">
              </course-button>
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
    icon: Icon,
    videoPreview: VideoPreview,
    courseProvider: CourseProvider,
    courseTitle: CourseTitle,
    courseAttribute: CourseAttribute,
    courseAttributeList: CourseAttributeList,
    coursePricing: CoursePricing,
    courseButton: CourseButton,
    courseDescription: CourseDescription,
    courseDescriptionToggler: CourseDescriptionToggler,
    courseRating: CourseRating
  },

  methods: {
    mobileViewport: function() {
      let width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
      return width < 800;
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
    coursePageLink() {
      if (this.course.slug) {
        const separatorIndex = this.course.slug.indexOf("-");
        if (separatorIndex > -1) {
          const providerSlug = this.course.slug.slice(0, separatorIndex);
          const courseSlug = this.course.slug.slice(separatorIndex + 1);

          return `/${providerSlug}/courses/${courseSlug}`;

        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }
}
</script>