<template>
  <div class="el-mb:o-hcard" @click="$emit('clickedCourseCard')">
    <div class="el-mb:o-hcard__slot-0">
      <course-provider
        :rootClasses="['el:amx-Mb(0.5em)']"
        :nameClasses="['el:amx-Fs(0.75em)']"
        :course="course"
      >
      </course-provider>

      <course-title
        :course="course"
        :rootClasses="['el:amx-C_gray5']"
        :titleClasses="['el:amx-Fs(0.875em)']"
        :hyperlink="false"
      >
      </course-title>

      <course-attribute
        icon="clock"
        :rootClasses="['el:amx-Mt(0.5em)']"
        :iconClasses="['el:amx-Fs(0.75em)']"
        :valueClasses="['el:amx-Fs(0.75em)']"
        v-if="course.effort"
      >
        {{
          $t(
            `datetime.distance_in_words.x_hours.${
              course.effort == 1 ? "one" : "other"
            }`,
            { count: course.effort }
          )
        }}
      </course-attribute>
    </div>

    <div class="el-mb:o-hcard__slot-1">
      <course-rating :rootClasses="['el:amx-Mb(0.75em)']"></course-rating>
      <course-pricing
        :course="course"
        :rootClasses="['el:amx-Ta(r)']"
        :trial-callout="false"
      >
      </course-pricing>
    </div>
  </div>
</template>

<script>
import VideoPreview from "./VideoPreview.vue";
import CourseProvider from "./CourseProvider.vue";
import CourseRating from "./CourseRating.vue";
import CourseTitle from "./CourseTitle.vue";
import CourseAttribute from "./CourseAttribute.vue";
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
    VideoPreview,
    CourseProvider,
    CourseTitle,
    CourseAttribute,
    CoursePricing,
    CourseButton,
    CourseRating
  }
};
</script>
