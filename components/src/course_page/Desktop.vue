<template>
  <div class="d-n@<sm">
    <!-- video + title + pricing/cta -->
    <div class="bc-s pT24 pB40">
      <div class="container">
        <div class="row">
          <div class="col-3">
            <video-preview
              :course="course"
              :rootClasses="['w100']"
            ></video-preview>
          </div>
          <div class="col-6">
            <div class="d-f fld-c">
              <div class="">
                <course-provider
                  :rootClasses="['mB8']"
                  :logoClasses="['fs24 mR4']"
                  :nameClasses="['fs12']"
                  :course="course"
                >
                </course-provider>

                <course-title
                  :course="course"
                  :titleClasses="['fs24']"
                  :lines="3"
                  :hyperlink="false"
                  tag="h1"
                >
                </course-title>
              </div>
            </div>
          </div>
          <div class="col-3 d-f">
            <div style="position: relative; flex: 1;">
              <div style="position: absolute; bottom: 0; width: 100%;">
                <course-pricing
                  :course="course"
                  :priceClasses="['fs32']"
                  spacing="1"
                ></course-pricing>
                <course-button
                  :course="course"
                  :rootClasses="['mT8']"
                  :buttonClasses="['el:m-button--md', 'el:m-button--block']"
                >
                </course-button>
                <course-social-sharing
                  :course="course"
                  :rootClasses="['d-f', 'mT16', 'el:cmx-aright']"
                >
                </course-social-sharing>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- description + details -->
    <div class="pT64 pB64">
      <div class="container">
        <div class="row">
          <div class="col-8">
            <span class="fs24 fw-b">{{
              $t("dictionary.description.header")
            }}</span>
            <div>
              <lazy-hydrate ssr-only>
                <course-description :rootClasses="['pT8']" :course="course">
                </course-description>
              </lazy-hydrate>

              <div
                class="mT40"
                v-if="course.curated_tags && course.curated_tags.length > 0"
              >
                <span class="fs24 fw-b">{{
                  $t("dictionary.tags.header")
                }}</span>
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
          <div class="col-4">
            <div class="bc-s pT24 pR24 pB4 pL24">
              <span class="fs20 fw-b">{{
                $t("dictionary.details.header")
              }}</span>
              <lazy-hydrate ssr-only>
                <course-attribute-list
                  :course="course"
                  :rootClasses="['mT24']"
                  :attributeClasses="['mB18']"
                  :attributeIconClasses="['fs24 mR8']"
                  :attributeValueClasses="['fs14']"
                  :showUnavailable="false"
                >
                </course-attribute-list>
              </lazy-hydrate>
            </div>
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
