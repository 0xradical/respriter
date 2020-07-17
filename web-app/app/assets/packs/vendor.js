import "../js/video_player";

// Import Tippy
import tippy from "tippy.js";
import "tippy.js/dist/tippy.css";
import Swiper from "swiper";
import AwesomeSwiper from "@cycjimmy/awesome-swiper";
import "swiper/css/swiper.css";

tippy.setDefaultProps({
  animation: "fade",
  theme: "classpert",
  arrow: true
});

tippy("[data-tippy-content]");

const swiepables = document.querySelectorAll("[data-swiepable]");

for (let index = 0; index < swiepables.length; index++) {
  const swiepable = swiepables[index];
  new AwesomeSwiper(Swiper).init(swiepable, {
    preventClicks: false,
    preventClicksPropagation: false,
    autoHeight: true,
    slidesPerView: 1.25,
    freeMode: true,
    freeModeMomentumRatio: 0.5,
    freeModeMomentumVelocityRatio: 0.75,
    spaceBetween: 20,
    pagination: null,
    navigation: null
  });
}
