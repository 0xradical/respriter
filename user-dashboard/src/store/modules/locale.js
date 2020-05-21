import { operations } from "../types";

const state = {
  code: "en",
  decimalSeparator: ".",
  thousandSeparator: ",",
  dateFormat: "dd/MM/yyyy"
};

const mutations = {
  [operations.SET](state, locale) {
    state.code = locale;
    state.decimalSeparator = (1.1)
      .toLocaleString(locale || "en")
      .replace(/\d/g, "");
    state.thousandSeparator = (1000)
      .toLocaleString(locale || "en")
      .replace(/\d/g, "");
  }
};

export default {
  namespaced: true,
  state,
  mutations
};
