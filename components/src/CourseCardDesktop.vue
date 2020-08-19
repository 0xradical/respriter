<template>
  <div class="el:o-hcard">
    <div class="el:o-hcard__slot-0 mR12">
      <div style="width: 12.5em;">
        <video-preview :course="course"></video-preview>
      </div>
    </div>

    <div class="el:o-hcard__slot-1">
      <course-provider
        :rootClasses="['mB8']"
        :logoClasses="['fs24 mR8']"
        :nameClasses="['fs12']"
        :course="course"
      >
      </course-provider>
      <course-title :course="course" :rootClasses="['fs16']"> </course-title>

      <div class="mT-a">
        <course-attribute
          icon="id-badge"
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
          :rootClasses="[instructor && 'mT4']"
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

    <div class="el:o-hcard__slot-2">
      <course-pricing :course="course" style="flex: 1 1 60%;"></course-pricing>

      <div class="d-f fld-c jc-c ta-c mL12" style="flex: 0 0 40%;">
        <course-button
          :course="course"
          :buttonClasses="['mB12', 'fs10', 'el:m-button--block']"
        >
        </course-button>
        <template v-if="course.details_path || course.slug">
          <a
            class="fs10 el:m-button el:m-button--rounded el:m-button--primary-border"
            :href="
              course.details_path ||
              `/${course.provider_slug}/courses/${course.slug}`
            "
            target="_blank"
          >
            {{ $t("dictionary.details.see") }}
          </a>
        </template>
        <template v-else>
          <button
            type="button"
            @click="$emit('clickedCourseCard')"
            class="fs10 el:m-button el:m-button--rounded el:m-button--primary-border"
          >
            {{ $t("dictionary.details.see") }}
          </button>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
  import VideoPreview from "./VideoPreview.vue";
  import CourseProvider from "./CourseProvider.vue";
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
      CourseButton
    }
  };
</script>
