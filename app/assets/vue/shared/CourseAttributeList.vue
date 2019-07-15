<template>
  <div class='clspt:course-attribute-list' :class='rootClasses'>
    <course-attribute icon='audio' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      <template v-if='course.root_audio.length'>
        {{ course.root_audio.join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute icon='cc' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      <template v-if='course.root_subtitles.length'>
        {{ course.root_subtitles.slice(0,5).join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute icon='certificate' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      <template v-if='course.certificate && course.certificate.type'>
        {{ $t(`dictionary.certificate.${course.certificate.type}`) }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute icon='building' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      <template v-if='course.offered_by.length'>
        {{ course.offered_by.map(i => i.name).join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute icon='nametag' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      <template v-if='course.instructors.length'>
        {{ course.instructors.map(i => i.name).join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute icon='velocimeter' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      {{ course.pace ? $t(`dictionary.pace.${course.pace}`) : $t("dictionary.not_available") }}
    </course-attribute>

    <course-attribute icon='level' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      <template v-if='course.level.length'>
        {{ course.level.map(l => $t(`dictionary.levels.${l}`)).join(",") }}
      </template>
      <template v-else>
        {{ $t("dictionary.not_available") }}
      </template>
    </course-attribute>

    <course-attribute icon='clock' :rootClasses='attributeClasses' :iconClasses='attributeIconClasses'>
      {{ course.effort ? $t(`datetime.distance_in_words.x_hours.${course.effort == 1 ? 'one' : 'other'}`, {count: course.effort}) : $t("dictionary.not_available") }}
    </course-attribute>
  </div>
</template>

<script>
import CourseAttribute from './CourseAttribute.vue';

export default {
  props: {
    course: {
      type: Object,
      required: true
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
}
</script>

<style lang="scss" scoped>
.clspt\:course-attribute-list {
  // allow truncate of inner
  // flex-based elements
  min-width: 0;
}
</style>
