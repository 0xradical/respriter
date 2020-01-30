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
            style="margin: 0 auto 2em auto;"
          ></vertical-card>
        </swiper-slide>
        <div class="swiper-pagination" slot="pagination"></div>
        <div
          class="swiper-button-prev"
          slot="button-prev"
          style="left: 0"
        ></div>
        <div
          class="swiper-button-next"
          slot="button-next"
          style="right: 0"
        ></div>
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
              spaceBetween: 0
            },
            992: {
              slidesPerView: 2,
              spaceBetween: 0
            },
            1200: {
              slidesPerView: 3,
              spaceBetween: 0
            },
            9999: {
              slidesPerView: 4,
              spaceBetween: 0
            }
          },
          freeMode: true,
          freeModeMomentumRatio: 0.5,
          freeModeMomentumVelocityRatio: 0.75,
          spaceBetween: 20,
          pagination: {
            el: ".swiper-pagination",
            clickable: true
          },
          navigation: {
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev"
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
