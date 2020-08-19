<template>
  <div class="el:o-hcard-offcanvas">
    <div class="el:o-hcard-offcanvas__content-slot">
      <div class="el:o-hcard-offcanvas__header-slot mB24">
        <course-provider
          :rootClasses="['mB8']"
          :logoClasses="['fs24 mR8']"
          :nameClasses="['fs12']"
          :course="course"
        >
        </course-provider>

        <div aria-label="Close" @click="$emit('clickedCourseOffcanvas')">
          <icon
            name="close"
            width="1rem"
            height="1rem"
            cursor="pointer"
            class="c1"
          ></icon>
        </div>
      </div>

      <div class="el:o-hcard-offcanvas__body-slot">
        <course-title
          :course="course"
          :rootClasses="['mB32', 'c-fg']"
          :titleClasses="['fs20']"
        >
        </course-title>

        <div class="d-f">
          <div style="flex: 50%;">
            <video-preview
              style="width: auto;"
              :course="course"
              :rootClasses="['mR24']"
            >
            </video-preview>
          </div>

          <course-attribute-list
            :course="course"
            :attributeClasses="['mB18']"
            :attributeIconClasses="['fs24 mR8']"
            :attributeValueClasses="['fs14']"
            style="flex: 50%;"
          >
          </course-attribute-list>
        </div>

        <course-description-toggler
          :course="course"
          :rootClasses="['mT24', 'pT8', 'pB8', 'cr-p']"
        >
        </course-description-toggler>

        <div class="d-f mT24">
          <course-pricing
            :course="course"
            :rootClasses="['mR24']"
            style="flex: 50%;"
          >
          </course-pricing>
          <course-button
            :course="course"
            :rootClasses="['mT-a', 'mB-a', 'ta-c']"
            :buttonClasses="['fs12', 'el:m-button--block']"
            style="flex: 50%;"
          >
          </course-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import Icon from "./Icon.vue";
  import CourseProvider from "./CourseProvider.vue";
  import CourseTitle from "./CourseTitle.vue";
  import VideoPreview from "./VideoPreview.vue";
  import CourseAttributeList from "./CourseAttributeList.vue";
  import CourseDescriptionToggler from "./CourseDescriptionToggler.vue";
  import CoursePricing from "./CoursePricing.vue";
  import CourseButton from "./CourseButton.vue";

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
      CourseDescriptionToggler,
      CoursePricing,
      CourseButton
    }
  };
</script>
