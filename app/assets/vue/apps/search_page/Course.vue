<template>
  <div class="clspt:course">
    <!-- desktop offcanvas -->
    <client-only>
      <modal
        :id="desktopOffCanvasId"
        :adaptive="true"
        width="50%"
        height="auto"
        :scrollable="true"
        :name="desktopOffCanvasId"
      >
        <div
          class="el:amx-Pt(1.875em) el:amx-Pr(1.875em) el:amx-Pb(1.875em) el:amx-Pl(1.875em)"
        >
          <course-offcanvas-desktop
            :course="course"
            @clickedCourseOffcanvas="$modal.hide(desktopOffCanvasId)"
          ></course-offcanvas-desktop>
        </div>
      </modal>
    </client-only>

    <!-- desktop card -->
    <course-card-desktop
      class="el:amx-Pr(0.75em) el:amx-Pl(0.75em) el:amx-Pb(0.75em) el:amx-Pt(0.75em) el:amx-Bc_white el:amx-D(n)@<sm el:amx-Fs(0.875em) el:amx-Fs(1em)@>lg"
      :class="{ 'js-expanded': expanded }"
      data-chrome-ext="clsp-tagger"
      :data-chrome-ext-data="chromeExtData"
      :id="course.id"
      :course="course"
      @clickedCourseCard="$modal.show(desktopOffCanvasId)"
    ></course-card-desktop>

    <!-- mobile offcanvas -->
    <client-only>
      <modal
        :id="mobileOffCanvasId"
        :adaptive="true"
        width="100%"
        height="auto"
        :scrollable="true"
        :name="mobileOffCanvasId"
      >
        <course-offcanvas-mobile
          :course="course"
          @clickedCourseOffcanvas="$modal.hide(mobileOffCanvasId)"
        ></course-offcanvas-mobile>
      </modal>
    </client-only>

    <!-- mobile card -->
    <course-card-mobile
      class="el:amx-Pr(0.875em) el:amx-Pb(0.875em) el:amx-Pt(0.875em) el:amx-Pl(0.875em) el:amx-Bc_white el:amx-Cur(p) el:amx-D(n)@>lg"
      :id="`mobile-${course.id}`"
      :course="course"
      @click="$modal.show(mobileOffCanvasId)"
      @clickedCourseCard="$modal.show(mobileOffCanvasId)"
    >
    </course-card-mobile>
  </div>
</template>

<script>
import CourseCardDesktop from "components/CourseCardDesktop.vue";
import CourseOffcanvasDesktop from "components/CourseOffcanvasDesktop.vue";
import CourseCardMobile from "components/CourseCardMobile.vue";
import CourseOffcanvasMobile from "components/CourseOffcanvasMobile.vue";

export default {
  props: {
    course: {
      type: Object,
      required: true
    }
  },

  data() {
    return {
      expanded: false
    };
  },

  components: {
    CourseCardDesktop,
    CourseOffcanvasDesktop,
    CourseCardMobile,
    CourseOffcanvasMobile
  },
  computed: {
    chromeExtData() {
      return JSON.stringify({
        curated_tags: this.course.curated_tags
      });
    },
    desktopOffCanvasId() {
      return `offcanvas-${this.course.id}`;
    },
    mobileOffCanvasId() {
      return `mobile-offcanvas-${this.course.id}`;
    }
  }
};
</script>
