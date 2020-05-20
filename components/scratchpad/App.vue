<template>
  <div class="el:amx-Mt(1em) el:amx-Mb(1em) el:amx-Ml(1em) el:amx-Mr(1em)">
    <div
      class="el:amx-Bc_white el:amx-Pt(1em) el:amx-Pb(1em) el:amx-Pl(1em) el:amx-Pr(1em)"
    >
      <course-card-desktop :course="course"></course-card-desktop>
    </div>
    <div
      class="el:amx-Bc_white el:amx-Mt(2em) el:amx-Pt(1em) el:amx-Pb(1em) el:amx-Pl(1em) el:amx-Pr(1em)"
    >
      <course-card-mobile :course="course"></course-card-mobile>
    </div>
    <div
      class="el:amx-Bc_white el:amx-Mt(2em) el:amx-Pt(1em) el:amx-Pb(1em) el:amx-Pl(1em) el:amx-Pr(1em)"
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
