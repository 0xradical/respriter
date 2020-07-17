<template>
  <div class="el:o-hcard">
    <div class="el:o-hcard__slot-0 el:amx-Mr(0.75em)">
      <div style="width: 12.5em;">
        <video-preview :course="course"></video-preview>
      </div>
    </div>

    <div class="el:o-hcard__slot-1">
      <course-provider
        :rootClasses="['el:amx-Mb(0.5em)']"
        :logoClasses="['el:amx-Fs(1.75em) el:amx-Mr(0.25em)']"
        :nameClasses="['el:amx-Fs(0.75em)']"
        :course="course"
      >
      </course-provider>
      <course-title :course="course"> </course-title>

      <div class="el:amx-Mt(a)">
        <course-attribute
          icon="id-badge"
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
          :rootClasses="[instructor && 'el:amx-Mt(0.25em)']"
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

    <div class="el:o-hcard__slot-2">
      <course-pricing :course="course" style="flex: 1 1 60%;"></course-pricing>

      <div
        class="el:amx-D(f) el:amx-FxDi(c) el:amx-FxJc(c) el:amx-Ta(c) el:amx-Ml(0.75em)"
        style="flex: 0 0 40%;"
      >
        <course-button
          :course="course"
          :buttonClasses="[
            'el:amx-Mb(0.75em)',
            'el:amx-Fs(0.625em)',
            'btn--block'
          ]"
        >
        </course-button>
        <template v-if="course.details_path || course.slug">
          <a
            class="el:amx-Fs(0.625em) btn btn--rounded btn--primary-border"
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
            class="el:amx-Fs(0.625em) btn btn--rounded btn--primary-border"
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
