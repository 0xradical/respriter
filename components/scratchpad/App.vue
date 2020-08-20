<template>
  <div class="mT16 mB16 mL16 mR16">
    <div class="pT16 pB16 pL16 pR16">
      <course-card-desktop :course="course"></course-card-desktop>
    </div>
    <div
      class="mT32 pT16 pB16 pL16 pR16"
    >
      <course-card-mobile :course="course"></course-card-mobile>
    </div>
    <div
      class="mT32 pT16 pB16 pL16 pR16"
    >
      <course-page-desktop :course="course"></course-page-desktop>
      <course-page-mobile :course="course"></course-page-mobile>
    </div>
  </div>
</template>
<script>
  import course from "./js/course";
  import CourseCardDesktop from "components/CourseCardDesktop.vue";
  import CourseCardMobile from "components/CourseCardMobile.vue";
  import CoursePageDesktop from "components/course_page/Desktop.vue";
  import CoursePageMobile from "components/course_page/Mobile.vue";

  export default {
    data() {
      return {
        course: course
      };
    },
    components: {
      CourseCardDesktop,
      CourseCardMobile,
      CoursePageDesktop,
      CoursePageMobile
    }
  };
</script>
