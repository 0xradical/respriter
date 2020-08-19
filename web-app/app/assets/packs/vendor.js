import "../js/video_player";

// Import Tippy
import tippy from "tippy.js";

import Swiper from "swiper";
import AwesomeSwiper from "@cycjimmy/awesome-swiper";
import "swiper/css/swiper.css";
import "tippy.js/dist/tippy.css";

tippy.setDefaultProps({
  arrow: true
});

document.querySelectorAll("[data-tippy-content]").forEach(tippiable =>
  tippy(tippiable, {
    appendTo: tippiable,
    theme: "classpert",
    placement: "bottom"
  })
);

document.querySelectorAll("[data-tippy-template]").forEach(tippiable => {
  const el = document.getElementById(tippiable.dataset.tippyTemplate);
  tippy(tippiable, {
    content: el.innerHTML,
    appendTo: tippiable,
    allowHTML: true,
    placement: "auto-end",
    interactiveDebounce: 50,
    interactive: true,
    theme: "classpert",
    render(instance) {
      // The recommended structure is to use the popper as an outer wrapper
      // element, with an inner `box` element
      const popper = document.createElement("div");
      const box = document.createElement("div");

      popper.appendChild(box);

      box.innerHTML = instance.props.content;

      function onUpdate(prevProps, nextProps) {
        // DOM diffing
        if (prevProps.content !== nextProps.content) {
          box.innerHTML = nextProps.content;
        }
      }

      // Return an object with two properties:
      // - `popper` (the root popper element)
      // - `onUpdate` callback whenever .setProps() or .setContent() is called
      return {
        popper,
        onUpdate // optional
      };
    },
    onHide(instance) {
      // perform your hide animation in here, then once it completes, call
      // instance.unmount()

      // Example: unmounting must be async (like a real animation)
      requestAnimationFrame(instance.unmount);
    }
  });
});

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
