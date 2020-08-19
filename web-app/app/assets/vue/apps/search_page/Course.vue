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
        <div class="pT32 pR32 pb32 pL32">
          <course-offcanvas-desktop
            :course="course"
            @clickedCourseOffcanvas="$modal.hide(desktopOffCanvasId)"
          ></course-offcanvas-desktop>
        </div>
      </modal>
    </client-only>

    <!-- desktop card -->
    <course-card-desktop
      class="pR12 pL12 pB12 pT12 d-n@<sm fs14 fs16@>lg"
      :class="{ 'js-expanded': expanded }"
      data-chrome-ext="clsp-tagger"
      :data-chrome-ext-data="chromeExtData"
      :id="course.id"
      :course="course"
      @clickedCourseCard="$modal.show(desktopOffCanvasId)"
    ></course-card-desktop>

    <!-- mobile card -->
    <course-card-mobile
      class="pR14 pB14 pT14 pL14 cr-p d-n@>lg"
      :id="`mobile-${course.id}`"
      :course="course"
      @click="mobileClick"
      @clickedCourseCard="mobileClick"
    >
    </course-card-mobile>
  </div>
</template>

<script>
  import CourseCardDesktop from "components/CourseCardDesktop.vue";
  import CourseOffcanvasDesktop from "components/CourseOffcanvasDesktop.vue";
  import CourseCardMobile from "components/CourseCardMobile.vue";

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
      CourseCardMobile
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
      },
      coursePageLink() {
        return `/${this.course.provider_slug}/courses/${this.course.slug}`;
      }
    },
    methods: {
      mobileClick(_event) {
        if (typeof window !== undefined && typeof URL !== undefined) {
          const currentUrl = new URL(window.location);
          currentUrl.hash = `mobile-${this.course.id}`;

          if (window.history) {
            window.history.pushState(null, null, currentUrl);
          }

          window.location = this.coursePageLink;
        }
      }
    }
  };
</script>
