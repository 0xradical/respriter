const state = {
  loading: false
};

const mutations = {
  toggle(state, loading) {
    state.loading = loading;
  }
};

export default {
  namespaced: true,
  state,
  mutations
};
