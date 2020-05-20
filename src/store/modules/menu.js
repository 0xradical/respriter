const state = {
  open: false
};

const mutations = {
  open(state) {
    state.open = true;
  },

  close(state) {
    state.open = false;
  }
};
export default {
  namespaced: true,
  state,
  mutations
};
