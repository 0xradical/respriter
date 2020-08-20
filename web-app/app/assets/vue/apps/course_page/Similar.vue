<template>
  <div class="d-b w100">
    <div class="fs24 fw-b">
      {{ $t("dictionary.similar.header") }}
    </div>

    <div class="mT16">
      <card-carrousel
        :list="courses"
        component="CourseCardVertical"
        property="course"
      />
    </div>
  </div>
</template>

<script>
  import CardCarrousel from "components/CardCarrousel.vue";

  export default {
    props: {
      courses: {
        type: Array,
        default() {
          return [];
        }
      }
    },
    components: {
      CardCarrousel
    }
  };
</script>
