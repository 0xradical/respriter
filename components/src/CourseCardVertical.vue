<template>
  <div class="el:o-vcard">
    <div class="el:o-vcard__media">
      <video-preview
        :course="course"
        :rootClasses="['el:amx-W(100%)']"
      ></video-preview>
    </div>
    <div class="el:o-vcard__content el:amx-D(f) el:amx-FxDi(c)">
      <div class="el:amx-Mb(0.5em) el:amx-D(f)">
        <svg width="0.875em" height="0.875em" class="el:amx-Mr(0.25em)">
          <use :xlink:href="`#providers-${course.provider_slug}`"></use>
        </svg>
        <span class="el:amx-Fs(0.75em) el:amx-C_fg">{{
          course.provider_name
        }}</span>
      </div>

      <div
        class="el:m-text-clipbox el:m-text-clipbox--centered el:amx-Mb(0.5em)"
      >
        <div
          class="el:amx-Fs(0.875em) el:m-text-clipbox__text el:m-text-clipbox__text--bold"
        >
          {{ course.name }}
        </div>
      </div>

      <div class="el:amx-Mt(a) el:amx-Mb(0.625em) el:amx-D(f) el:amx-FxAi(c)">
        <div class="el:amx-W(50%)">
          <div v-if="instructor" class="el:amx-D(f) el:amx-Mb(0.625em)">
            <svg
              width="0.75em"
              height="0.75em"
              style="flex: 0 0 0.75em;"
              class="el:amx-Fi_fgM el:amx-Mr(0.5em)"
            >
              <use xlink:href="#icons-id-badge"></use>
            </svg>
            <a
              class="el:amx-Fs(0.75em) el:amx-D(ib) el:amx-C_fg el:cmx-text-trunc"
              style="max-width: calc(100% - 1.25em);"
              v-if="instructor.profile_path"
              :href="instructor.profile_path"
            >
              {{ instructor.name }}
            </a>
            <span
              class="el:amx-Fs(0.75em) el:amx-D(ib) el:amx-C_fg el:cmx-text-trunc"
              style="max-width: calc(100% - 1.25em);"
              v-else
              >{{ instructor.name }}</span
            >
          </div>

          <div v-if="course.effort" class="el:amx-D(f)">
            <svg
              width="0.75em"
              height="0.75em"
              style="flex: 0 0 0.75em;"
              class="el:amx-Fi_fgM el:amx-Mr(0.5em)"
            >
              <use xlink:href="#icons-clock"></use>
            </svg>
            <span class="el:amx-Fs(0.75em) el:amx-C_fgM el:amx-D(ib)">
              <ssrt
                :k="`datetime.distance_in_words.x_hours.${
                  course.effort == 1 ? 'one' : 'other'
                }`"
                :options="{ count: course.effort }"
              />
            </span>
          </div>
        </div>

        <div class="el:amx-W(50%)">
          <course-pricing :course="course"></course-pricing>
        </div>
      </div>

      <div class="el:amx-Mt(a)">
        <a
          class="btn btn--primary-border btn--xs btn--block"
          rel="nofollow"
          :href="
            course.details_path ||
            `/${course.provider_slug}/courses/${course.slug}`
          "
          ><ssrt k="dictionary.details.see"
        /></a>
      </div>
    </div>
  </div>
</template>

<script>
  import Icon from "./Icon.vue";
  import VideoPreview from "./VideoPreview.vue";
  import CoursePricing from "./CoursePricing.vue";

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
      Icon,
      VideoPreview,
      CoursePricing
    }
  };
</script>
