<template>
  <div class="el-mb:o-hcard-offcanvas">
    <div class="el-mb:o-hcard-offcanvas__content-slot">
      <div
        class="el-mb:o-hcard-offcanvas__header-slot el:amx-Pt(1em) el:amx-Pb(2em) el:amx-Pos(r)"
      >
        <div
          class="el:amx-Pos(a)"
          aria-label="Close"
          @click="$emit('clickedCourseOffcanvas')"
          style="top: 0.875em; right: 0.875em;"
        >
          <icon
            name="close"
            width="1rem"
            height="1rem"
            class="el:amx-C_pr"
          ></icon>
        </div>
      </div>
      <div class="el-mb:o-hcard-offcanvas__body-slot">
        <div class="el:amx-Bc_white el:amx-Pt(1em) el:amx-Pb(2em)">
          <div class="container">
            <div class="row">
              <div class="col">
                <video-preview
                  :course="course"
                  :rootClasses="['el:amx-W(100%)']"
                >
                </video-preview>
              </div>
            </div>
            <div class="row el:amx-Mt(1em)">
              <div class="col">
                <div class="el:amx-D(f) el:amx-FxFd(c)">
                  <course-provider
                    :logoClasses="['el:amx-Fs(1em)']"
                    :nameClasses="['el:amx-Fs(0.875em)']"
                    :course="course"
                  >
                  </course-provider>
                </div>
              </div>
            </div>
            <div class="row el:amx-Mt(1em)">
              <div class="col">
                <course-title
                  :course="course"
                  :titleClasses="['el:amx-Fs(1.5em)']"
                  :lines="5"
                >
                </course-title>
              </div>
            </div>
            <div class="row el:amx-Mt(1.5em)">
              <div class="col-4 el:amx-D(f) el:amx-FxDi(c)">
                <course-pricing
                  :course="course"
                  :rootClasses="[
                    'el:amx-D(f)',
                    'el:amx-FxDi(c)',
                    'el:amx-FxAi(fe)',
                    'el:amx-FxJc(c)'
                  ]"
                  style="flex: 1;"
                >
                </course-pricing>
              </div>
              <div class="col-8 el:amx-D(f) el:amx-FxDi(c) el:amx-FxJc(c)">
                <course-button
                  :course="course"
                  :buttonClasses="['btn--lg', 'btn--block']"
                >
                </course-button>
              </div>
            </div>
            <div class="row el:amx-Mt(2em)">
              <div class="col">
                <course-social-sharing
                  :course="course"
                  :iconClasses="['el:amx-Fs(1.6em)']"
                  :rootClasses="['el:cmx-aright']"
                >
                </course-social-sharing>
              </div>
            </div>
          </div>
        </div>
        <!-- description + details -->
        <div class="el:amx-Pt(2em) el:amx-Pb(2em) el:amx-Bc_bg">
          <div class="container">
            <div class="row">
              <div class="col">
                <div
                  class="el:amx-Bc_su el:amx-Pt(1.5em) el:amx-Pr(1.5em) el:amx-Pb(0.375em) el:amx-Pl(1.5em)"
                >
                  <span class="el:amx-Fs(1.25em) el:amx-Fw(b)">{{
                    $t("dictionary.details.header")
                  }}</span>
                  <course-attribute-list
                    :course="course"
                    :rootClasses="['el:amx-Mt(1.5em)']"
                    :attributeClasses="['el:amx-Mb(1.125em)']"
                    :attributeIconClasses="['el:amx-Mr(0.5em)']"
                    :showUnavailable="false"
                  >
                  </course-attribute-list>
                </div>
              </div>
            </div>
            <div
              class="row el:amx-Mt(2em)"
              v-if="course.description && course.description.length > 0"
            >
              <div class="col">
                <span class="el:amx-Fs(1.5em) el:amx-Fw(b)">{{
                  $t("dictionary.description.header")
                }}</span>
                <course-description
                  :rootClasses="['el:amx-Pt(0.5em)']"
                  :course="course"
                >
                </course-description>
              </div>
            </div>
            <div
              class="row el:amx-Mt(2em)"
              v-if="course.curated_tags && course.curated_tags.length > 0"
            >
              <div class="col">
                <span class="el:amx-Fs(1.5em) el:amx-Fw(b)">{{
                  $t("dictionary.tags.header")
                }}</span>
                <course-tags
                  :course="course"
                  :rootClasses="['el:amx-Mt(0.5em)']"
                  :tagClasses="[
                    'el:amx-D(ib)',
                    'el:amx-Fs(0.75em)',
                    'el:amx-Mr(0.5em)',
                    'el:amx-Mt(0.5em)'
                  ]"
                >
                </course-tags>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import Icon from "./Icon.vue";
  import CourseProvider from "./CourseProvider.vue";
  import CourseTitle from "./CourseTitle.vue";
  import CourseTags from "./CourseTags.vue";
  import VideoPreview from "./VideoPreview.vue";
  import CourseAttributeList from "./CourseAttributeList.vue";
  import CourseDescriptionToggler from "./CourseDescriptionToggler.vue";
  import CoursePricing from "./CoursePricing.vue";
  import CourseButton from "./CourseButton.vue";
  import CourseSocialSharing from "./CourseSocialSharing.vue";
  import CourseDescription from "./CourseDescription.vue";

  export default {
    props: {
      course: {
        type: Object,
        required: true
      }
    },
    components: {
      Icon,
      CourseProvider,
      CourseTitle,
      VideoPreview,
      CourseAttributeList,
      CourseDescription,
      CourseDescriptionToggler,
      CoursePricing,
      CourseButton,
      CourseTags,
      CourseSocialSharing
    }
  };
</script>
