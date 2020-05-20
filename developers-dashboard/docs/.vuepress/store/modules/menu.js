const bodyScrollLock = require("body-scroll-lock");
const disableBodyScroll = bodyScrollLock.disableBodyScroll;
const enableBodyScroll = bodyScrollLock.enableBodyScroll;

const state = {
  open: false
};

const mutations = {
  open(state) {
    if (typeof document !== undefined) {
      const menu = document.getElementById("menu");
      disableBodyScroll(menu);
    }

    state.open = true;
  },

  close(state) {
    if (typeof document !== undefined) {
      const menu = document.getElementById("menu");
      enableBodyScroll(menu);
    }

    state.open = false;
  }
};
export default {
  namespaced: true,
  state,
  mutations
};
