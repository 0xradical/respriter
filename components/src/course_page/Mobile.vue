<template>
  <div class="d-n@>lg">
    <!-- video + title + pricing/cta -->
    <div class="bc-s pT16 pB32">
      <div class="container">
        <div class="row">
          <div class="col">
            <video-preview :course="course" :rootClasses="['w100']">
            </video-preview>
          </div>
        </div>
        <div class="row mT16">
          <div class="col">
            <div class="d-f fld-c">
              <course-provider
                :rootClasses="['el:m-attribute--stretch']"
                :logoClasses="['fs20 mR4']"
                :nameClasses="['fs12']"
                :course="course"
              >
              </course-provider>
            </div>
          </div>
        </div>
        <div class="row mT16">
          <div class="col">
            <course-title
              :course="course"
              :titleClasses="['fs24']"
              :lines="5"
              :hyperlink="false"
              tag="h1"
            >
            </course-title>
          </div>
        </div>
        <div class="row mT24">
          <div class="col-4 d-f fld-c">
            <course-pricing
              :course="course"
              :rootClasses="['d-f', 'fld-c', 'ai-fe', 'jc-c']"
              style="flex: 1;"
            >
            </course-pricing>
          </div>
          <div class="col-8 d-f fld-c jc-c">
            <course-button
              :course="course"
              :buttonClasses="['el:m-button--lg', 'el:m-button--block']"
            >
            </course-button>
          </div>
        </div>
        <div class="row mT32">
          <div class="col">
            <course-social-sharing
              :course="course"
              :iconClasses="['fs24']"
              :rootClasses="['el:cmx-aright']"
            >
            </course-social-sharing>
          </div>
        </div>
      </div>
    </div>
    <!-- description + details -->
    <div class="pT32 pB32">
      <div class="container">
        <div class="row">
          <div class="col">
            <div class="bc-s pT24 pR24 pB4 pL24">
              <span class="fs20 fw-b">{{
                $t("dictionary.details.header")
              }}</span>
              <lazy-hydrate ssr-only>
                <course-attribute-list
                  :course="course"
                  :rootClasses="['mT24']"
                  :attributeClasses="['mB18']"
                  :attributeIconClasses="['fs20 mR8']"
                  :attributeValueClasses="['fs14']"
                  :showUnavailable="false"
                >
                </course-attribute-list>
              </lazy-hydrate>
            </div>
          </div>
        </div>
        <div
          class="row mT32"
          v-if="course.description && course.description.length > 0"
        >
          <div class="col">
            <span class="fs24 fw-b">{{
              $t("dictionary.description.header")
            }}</span>
            <lazy-hydrate ssr-only>
              <course-description :rootClasses="['pT8']" :course="course">
              </course-description>
            </lazy-hydrate>
          </div>
        </div>
        <div
          class="row mT32"
          v-if="course.curated_tags && course.curated_tags.length > 0"
        >
          <div class="col">
            <span class="fs24 fw-b">{{ $t("dictionary.tags.header") }}</span>
            <lazy-hydrate ssr-only>
              <course-tags
                :course="course"
                :rootClasses="['mT8']"
                :tagClasses="['d-ib', 'fs12', 'mR8', 'mT8']"
              >
              </course-tags>
            </lazy-hydrate>
          </div>
        </div>
      </div>
    </div>
    <!-- similar courses -->
    <slot name="similar"></slot>
  </div>
</template>

<script>
  import LazyHydrate from "~~lazy-hydration";
  import VideoPreview from "../VideoPreview.vue";
  import CoursePricing from "../CoursePricing.vue";
  import CourseTitle from "../CourseTitle.vue";
  import CourseButton from "../CourseButton.vue";
  import CourseSocialSharing from "../CourseSocialSharing.vue";

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
      CourseProvider: () =>
        import(
          /* webpackChunkName: "course-provider" */ "../CourseProvider.vue"
        ),
      CourseTitle,
      CourseButton,
      CourseSocialSharing,
      CourseDescription: () =>
        import(
          /* webpackChunkName: "course-description" */ "../CourseDescription.vue"
        ),
      CourseTags: () =>
        import(/* webpackChunkName: "course-tags" */ "../CourseTags.vue"),
      CoursePricing,
      CourseAttributeList: () =>
        import(
          /* webpackChunkName: "course-attribute-list" */ "../CourseAttributeList.vue"
        )
    }
  };
</script>
