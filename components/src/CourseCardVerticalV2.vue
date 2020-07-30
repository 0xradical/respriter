<template>
  <!-- compatible with elements v9.0.0 -->
  <div class="el:o-vcard">
    <div class="el:o-vcard__media">
      <video-preview :course="course" :rootClasses="['w100']"></video-preview>
    </div>
    <div class="d-f fld-c el:o-vcard__content">
      <div class="d-f mB8">
        <svg width="1.4rem" height="1.4rem" class="mR4">
          <use :xlink:href="`#providers-${course.provider_slug}`"></use>
        </svg>
        <span class="fs12 c-fg">{{ course.provider_name }}</span>
      </div>

      <div class="mB8 fs14 el:m-text-clipbox el:m-text-clipbox--centered">
        <div class="el:m-text-clipbox__text el:m-text-clipbox__text--bold">
          {{ course.name }}
        </div>
      </div>

      <div class="mT-a mB12 d-f ai-c">
        <div class="w50">
          <div v-if="instructor" class="d-f mB12">
            <svg
              width="1.2rem"
              height="1.2rem"
              style="flex: 0 0 1.2rem;"
              class="fi-fgM mR8"
            >
              <use xlink:href="#icons-id-badge"></use>
            </svg>
            <a
              class="fs12 d-ib c-fg mx-truncate"
              style="max-width: calc(100% - 1.25rem);"
              v-if="instructor.profile_path"
              :href="instructor.profile_path"
            >
              {{ instructor.name }}
            </a>
            <span
              class="fs12 d-ib c-fg mx-truncate"
              style="max-width: calc(100% - 1.25rem);"
              v-else
              >{{ instructor.name }}</span
            >
          </div>

          <div v-if="course.effort" class="d-f">
            <svg
              width="1.2rem"
              height="1.2rem"
              style="flex: 0 0 1.2rem;"
              class="fi-fgM mR8"
            >
              <use xlink:href="#icons-clock"></use>
            </svg>
            <span class="fs12 d-ib c-fg">
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
          target="_blank"
          :href="
            course.details_path ||
            `/${course.provider_slug}/courses/${course.slug}`
          "
        >
          <ssrt k="dictionary.details.see" />
        </a>
      </div>
    </div>
  </div>
</template>

<script>
  import Icon from "./Icon.vue";
  import VideoPreview from "./VideoPreview.vue";
  import CoursePricing from "./CoursePricingV2.vue";

  export default {
    props: {
      course: {
        type: Object,
        required: true
      },
      locale: {
        type: String,
        default: "en"
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
