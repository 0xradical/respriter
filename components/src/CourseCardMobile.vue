<template>
  <div class="fs16 el-mb:o-hcard" @click="$emit('clickedCourseCard')">
    <div class="el-mb:o-hcard__slot-0">
      <course-provider
        :rootClasses="['el:m-attribute--stretch mB8']"
        :logoClasses="['fs20 mR4']"
        :nameClasses="['fs12']"
        :course="course"
      >
      </course-provider>

      <course-title
        :course="course"
        :rootClasses="['c-fg5']"
        :titleClasses="['fs14']"
        :hyperlink="false"
      >
      </course-title>

      <div class="mT-a d-f">
        <course-attribute
          icon="id-badge"
          :rootClasses="['el:m-attribute--inline el:m-attribute--stretch']"
          style="overflow: hidden;"
          :iconClasses="['fi-fgM']"
          :labelClasses="['c-fgM']"
          v-if="instructor"
        >
          <a v-if="instructor.profile_path" :href="instructor.profile_path">
            {{ instructor.name }}
          </a>
          <span v-else>{{ instructor.name }}</span>
        </course-attribute>
        <course-attribute
          icon="clock"
          :rootClasses="[
            'el:m-attribute--inline el:m-attribute--stretch el:cmx-flex-1',
            instructor && 'mL24'
          ]"
          :iconClasses="['fi-fgM']"
          :labelClasses="['c-fgM']"
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
    </div>

    <div class="el-mb:o-hcard__slot-1">
      <course-rating :rootClasses="['mB12']"></course-rating>
      <course-pricing
        :course="course"
        :rootClasses="['ta-r']"
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
    computed: {
      instructor() {
        if (this.course.instructors && this.course.instructors.length > 0) {
          return this.course.instructors[0];
        } else {
          return null;
        }
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
