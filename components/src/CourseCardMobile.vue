<template>
  <div class="el-mb:o-hcard" @click="$emit('clickedCourseCard')">
    <div class="el-mb:o-hcard__slot-0">
      <course-provider
        :rootClasses="['el:m-attribute--stretch el:amx-Mb(0.5em)']"
        :logoClasses="['el:amx-Fs(1.25em) el:amx-Mr(0.25em)']"
        :nameClasses="['el:amx-Fs(0.75em)']"
        :course="course"
      >
      </course-provider>

      <course-title
        :course="course"
        :rootClasses="['el:amx-C_fg5']"
        :titleClasses="['el:amx-Fs(0.875em)']"
        :hyperlink="false"
      >
      </course-title>

      <div class="el:amx-Mt(a) el:amx-D(f)">
        <course-attribute
          icon="id-badge"
          :rootClasses="[
            'el:m-attribute--inline el:m-attribute--stretch el:amx-Of(h)'
          ]"
          :iconClasses="['el:amx-Fi_fgM']"
          :labelClasses="['el:amx-C_fgM']"
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
            instructor && 'el:amx-Ml(1.5em)'
          ]"
          :iconClasses="['el:amx-Fi_fgM']"
          :labelClasses="['el:amx-C_fgM']"
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
