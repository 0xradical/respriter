<template>
  <div class="el:amx-D(b) el:amx-W(100%)">
    <div class="el:amx-Fs(1.5em) el:amx-Fw(b)">
      {{ $t("dictionary.similar.header") }}
    </div>

    <div class="el:amx-Mt(1em)">
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
