<template>
  <div class="el:o-hcard-offcanvas">
    <div class="el:o-hcard-offcanvas__content-slot">
      <div class="el:o-hcard-offcanvas__header-slot el:amx-Mb(1.5em)">
        <course-provider
          :rootClasses="['el:amx-Mb(0.5em)']"
          :logoClasses="['el:amx-Fs(1.75em) el:amx-Mr(0.25em)']"
          :nameClasses="['el:amx-Fs(0.75em)']"
          :course="course"
        >
        </course-provider>

        <div aria-label="Close" @click="$emit('clickedCourseOffcanvas')">
          <icon
            name="close"
            width="1rem"
            height="1rem"
            cursor="pointer"
            class="el:amx-C_pr"
          ></icon>
        </div>
      </div>

      <div class="el:o-hcard-offcanvas__body-slot">
        <course-title
          :course="course"
          :rootClasses="['el:amx-Mb(1.75em)', 'el:amx-C_fg']"
          :titleClasses="['el:amx-Fs(1.25em)']"
        >
        </course-title>

        <div class="el:amx-D(f)">
          <div style="flex: 50%;">
            <video-preview
              style="width: auto;"
              :course="course"
              :rootClasses="['el:amx-Mr(1.75em)']"
            >
            </video-preview>
          </div>

          <course-attribute-list
            :course="course"
            :attributeClasses="['el:amx-Mb(1.125em)']"
            :attributeIconClasses="['el:amx-Fs(1.5em) el:amx-Mr(0.5em)']"
            :attributeValueClasses="['el:amx-Fs(0.875em)']"
            style="flex: 50%;"
          >
          </course-attribute-list>
        </div>

        <course-description-toggler
          :course="course"
          :rootClasses="[
            'el:amx-Mt(1.75em)',
            'el:amx-Pt(0.5em)',
            'el:amx-Pb(0.5em)',
            'el:amx-Cur(p)'
          ]"
        >
        </course-description-toggler>

        <div class="el:amx-D(f) el:amx-Mt(1.75em)">
          <course-pricing
            :course="course"
            :rootClasses="['el:amx-Mr(1.75em)']"
            style="flex: 50%;"
          >
          </course-pricing>
          <course-button
            :course="course"
            :rootClasses="['el:amx-Mt(a)', 'el:amx-Mb(a)', 'el:amx-Ta(c)']"
            :buttonClasses="['el:amx-Fs(0.75em)', 'btn--block']"
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
