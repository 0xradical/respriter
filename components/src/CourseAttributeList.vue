<template>
  <div class="clspt:course-attribute-list" :class="rootClasses">
    <course-attribute
      v-if="
        showUnavailable || (course.root_audio && course.root_audio.length > 0)
      "
      icon="audio"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template v-if="course.root_audio && course.root_audio.length > 0">
        <span class="el:amx-Tt(u)">{{ course.root_audio.join(",") }}</span>
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute
      v-if="
        showUnavailable ||
          (course.root_subtitles && course.root_subtitles.length > 0)
      "
      icon="subtitle"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template
        v-if="course.root_subtitles && course.root_subtitles.length > 0"
      >
        <span class="el:amx-Tt(u)">{{
          course.root_subtitles.slice(0, 5).join(",")
        }}</span>
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute
      v-if="showUnavailable || (course.certificate && course.certificate.type)"
      icon="certificate"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template v-if="course.certificate && course.certificate.type">
        {{ $t(`dictionary.certificate.${course.certificate.type}`) }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute
      v-if="
        showUnavailable || (course.offered_by && course.offered_by.length > 0)
      "
      icon="building"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template v-if="course.offered_by && course.offered_by.length > 0">
        {{ course.offered_by.map(i => i.name).join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute
      v-if="
        showUnavailable || (course.instructors && course.instructors.length > 0)
      "
      icon="id-badge"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template v-if="course.instructors && course.instructors.length > 0">
        {{ course.instructors.map(i => i.name).join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute
      v-if="showUnavailable || course.pace"
      icon="velocimeter"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template v-if="course.pace">
        {{ $t(`dictionary.pace.${course.pace}`) }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute
      v-if="showUnavailable || (course.level && course.level.length > 0)"
      icon="level"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template v-if="course.level && course.level.length > 0">
        {{ course.level.map(l => $t(`dictionary.levels.${l}`)).join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute
      v-if="showUnavailable || course.effort"
      icon="clock"
      :rootClasses="attributeClasses"
      :iconClasses="attributeIconClasses"
    >
      <template v-if="course.effort">
        {{
          $t(
            `datetime.distance_in_words.x_hours.${
              course.effort == 1 ? "one" : "other"
            }`,
            { count: course.effort }
          )
        }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>
  </div>
</template>

<script>
  import CourseAttribute from "./CourseAttribute.vue";

  export default {
    props: {
      course: {
        type: Object,
        required: true
      },
      showUnavailable: {
        type: Boolean,
        default: true
      },
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      attributeClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      attributeIconClasses: {
        type: Array,
        default() {
          return [];
        }
      }
    },
    components: {
      courseAttribute: CourseAttribute
    }
  };
</script>

<style lang="scss">
  .clspt\:course-attribute-list {
    // allow truncate of inner
    // flex-based elements
    min-width: 0;
  }
</style>
