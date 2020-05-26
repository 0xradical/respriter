<template>
  <vcard :course="course"> </vcard>
</template>

<script>
  import CourseCardVertical from "components/CourseCardVertical.vue";

  export default {
    name: "VCard",
    props: {
      course: {
        type: Object,
        required: true
      },
      locale: {
        type: String,
        required: false,
        default: "en"
      }
    },
    components: {
      vcard: CourseCardVertical
    }
  };
</script>
