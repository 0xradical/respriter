/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_bundle_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

require("../scss/application.scss");

import { CountUp } from "countup.js";

document.querySelectorAll("[data-countup]").forEach(function (cpt) {
  let countUp = new CountUp(cpt, cpt.dataset.countupCount, {
    duration: parseFloat(cpt.dataset.countupDuration),
    startVal: parseInt(cpt.dataset.countupStartVal || 0)
  });

  window.addEventListener("scroll", function (e) {
    let pos = cpt.getBoundingClientRect();

    // checking whether fully visible
    if (
      pos.top >= 0 &&
      pos.bottom <= window.innerHeight &&
      parseInt(cpt.dataset.countupRun) == 0
    ) {
      cpt.dataset.countupRun += 1;
      countUp.start();
    }
  });
});
