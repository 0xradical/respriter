<template>
  <div class="swiper-container" v-swiper:mySwiper="swiperOptions">
    <div
      class="swiper-wrapper pb-0 pb-md-5 pB0@<sm pB56"
      :style="{ height }"
      ref="mySwiper"
    >
      <div
        class="swiper-slide"
        v-for="item in list"
        :key="item.id"
        :style="{ height }"
      >
        <component
          :is="component"
          :class="componentClasses"
          v-bind="{ [property]: item }"
        />
      </div>
      <div
        class="swiper-slide"
        v-if="navigation.component"
        :class="navigation.class"
        :style="{ height }"
      >
        <component :is="navigation.component" v-bind="navigation.props" />
      </div>
      <div class="swiper-slide d-block" :style="{ height }">
        <div></div>
        <!-- empty slide (guarantee last slide activation) -->
      </div>
    </div>
    <div class="d-none d-lg-block swiper-pagination" slot="pagination"></div>
  </div>
</template>

<script>
  // register dynamic components here if you intend to use
  // this carrousel with any of them
  import CourseCardVertical from "./CourseCardVertical.vue";
  import CourseCardVerticalV2 from "./CourseCardVerticalV2.vue";
  import InstructorCardVertical from "./InstructorCardVertical.vue";
  import ProviderNavCard from "./ProviderNavCard.vue";

  export default {
    props: {
      component: {
        type: String,
        required: true
      },
      componentClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      navigation: {
        type: Object,
        default() {
          return {};
        }
      },
      property: {
        type: String,
        require: true
      },
      list: {
        type: Array,
        default() {
          return [];
        }
      },
      height: {
        type: String,
        default: "350px"
      }
    },
    data() {
      return {
        swiperOptions: {
          preventClicks: false,
          preventClicksPropagation: false,
          autoHeight: false,
          breakpoints: {
            0: {
              slidesPerView: 1.75,
              spaceBetween: 16
            },
            992: {
              // container: 690px, space = (690px - 2*255px)/1 = 180
              slidesPerView: 3,
              spaceBetween: 180,
              slidesPerGroup: 2
            },
            1200: {
              // container: 930px, space = (930px - 3*255px)/2 = 82.5
              slidesPerView: 3,
              spaceBetween: 82.5,
              slidesPerGroup: 3
            },
            9999: {
              // container: 1110px, space = (1110px - 4*255px)/3 = 30
              slidesPerView: 4,
              spaceBetween: 30,
              slidesPerGroup: 4
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
      CourseCardVertical,
      CourseCardVerticalV2,
      InstructorCardVertical,
      ProviderNavCard
    }
  };
</script>

<style lang="scss" scoped>
  .swiper-container {
    box-sizing: content-box;
  }

  .swiper-pagination {
    ::v-deep .swiper-pagination-bullet + .swiper-pagination-bullet {
      margin-left: 1.375rem;
    }
    ::v-deep .swiper-pagination-bullet:only-child {
      display: none;
    }
  }
</style>
