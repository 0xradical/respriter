import "../js/video_player";

// Import Tippy
import tippy from "tippy.js";
import "tippy.js/dist/tippy.css";

tippy.setDefaultProps({
  animation: "fade",
  theme: "quero",
  arrow: true
});

tippy("[data-tippy-content]");
