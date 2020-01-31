<template>
  <div class="el:amx-D(b) el:amx-W(100%)">
    <div class="el:amx-Fs(1.5em) el:amx-Fw(b)">
      {{ $t("dictionary.similar.header") }}
    </div>

    <div class="el:amx-Mt(1em)">
      <swiper :options="swiperOptions">
        <swiper-slide v-for="course in courses" :key="course.id">
          <vertical-card
            :course="course"
            class="d-none d-sm-block el:amx-Mt(0) el:amx-Mb(2em)"
          ></vertical-card>
          <vertical-card
            :course="course"
            class="d-sm-none el:amx-Mt(0) el:amx-Mb(2em)"
            style="margin-left: auto; margin-right: auto"
          ></vertical-card>
        </swiper-slide>
        <div class="swiper-pagination" slot="pagination"></div>
      </swiper>
    </div>
  </div>
</template>

<script>
  import VerticalCard from "components/CourseCardVertical.vue";

  export default {
    props: {
      courses: {
        type: Array,
        default() {
          return [];
        }
      }
    },
    data() {
      return {
        swiperOptions: {
          preventClicks: false,
          preventClicksPropagation: false,
          autoHeight: true,
          breakpoints: {
            767: {
              slidesPerView: 1,
              spaceBetween: 0,
              centeredSlides: true
            },
            992: {
              // container: 720px, space = (720px - 2*255px)/1 = 210
              slidesPerView: 2,
              spaceBetween: 210 - 28
            },
            1200: {
              // container: 960px, space = (960px - 3*255px)/2 = 65
              slidesPerView: 3,
              spaceBetween: 97.5 - 28
            },
            9999: {
              // container: 1140px, space = (1140px - 4*255px)/3 = 30
              slidesPerView: 4,
              spaceBetween: 40 - 28
            }
          },
          freeMode: true,
          freeModeMomentumRatio: 0.5,
          freeModeMomentumVelocityRatio: 0.75,
          spaceBetween: 20,
          pagination: {
            el: ".swiper-pagination",
            clickable: true
          }
        }
      };
    },
    components: {
      VerticalCard
    }
  };
</script>

<style lang="scss" scoped></style>
