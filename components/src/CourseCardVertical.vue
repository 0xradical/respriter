<template>
  <div class="el:o-vcard">
    <div class="el:o-vcard__media">
      <video-preview
        :course="course"
        :rootClasses="['el:amx-W(100%)']"
      ></video-preview>
    </div>
    <div class="el:o-vcard__content el:amx-Pos(r)">
      <div class="el:m-label el:amx-M(0.75em|0)">
        <svg class="el:m-label__icon">
          <use :xlink:href="`#providers-${course.provider_slug}`" />
        </svg>
        <span class="el:m-label__text">{{ course.provider_name }}</span>
      </div>

      <div class="el:m-text-clipbox el:amx-Mb(0.5em)">
        <div
          class="el:amx-Fs(0.875em) el:m-text-clipbox__text
        el:m-text-clipbox__text--bold
        el:m-text-clipbox__text--3-lined"
        >
          {{ course.name }}
        </div>
      </div>

      <div style="display:flex;align-items:center;" class="el:amx-Mb(0.75em)">
        <div style="width:50%;">
          <div
            v-if="instructor"
            class="el:amx-D(f) el:m-label el:amx-C_fg el:amx-M(0.75em|0) el:amx-Fs(0.75em)"
          >
            <icon
              :iconClasses="[
                'el:m-label__icon',
                'el:amx-Fs(0.8em)',
                'el:amx-Fi_fg',
                'el:amx-Mr(0.25em)'
              ]"
              name="id-badge"
              style="flex: 0 0 1em"
            >
            </icon>
            <div
              class="el:m-label__text el:amx-D(ib)"
              style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;max-width: calc(100% - 1.25em); position: relative; top: 1px;"
            >
              <a v-if="instructor.profile_path" :href="instructor.profile_path">
                {{ instructor.name }}
              </a>
              <span v-else>{{ instructor.name }}</span>
            </div>
          </div>

          <div
            v-if="course.effort"
            class="el:m-label el:amx-C_fg el:amx-M(0.75em|0) el:amx-Fs(0.75em)"
          >
            <icon
              :iconClasses="[
                'el:m-label__icon',
                'el:amx-Fs(0.8em)',
                'el:amx-Fi_fg'
              ]"
              name="clock"
              style="flex: 0 0 1em"
            >
            </icon>
            <span class="el:m-label__text">
              {{
                $t(
                  `datetime.distance_in_words.x_hours.${
                    course.effort == 1 ? "one" : "other"
                  }`,
                  { count: course.effort }
                )
              }}
            </span>
          </div>
        </div>

        <div style="width:50%;">
          <course-pricing :course="course"></course-pricing>
        </div>
      </div>

      <div class="el:amx-Pos(a) el:amx-W(100%)" style="bottom: 0">
        <a
          class="btn btn--primary-border btn--xs btn--block"
          rel="nofollow"
          target="_blank"
          :href="course.gateway_path"
          >{{ $t("dictionary.details.see") }}</a
        >
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
