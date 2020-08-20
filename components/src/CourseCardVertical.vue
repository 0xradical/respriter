<template>
  <div class="el:o-vcard">
    <div class="el:o-vcard__media">
      <video-preview :course="course" :rootClasses="['w100']"></video-preview>
    </div>
    <div class="el:o-vcard__content d-f fld-c">
      <div class="mB8 d-f">
        <svg width="0.875em" height="0.875em" class="mR4">
          <use :xlink:href="`#providers-${course.provider_slug}`"></use>
        </svg>
        <span class="fs12 c-fg">{{ course.provider_name }}</span>
      </div>

      <div class="el:m-text-clipbox el:m-text-clipbox--centered mB8">
        <div class="fs14 el:m-text-clipbox__text el:m-text-clipbox__text--bold">
          {{ course.name }}
        </div>
      </div>

      <div class="mT-a mB10 d-f ai-c">
        <div class="w50">
          <div v-if="instructor" class="d-f mB10">
            <svg
              width="0.75em"
              height="0.75em"
              style="flex: 0 0 0.75em;"
              class="fi-fgM mR8"
            >
              <use xlink:href="#icons-id-badge"></use>
            </svg>
            <a
              class="fs12 d-ib c-fg el:cmx-text-trunc"
              style="max-width: calc(100% - 1.25em);"
              v-if="instructor.profile_path"
              :href="instructor.profile_path"
            >
              {{ instructor.name }}
            </a>
            <span
              class="fs12 d-ib c-fg el:cmx-text-trunc"
              style="max-width: calc(100% - 1.25em);"
              v-else
              >{{ instructor.name }}</span
            >
          </div>

          <div v-if="course.effort" class="d-f">
            <svg
              width="0.75em"
              height="0.75em"
              style="flex: 0 0 0.75em;"
              class="fi-fgM mR8"
            >
              <use xlink:href="#icons-clock"></use>
            </svg>
            <span class="fs12 c-fgM d-ib">
              <ssrt
                :k="`datetime.distance_in_words.x_hours.${
                  course.effort == 1 ? 'one' : 'other'
                }`"
                :options="{ count: course.effort }"
              />
            </span>
          </div>
        </div>

        <div class="w50">
          <course-pricing :course="course"></course-pricing>
        </div>
      </div>

      <div class="mT-a">
        <a
          class="el:m-button el:m-button--primary-border el:m-button--xs el:m-button--block"
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
